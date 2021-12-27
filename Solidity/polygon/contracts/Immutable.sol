// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Immutable {
    address public immutable MY_ADDRESS;
    uint public immutable MY_UNIT;

    constructor(uint _myUnit) {
        MY_ADDRESS = msg.sender;
        MY_UNIT = _myUnit;
    }
}