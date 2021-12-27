// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/HelloWorld.sol";

contract TestHelloWorld {
    
    function testHello() public {
        HelloWorld token = HelloWorld(DeployedAddresses.HelloWorld());

        Assert.equal(token.greet, "Hello World!", "");
    }
}