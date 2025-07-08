// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;

import "openzeppelin-contracts-06/math/SafeMath.sol";

/**
 * Ethernaut Level 10 - Reentrance
 *
 * Goal: Drain all Ether from the contract using a reentrancy attack.
 *
 * Approach:
 * - The withdraw() function sends Ether before updating the user’s balance.
 * - This allows us to re-enter withdraw() before our balance is set to 0.
 * - We deploy a contract that donates to itself, then repeatedly calls withdraw().
 * - Each reentrant call extracts more funds before the balance is reduced.
 *
 * An external contract (ReentranceAttacker.sol) was used for this level.
 */

contract Reentrance {
    using SafeMath for uint256;

    mapping(address => uint256) public balances;

    function donate(address _to) public payable {
        balances[_to] = balances[_to].add(msg.value);
    }

    function balanceOf(address _who) public view returns (uint256 balance) {
        return balances[_who];
    }

    function withdraw(uint256 _amount) public {
        if (balances[msg.sender] >= _amount) {
            (bool result,) = msg.sender.call{value: _amount}("");
            if (result) {
                _amount;
            }
            balances[msg.sender] -= _amount;
        }
    }

    receive() external payable {}
}