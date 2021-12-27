// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address payable _to, uint _amount) public {
        require(msg.sender == owner, "not owner");

        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "failed to send ether");
    }
}

contract AttackWallet {
    address payable public owner;
    Wallet wallet;

    constructor(Wallet _wallet) {
        wallet = Wallet(_wallet);
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}