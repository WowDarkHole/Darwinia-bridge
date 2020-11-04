pragma solidity >=0.5.0 <0.6.0;

library Memory {

    uint internal constant WORD_SIZE = 32;
	
	// Returns a memory pointer to the data portion of the provided bytes array.
	function dataPtr(bytes memory bts) internal pure returns (uint addr) {
		assembly {
			addr := add(bts, /*BYTES_HEADER_SIZE*/32)
		}
	}

	// Creates a 'bytes memory' variable from the memory address 'addr', with the
	// length 'len'. The function will allocate new memory for the bytes array, and
	// the 'len bytes starting at 'addr' will be copied into that new memory.
	function toBytes(uint addr, uint len) internal pure returns (bytes memory bts) {
		bts = new bytes(len);
		uint btsptr;
		assembly {
			btsptr := add(bts, /*BYTES_HEADER_SIZE*/32)
		}
		copy(addr, btsptr, len);
	}
	
	// Copies 'self' into a new 'bytes memory'.
	// Returns the newly created 'bytes memory'
	// The returned bytes will be of length '32'.
	function toBytes(bytes32 self) internal pure returns (bytes memory bts) {
		bts = new bytes(32);
		assembly {
			mstore(add(bts, /*BYTES_HEADER_SIZE*/32), self)
		}
	}

	// Copy 'len' bytes from memory address 'src', to address 'dest'.
	// This function does not check the or destination, it only copies
	// the bytes.
	function copy(uint src, uint dest, uint len) internal pure {
		// Copy word-length chunks while possible
		for (; len >= WORD_SIZE; len -= WORD_SIZE) {
			assembly {
				mstore(dest, mload(src))
			}
			dest += WORD_SIZE;
			src += WORD_SIZE;
		}

		// Copy remaining bytes
		uint mask = 256 ** (WORD_SIZE - len) - 1;
		assembly {
			let srcpart := and(mload(src), not(mask))
			let destpart := and(mload(dest), mask)
			mstore(dest, or(destpart, srcpart))
		}
	}

	// This function does the same as 'dataPtr(bytes memory)', but will also return the
	// length of the provided bytes array.
	function fromBytes(bytes memory bts) internal pure returns (uint addr, uint len) {
		len = bts.length;
		assembly {
			addr := add(bts, /*BYTES_HEADER_SIZE*/32)
		}
	}
}
