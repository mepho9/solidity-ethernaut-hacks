// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 14 - GatekeeperTwo
 *
 * Goal: Pass three gate modifiers to become the entrant.
 *
 * Approach:
 * - gateOne requires the caller to be a contract (msg.sender != tx.origin).
 * - gateTwo requires the caller's code size to be zero during the call, so we call from the constructor.
 * - gateThree requires a key that, when XORed with keccak256 of caller's address, equals uint64 max.
 * - We compute the key by XORing the hashed contract address with the max uint64.
 * - We deploy the attack contract, which calls enter with the correct key from its constructor.
 *
 * An external contract ("GatekeeperTwoAttacker.sol") was used for this level.
 */

contract GatekeeperTwo {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        uint256 x;
        assembly {
            x := extcodesize(caller())
        }
        require(x == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint64(bytes8(keccak256(abi.encodePacked(msg.sender)))) ^ uint64(_gateKey) == type(uint64).max);
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}