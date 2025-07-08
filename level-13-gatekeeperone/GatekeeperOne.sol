// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
/*
    To solve this challenge we need to bypass all the 3 gate modifiers and become the "entrant"

    Gates :
    (1) require(msg.sender != tx.origin);
    We use a contract to call enter() and not directly by an EOA

    (2) require(gasleft() % 8191 == 0);
    We use a loop to brute force the right amount of gas :
    for (uint256 i = 0; i < 120; i++) {
        (bool success, ) = target.call{gas: 8191 * 3 + i}(...);
        if (success) break;
        }

    (3) require(
        uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)) &&
        uint32(uint64(_gateKey)) != uint64(_gateKey) &&
        uint32(uint64(_gateKey)) == uint16(uint160(tx.origin))
        );
    The key must end with the last 2 bytes of your address,
    be padded so it can passes the uint32 == uint16 requirement,
    and not be equal in a full uint64.

    const key = "0x000000010000" + txOrigin.slice(-4)

    Once the 3 gates are passed we have entrant = tx.origin

*/
contract GatekeeperOne {
    address public entrant;

    modifier gateOne() {
        require(msg.sender != tx.origin);
        _;
    }

    modifier gateTwo() {
        require(gasleft() % 8191 == 0);
        _;
    }

    modifier gateThree(bytes8 _gateKey) {
        require(uint32(uint64(_gateKey)) == uint16(uint64(_gateKey)), "GatekeeperOne: invalid gateThree part one");
        require(uint32(uint64(_gateKey)) != uint64(_gateKey), "GatekeeperOne: invalid gateThree part two");
        require(uint32(uint64(_gateKey)) == uint16(uint160(tx.origin)), "GatekeeperOne: invalid gateThree part three");
        _;
    }

    function enter(bytes8 _gateKey) public gateOne gateTwo gateThree(_gateKey) returns (bool) {
        entrant = tx.origin;
        return true;
    }
}