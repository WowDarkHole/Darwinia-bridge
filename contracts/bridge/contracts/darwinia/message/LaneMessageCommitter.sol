// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../../interfaces/IMessageCommitment.sol";

contract LaneMessageCommitter is Ownable {
    event Registry(uint256 outLanePos, address outboundLane, uint256 inLanePos, address inboundLane);

    uint256 public immutable thisChainPosition;
    uint256 public immutable bridgedChainPosition;
    uint256 public laneCount;
    mapping(uint256 => address) public lanes;

    constructor(uint256 _thisChainPosition, uint256 _bridgedChainPosition) public {
        require(_thisChainPosition != _bridgedChainPosition, "invalid position");
        thisChainPosition = _thisChainPosition;
        bridgedChainPosition = _bridgedChainPosition;
    }

    function registry(address outboundLane, address inboundLane) external onlyOwner {
        require(thisChainPosition == IMessageCommitment(outboundLane).thisChainPosition(), "Message: invalid ThisChainPosition");
        require(thisChainPosition == IMessageCommitment(inboundLane).thisChainPosition(), "Message: invalid ThisChainPosition");
        require(bridgedChainPosition == IMessageCommitment(outboundLane).bridgedChainPosition(), "Message: invalid chain position");
        require(bridgedChainPosition == IMessageCommitment(inboundLane).bridgedChainPosition(), "Message: invalid chain position");
        uint256 outLanePos = laneCount;
        uint256 inLanePos = laneCount + 1;
        require(outLanePos == IMessageCommitment(outboundLane).thisLanePosition(), "Message: invalid outlane position");
        require(inLanePos == IMessageCommitment(inboundLane).thisLanePosition(), "Message: invalid inlane position");
        lanes[outLanePos] = outboundLane;
        lanes[inLanePos] = inboundLane;
        laneCount += 2;
        emit Registry(outLanePos, outboundLane, inLanePos, inboundLane);
    }

    function commitment(uint256 lanePos) public view returns (bytes32) {
        address lane = lanes[lanePos];
        if (lane == address(0)) {
            return bytes32(0);
        } else {
            return IMessageCommitment(lane).commitment();
        }
    }

    // we use sparse tree to commit
    function commitment() public view returns (bytes32) {
        bytes32[] memory hashes = new bytes32[](roundUpToPow2(laneCount));
        for (uint256 pos = 0; pos < laneCount; pos++) {
            hashes[pos] = commitment(pos);
        }
        uint256 hashLength = hashes.length;
        for (uint256 j = 0; hashLength > 1; j = 0) {
            for (uint256 i = 0; i < hashLength; i = i + 2) {
                hashes[j] = keccak256(abi.encodePacked(hashes[i], hashes[i + 1]));
                j = j + 1;
            }
            hashLength = hashLength - j;
        }
        return hashes[0];
    }

    // --- Math ---
    function roundUpToPow2(uint256 len) internal pure returns (uint256) {
        if (len <= 1) return 1;
        else return 2 * roundUpToPow2((len + 1) / 2);
    }
}
