// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 9 - King
 *
 * Goal: Become the king and prevent anyone else from becoming king.
 *
 * Approach:
 * - When someone becomes king, the contract sends Ether to the current king.
 * - If the current king is a contract that reverts on receiving Ether,
 *   the next player trying to become king will fail.
 * - We deploy a contract that takes the king spot, and reverts in its receive().
 *
 * An external contract (KingAttacker.sol) was used for this level.
 */

contract King {
    address king;
    uint256 public prize;
    address public owner;

    constructor() payable {
        owner = msg.sender;
        king = msg.sender;
        prize = msg.value;
    }

    receive() external payable {
        require(msg.value >= prize || msg.sender == owner);
        payable(king).transfer(msg.value);
        king = msg.sender;
        prize = msg.value;
    }

    function _king() public view returns (address) {
        return king;
    }
}