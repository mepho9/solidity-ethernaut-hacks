// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * Ethernaut Level 5 - Token
 *
 * Goal: Increase your token balance above the initial 20 tokens.
 *
 * Approach:
 * - The transfer() function uses subtraction with a require condition:
 *   require(balances[msg.sender] - _value >= 0)
 * - In Solidity 0.6, unsigned integers don't underflow safely by default.
 * - Transferring more than your balance causes an underflow, wrapping your balance to a huge number.
 * - This gives you an artificially high balance.
 * - The code used to attack in the console : await contract.transfer("0x0000000000000000000000000000000000000001", 21)
 */

contract Token {
    mapping(address => uint256) balances;
    uint256 public totalSupply;

    constructor(uint256 _initialSupply) public {
        balances[msg.sender] = totalSupply = _initialSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool) {
        require(balances[msg.sender] - _value >= 0);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        return true;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return balances[_owner];
    }
}