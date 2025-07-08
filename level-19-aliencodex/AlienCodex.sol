
// SPDX-License-Identifier: MIT
pragma solidity ^0.5.0;

import "../helpers/Ownable-05.sol";

/**
 * Ethernaut Level 19 - AlienCodex
 *
 * Goal: Become the owner of the AlienCodex contract by exploiting storage manipulation.
 *
 * Approach:
 * - The contract has an array "codex" and a boolean "contact" that gates functions.
 * - First, we call makeContact() to set contact = true and enable interaction.
 * - Then, we call retract(), which reduces the array length without proper underflow protection.
 * - This causes the array length to underflow and become very large, allowing out-of-bounds writes.
 * - Using this, we calculate the storage slot for the owner variable based on Solidity storage layout.
 * - We craft an index to overwrite the owner slot by calling revise() with that index.
 * - Finally, we set ourselves as the new owner by writing our address into the owner slot.
 *
 * An external contract ("AlienCodexAttacker.sol.sol") was used for this level.
 */

contract AlienCodex is Ownable {
    bool public contact;
    bytes32[] public codex;

    modifier contacted() {
        assert(contact);
        _;
    }

    function makeContact() public {
        contact = true;
    }

    function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

    function retract() public contacted {
        codex.length--;
    }

    function revise(uint256 i, bytes32 _content) public contacted {
        codex[i] = _content;
    }
}
