// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 17 - Recovery
 *
 * Goal: Recover the ether locked in the lost SimpleToken contracts.
 *
 * Approach:
 * - When Recovery calls generateToken(), it deploys a new SimpleToken contract.
 * - The deployed SimpleToken contracts are at predictable addresses (based on sender and nonce).
 * - We can compute these addresses by replicating the CREATE formula.
 * - Once we find the token contract address, we call destroy() on it to selfdestruct and send ether back.
 * - This requires calling destroy() on the right SimpleToken instances.
 *
 * Steps:
 * 1. Calculate the address of the deployed token contracts using sender address and nonce.
 * 2. Call destroy() on each found contract to recover locked ether.
 *
 * An external contract ("RecoveryAttacker.sol") was used for this level.
 */

contract Recovery {
    //generate tokens
    function generateToken(string memory _name, uint256 _initialSupply) public {
        new SimpleToken(_name, msg.sender, _initialSupply);
    }
}

contract SimpleToken {
    string public name;
    mapping(address => uint256) public balances;

    // constructor
    constructor(string memory _name, address _creator, uint256 _initialSupply) {
        name = _name;
        balances[_creator] = _initialSupply;
    }

    // collect ether in return for tokens
    receive() external payable {
        balances[msg.sender] = msg.value * 10;
    }

    // allow transfers of tokens
    function transfer(address _to, uint256 _amount) public {
        require(balances[msg.sender] >= _amount);
        balances[msg.sender] = balances[msg.sender] - _amount;
        balances[_to] = _amount;
    }

    // clean up after ourselves
    function destroy(address payable _to) public {
        selfdestruct(_to);
    }
}