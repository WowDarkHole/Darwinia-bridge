// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.7.0;

contract MockApp {
    event Unlocked(bytes32 from, address to, uint256 amount);
    function unlock(bytes32 polkdotSender, address recipient, uint256 amount) public {
        emit Unlocked(polkdotSender, recipient, amount);
    }
}
