
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Ethernaut Level 18 - MagicNumber
 *
 * Goal: Set a contract as the solver that returns 42 when calling whatIsTheMeaningOfLife().
 *
 * Approach:
 * - The main contract expects an external contract at "solver" address with a specific function.
 * - Instead of writing a full Solidity contract, we deploy minimal EVM bytecode directly using assembly.
 * - The bytecode returns 42 (0x2a in hex) when the function is called.
 * - The deployed contract uses the following minimal runtime code:
 *     0x602a60005260206000f3 
 *     (push 42, store in memory, return memory)
 * - This is wrapped with init code:
 *     0x69602a60005260206000f3600052600a6016f3
 * - We deploy this using "create", then call setSolver with the resulting address.
 *
 * An external contract ("MagicNumberAttacker.sol") was used for this level.
 */

contract MagicNum {
    address public solver;

    constructor() {}

    function setSolver(address _solver) public {
        solver = _solver;
    }

    /*
    ____________/\\\_______/\\\\\\\\\_____        
     __________/\\\\\_____/\\\///////\\\___       
      ________/\\\/\\\____\///______\//\\\__      
       ______/\\\/\/\\\______________/\\\/___     
        ____/\\\/__\/\\\___________/\\\//_____    
         __/\\\\\\\\\\\\\\\\_____/\\\//________   
          _\///////////\\\//____/\\\/___________  
           ___________\/\\\_____/\\\\\\\\\\\\\\\_ 
            ___________\///_____\///////////////__
    */
}