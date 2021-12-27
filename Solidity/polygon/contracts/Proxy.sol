// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract Proxy {
    event Deploy(address);

    fallback() external payable {}

    function deploy(bytes memory _code) external payable returns (address addr) {
        assembly {
            addr := create(callvalue(), add(_code, 0x20), mload(_code))
        }

        require(addr != address(0), "deploy failed");

        emit Deploy(addr);
    }

    function execute(address _target, bytes memory _data) external payable {
        (bool success, ) = _target.call{value: msg.value}(_data);
        require(success, "failed");
    }
}