// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 4 - Telephone
 *
 * Goal: Become the owner of the contract.
 *
 * Approach:
 * - The contract uses tx.origin != msg.sender to restrict access.
 * - This can be bypassed by calling changeOwner() from another contract.
 * - We deploy an Attacker contract that calls changeOwner() on our behalf.
 * - This makes msg.sender the attacker contract, and tx.origin is still us.
 *
 * An external contract (TelephoneAttacker.sol) was used to bypass the tx.origin check.
 */

contract Telephone {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    function changeOwner(address _owner) public {
        if (tx.origin != msg.sender) {
            owner = _owner;
        }
    }
}