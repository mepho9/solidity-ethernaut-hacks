// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
    How the exploit works:

    The Shop contract calls buy() and checks the price from the buyer (msg.sender).
    It accepts the purchase if the buyer’s price is >= current price and the item is not sold.
    
    Our attacker contract implements price() and changes its return value dynamically.
    When buy() calls price() the first time, isSold is false, so price() returns 100 (enough to buy).
    After the purchase, isSold becomes true.
    Then buy() sets the new price to whatever price() returned.

    Next time price() is called (inside buy()), it returns 99.
    This tricks the Shop contract to set price to 99 after the item is sold.
    
    By exploiting this, we can reduce the price after purchase.

    To check success:
    target.price() == 99

*/

interface Buyer {
    function price() external view returns (uint256);
}

contract Shop {
    uint256 public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}