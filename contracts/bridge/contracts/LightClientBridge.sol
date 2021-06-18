// SPDX-License-Identifier: Apache-2.0

pragma solidity >=0.6.0 <0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/proxy/Initializable.sol";
import "@darwinia/contracts-utils/contracts/Pausable.sol";
import "@darwinia/contracts-utils/contracts/ECDSA.sol";
import "@darwinia/contracts-utils/contracts/SafeMath.sol";
import "@darwinia/contracts-utils/contracts/Bits.sol";
import "@darwinia/contracts-utils/contracts/Bitfield.sol";
import "@darwinia/contracts-utils/contracts/ScaleCodec.sol";
import "@darwinia/contracts-verify/contracts/MerkleProof.sol";
import "@darwinia/contracts-verify/contracts/MMR.sol";
import "./ValidatorRegistry.sol";

contract LightClientBridge is Pausable, Initializable, ValidatorRegistry {
    using SafeMath for uint256;
    using Bits for uint256;
    using Bitfield for uint256[];
    using ScaleCodec for uint64;

    /* Events */

    /**
     * @notice Notifies an observer that the prover's attempt at initital
     * verification was successful.
     * @dev Note that the prover must wait until `n` blocks have been mined
     * subsequent to the generation of this event before the 2nd tx can be sent
     * @param prover The address of the calling prover
     * @param blockNumber The blocknumber in which the initial validation
     * succeeded
     * @param id An identifier to provide disambiguation
     */
    event InitialVerificationSuccessful(
        address prover,
        uint256 blockNumber,
        uint256 id
    );

    /**
     * @notice Notifies an observer that the complete verification process has
     *  finished successfuly and the new commitmentHash will be accepted
     * @param prover The address of the successful prover
     * @param commitmentHash the commitmentHash which was approved for inclusion
     * @param id the identifier used
     */
    event FinalVerificationSuccessful(
        address prover,
        bytes32 commitmentHash,
        uint256 id
    );

    event NewMMRRoot(bytes32 mmrRoot, uint256 blockNumber);

    /* Types */

    struct NextValidatorSet {
        bytes32 root;
        uint64 id;
        uint64 len; 
    }

    struct Payload {
        bytes32 mmr;
        NextValidatorSet nextValidatorSet; 
    }

    struct Commitment {
        Payload payload;
        uint64 blockNumber;
        uint64 validatorSetId;
    }

    struct ValidationData {
        bytes32 commitmentHash;
        uint256[] validatorClaimsBitfield;
        uint256 blockNumber;
    }

    /* State */

    uint256 public currentId;
    bytes32 public latestMMRRoot;
    uint256 public latestBlockNumber;
    mapping(uint256 => ValidationData) public validationData;

    /* Constants */

    uint256 public constant PICK_NUMERATOR = 1;
    uint256 public constant THRESHOLD_NUMERATOR = 2;
    uint256 public constant THRESHOLD_DENOMINATOR = 3;
    uint256 public constant BLOCK_WAIT_PERIOD = 45;

    /**
     * @notice Deploys the LightClientBridge contract
     * @param _validatorSetId initial validator set id
     * @param _validatorSetRoot initial validator set merkle tree root
     * @param _numOfValidators number of initial validator set
     */
    function initialize(bytes32 _validatorSetRoot, uint256 _validatorSetId, uint256 _numOfValidators)
        public
        initializer
    {
        ownableConstructor();
        pausableConstructor();

        _update(_validatorSetRoot, _validatorSetId, _numOfValidators);
    }

    /* Public Functions */

    function getFinalizedBlockNumber() external view returns (uint256) {
        return latestBlockNumber;
    }

    /**
     * @notice Executed by the apps in order to verify commitment
     * @param beefyMMRLeaf contains the merkle leaf
     * @param beefyMMRLeafIndex contains the merkle leaf index
     * @param beefyMMRLeafCount contains the merkle leaf count
     * @param peaks contains the merkle maintain range peaks
     * @param siblings contains the merkle maintain range siblings
     */
    function verifyBeefyMerkleLeaf(
        bytes calldata beefyMMRLeaf,
        uint256 beefyMMRLeafIndex,
        uint256 beefyMMRLeafCount,
        bytes32[] calldata peaks,
        bytes32[] calldata siblings 
    ) external view returns (bool) {
        return
            MMR.inclusionProof(
                latestMMRRoot,
                beefyMMRLeafCount,
                beefyMMRLeafIndex,
                beefyMMRLeaf,
                peaks,
                siblings
            );
    }

    /**
     * @notice Executed by the prover in order to begin the process of block
     * acceptance by the light client
     * @param commitmentHash contains the commitmentHash signed by the validator(s)
     * @param validatorClaimsBitfield a bitfield containing a membership status of each
     * validator who has claimed to have signed the commitmentHash
     * @param validatorSignature the signature of one validator
     * @param validatorPosition the position of the validator, index starting at 0
     * @param validatorPublicKey the public key of the validator
     * @param validatorPublicKeyMerkleProof proof required for validation of the public key in the validator merkle tree
     */
    function newSignatureCommitment(
        bytes32 commitmentHash,
        uint256[] memory validatorClaimsBitfield,
        bytes memory validatorSignature,
        uint256 validatorPosition,
        address validatorPublicKey,
        bytes32[] memory validatorPublicKeyMerkleProof
    ) public payable whenNotPaused {
        /**
         * @dev Check if validatorPublicKeyMerkleProof is valid based on ValidatorRegistry merkle root
         */
        require(
            checkValidatorInSet(
                validatorPublicKey,
                validatorPosition,
                validatorPublicKeyMerkleProof
            ),
            "Error: Validator must be in validator set at correct position"
        );

        /**
         * @dev Check if validatorSignature is correct, ie. check if it matches
         * the signature of senderPublicKey on the commitmentHash
         */
        require(
            ECDSA.recover(commitmentHash, validatorSignature) ==
                validatorPublicKey,
            "Error: Invalid Signature"
        );

        /**
         * @dev Check that the bitfield actually contains enough claims to be succesful, ie, > 2/3
         */
        require(
            validatorClaimsBitfield.countSetBits() >
                (numOfValidators * THRESHOLD_NUMERATOR) /
                    THRESHOLD_DENOMINATOR,
            "Error: Bitfield not enough validators"
        );

        /**
         * @todo Lock up the sender stake as collateral
         */
        // TODO

        // Accept and save the commitment
        validationData[currentId] = ValidationData(
            commitmentHash,
            validatorClaimsBitfield,
            block.number
        );

        emit InitialVerificationSuccessful(msg.sender, block.number, currentId);

        currentId = currentId.add(1);
    }

    /**
     * @notice Performs the second step in the validation logic
     * @param id an identifying value generated in the previous transaction
     * @param commitment contains the full commitment that was used for the commitmentHash
     * @param signatures an array of signatures from the randomly chosen validators
     * @param validatorPositions an array of bitfields from the chosen validators
     * @param validatorPublicKeys an array of the public key of each signer
     * @param validatorPublicKeyMerkleProofs an array of merkle proofs from the chosen validators
     */
    function completeSignatureCommitment(
        uint256 id,
        Commitment memory commitment,
        bytes[] memory signatures,
        uint256[] memory validatorPositions,
        address[] memory validatorPublicKeys,
        bytes32[][] memory validatorPublicKeyMerkleProofs
    ) public whenNotPaused {
        // only current epoch
        require(commitment.validatorSetId == validatorSetId, "Error: Invalid validator set id");

        ValidationData storage data = validationData[id];

        /**
         * verify that block wait period has passed
         */
        require(
            block.number >= data.blockNumber.add(BLOCK_WAIT_PERIOD),
            "Error: Block wait period not over"
        );

        /**
         * Encode and hash the commitment
         */
        bytes32 commitmentHash =
            keccak256(
                abi.encodePacked(
                    abi.encodePacked(
                        commitment.payload.mmr,
                            abi.encodePacked(
                                commitment.payload.nextValidatorSet.root,
                                commitment.payload.nextValidatorSet.id.encode64(),
                                commitment.payload.nextValidatorSet.len.encode64()
                            )
                    ),
                    commitment.blockNumber.encode64(),
                    commitment.validatorSetId.encode64()
                )
            );

        require(
            commitmentHash == data.commitmentHash,
            "Error: Commitment must match commitment hash"
        );


        /**
         * @dev verify that sender is the same as in `newSignatureCommitment`
         */
        // require(
        //     msg.sender == data.senderAddress,
        //     "Error: Sender address does not match original validation data"
        // );

        verifySigatures(
            commitmentHash,
            data.blockNumber,
            data.validatorClaimsBitfield,
            signatures,
            validatorPositions,
            validatorPublicKeys,
            validatorPublicKeyMerkleProofs
        );

        /**
         * @follow-up Do we need a try-catch block here?
         */
        processPayload(commitment.payload, commitment.blockNumber);

        emit FinalVerificationSuccessful(msg.sender, commitmentHash, id);

        /**
         * @dev We no longer need the data held in state, so delete it for a gas refund
         */
        delete validationData[id];
    }

    /* Private Functions */

    function verifySigatures(
        bytes32 commitmentHash,
        uint256 blockNumber,
        uint256[] memory validatorClaimsBitfield,
        bytes[] memory signatures,
        uint256[] memory validatorPositions,
        address[] memory validatorPublicKeys,
        bytes32[][] memory validatorPublicKeyMerkleProofs
    ) 
        private
        view
    {
        uint256 requiredNumOfSignatures =
            (numOfValidators * PICK_NUMERATOR) /
                THRESHOLD_DENOMINATOR;

        /**
         * @dev verify that required number of signatures, positions, public keys and merkle proofs are
         * submitted
         */
        require(
            signatures.length == requiredNumOfSignatures,
            "Error: Number of signatures does not match required"
        );
        require(
            validatorPositions.length == requiredNumOfSignatures,
            "Error: Number of validator positions does not match required"
        );
        require(
            validatorPublicKeys.length == requiredNumOfSignatures,
            "Error: Number of validator public keys does not match required"
        );
        require(
            validatorPublicKeyMerkleProofs.length == requiredNumOfSignatures,
            "Error: Number of validator public keys does not match required"
        );

        /**
         * @dev Generate an array of numbers
         */
        uint256[] memory randomBitfield =
            Bitfield.randomNBitsFromPrior(
                getSeed(blockNumber),
                validatorClaimsBitfield,
                requiredNumOfSignatures
            );

        /**
         *  @dev For each randomSignature, do:
         */
        for (uint256 i = 0; i < requiredNumOfSignatures; i++) {
            /**
             * @dev Check if validator in randomBitfield
             */
            require(
                randomBitfield.isSet(validatorPositions[i]),
                "Error: Validator must be once in bitfield"
            );

            /**
             * @dev Remove validator from randomBitfield such that no validator can appear twice in signatures
             */
            randomBitfield.clear(validatorPositions[i]);

            /**
             * @dev Check if merkle proof is valid
             */
            require(
                checkValidatorInSet(
                    validatorPublicKeys[i],
                    validatorPositions[i],
                    validatorPublicKeyMerkleProofs[i]
                ),
                "Error: Validator must be in validator set at correct position"
            );

            /**
             * @dev Check if signature is correct
             */
            require(
                ECDSA.recover(commitmentHash, signatures[i]) ==
                    validatorPublicKeys[i],
                "Error: Invalid Signature"
            );
        }
    }

    /**
     * @notice Deterministically generates a seed from the block hash at the block number of creation of the validation
     * data plus MAXIMUM_NUM_SIGNERS
     * @dev Note that `blockhash(blockNum)` will only work for the 256 most recent blocks. If
     * `completeSignatureCommitment` is called too late, a new call to `newSignatureCommitment` is necessary to reset
     * validation data's block number
     * @param blockNumber block number
     * @return onChainRandNums an array storing the random numbers generated inside this function
     */
    function getSeed(uint256 blockNumber)
        private
        view
        returns (uint256)
    {
        uint256 randomSeedBlockNum = blockNumber.add(BLOCK_WAIT_PERIOD);
        // @note Create a hash seed from the block number
        bytes32 randomSeedBlockHash = blockhash(randomSeedBlockNum);

        return uint256(randomSeedBlockHash);
    }

    /**
     * @notice Perform some operation[s] using the payload
     * @param payload The payload variable passed in via the initial function
     * @param blockNumber The blockNumber variable passed in via the initial function
     */
    function processPayload(Payload memory payload, uint256 blockNumber) private {
        // Check the payload is newer than the latest
        // Check that payload.leaf.block_number is > last_known_block_number;
        require(blockNumber > latestBlockNumber, "Error: Import old block");
        latestMMRRoot = payload.mmr;
        latestBlockNumber = blockNumber;
        emit NewMMRRoot(latestMMRRoot, blockNumber);

        // if payload is in next epoch, then apply validatorset changes
        // if payload is not in current or next epoch, reject
        // TODO: check nextValidatorSet can null or not
        require(payload.nextValidatorSet.id == 0 || payload.nextValidatorSet.id == validatorSetId + 1, "Invalid next validator set id");
        if (payload.nextValidatorSet.id == validatorSetId + 1) {
            _update(payload.nextValidatorSet.root, payload.nextValidatorSet.id, payload.nextValidatorSet.len);
        }
    }

}
