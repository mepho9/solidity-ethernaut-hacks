// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 11 - Elevator
 *
 * Goal: Reach the top of the elevator by setting top = true.
 *
 * Approach:
 * - The contract calls isLastFloor() twice in the goTo() function.
 * - We can exploit this by making the first call return false and the second true.
 * - We deploy a contract implementing the Building interface and use a boolean toggle.
 *
 * An external contract (ElevatorAttacker.sol) was used for this level.
 */

interface Building {
    function isLastFloor(uint256) external returns (bool);
}

contract Elevator {
    bool public top;
    uint256 public floor;

    function goTo(uint256 _floor) public {
        Building building = Building(msg.sender);

        if (!building.isLastFloor(_floor)) {
            floor = _floor;
            top = building.isLastFloor(floor);
        }
    }
}