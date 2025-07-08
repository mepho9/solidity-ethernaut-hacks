// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 1 - Fallback
 *
 * Goal: Become the owner of the contract and withdraw all funds.
 *
 * Approach:
 * - First, call contribute() with a small amount (< 0.001 ether).
 * - Then, send ether directly to the contract to trigger receive().
 * - If you already contributed, receive() sets you as the new owner.
 * - Once owner, call withdraw() to empty the contract.
 *
 */

contract Fallback {
    mapping(address => uint256) public contributions;
    address public owner;

    constructor() {
        owner = msg.sender;
        contributions[msg.sender] = 1000 * (1 ether);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "caller is not the owner");
        _;
    }

    function contribute() public payable {
        require(msg.value < 0.001 ether);
        contributions[msg.sender] += msg.value;
        if (contributions[msg.sender] > contributions[owner]) {
            owner = msg.sender;
        }
    }

    receive() external payable {
        require(msg.value > 0 && contributions[msg.sender] > 0);
        owner = msg.sender;
    }

    function withdraw() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function getContribution() public view returns (uint256) {
        return contributions[msg.sender];
    }
}
