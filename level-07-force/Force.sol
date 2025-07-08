// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 7 - Force
 *
 * Goal: Send Ether to a contract that has no payable functions or receive() fallback.
 *
 * Approach:
 * - The target contract cannot normally receive Ether via standard send/transfer/call.
 * - But selfdestruct() can forcibly send Ether to any address.
 * - We deploy a contract that receives Ether, then selfdestructs to send its balance to the target.
 *
 * - Deploy ForceAttacker with some ETH, then call destroy(target).
 *
 * An external contract (ForceAttacker.sol) was used to send Ether via selfdestruct.
 */

contract Force { /*
                   MEOW ?
         /\_/\   /
    ____/ o o \
    /~____  =ø= /
    (______)__m_m)
                   */ }