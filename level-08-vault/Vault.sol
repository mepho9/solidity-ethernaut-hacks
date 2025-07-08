// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    Unlock the vault by passing "unlock(bytes16 _key)

    as the password is stored in the storage slot 1 as a byes32 private password,
    even if it is private, it is publicly accessible with storage system.

    to read : 
    await web3.eth.getStorageAt(contract.address, 1)
    
    we extract the 16 first bytes, because -> "0x" + 32 hex chars :
    const key = full.slice(0, 34)

    to unlock it :
    await contract.unlock(key)
    
*/

contract Vault {
    bool public locked;
    bytes32 private password;

    constructor(bytes32 _password) {
        locked = true;
        password = _password;
    }

    function unlock(bytes32 _password) public {
        if (password == _password) {
            locked = false;
        }
    }
}