// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 20 - Denial
 *
 * Goal: Prevent the owner from withdrawing funds by blocking the withdraw function.
 *
 * Explanation:
 * - The contract splits the balance and sends 1% to the withdrawal partner and 1% to the owner.
 * - It sends ether to the partner using a low-level call, without checking if it succeeds or reverts.
 * - If the partner’s fallback or receive function uses excessive gas or reverts, it can block the withdraw process.
 * - This denial of service prevents the owner from receiving their share.
 *
 * Approach:
 * - Deploy a malicious contract as the partner.
 * - In the fallback or receive function of the partner, consume all gas or revert infinitely.
 * - Set this contract as the partner using setWithdrawPartner().
 * - When withdraw is called, the partner’s fallback will block or consume gas, preventing owner’s withdrawal.
 *
 * An external contract ("DenialAttacker.sol") was used for this level.
 */

contract Denial {
    address public partner; // withdrawal partner - pay the gas, split the withdraw
    address public constant owner = address(0xA9E);
    uint256 timeLastWithdrawn;
    mapping(address => uint256) withdrawPartnerBalances; // keep track of partners balances

    function setWithdrawPartner(address _partner) public {
        partner = _partner;
    }

    // withdraw 1% to recipient and 1% to owner
    function withdraw() public {
        uint256 amountToSend = address(this).balance / 100;
        // perform a call without checking return
        // The recipient can revert, the owner will still get their share
        partner.call{value: amountToSend}("");
        payable(owner).transfer(amountToSend);
        // keep track of last withdrawal time
        timeLastWithdrawn = block.timestamp;
        withdrawPartnerBalances[partner] += amountToSend;
    }

    // allow deposit of funds
    receive() external payable {}

    // convenience function
    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}