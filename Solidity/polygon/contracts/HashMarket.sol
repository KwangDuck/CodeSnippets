// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

contract HashMarket {
    enum ItemStatus {
        active,
        sold,
        removed
    }

    struct Item {
        bytes32 name;
        uint price;
        address seller;
        ItemStatus status;
    }

    event ItemAdded(bytes32 name, uint price, address seller);
    event ItemPurchased(uint itemId, address buyer, address seller);
    event ItemRemoved(uint itemId);
    event FundsPulled(address owner, uint amount);

    Item[] private _items;
    mapping(address => uint) public _pendingWithdrawls;

    modifier onlyIfItemExists(uint _itemId) {
        require(_items[_itemId].seller != address(0));
        _;
    }

    function addNewItem(bytes32 _name, uint _price) public returns (uint) {
        _items.push(Item({
            name: _name,
            price: _price,
            seller: msg.sender,
            status: ItemStatus.active
        }));

        emit ItemAdded(_name, _price, msg.sender);

        return _items.length - 1;
    }

    function getItem(uint _itemId) public view onlyIfItemExists(_itemId) returns (bytes32, uint, address, uint) {
        Item storage item = _items[_itemId];
        return (item.name, item.price, item.seller, uint(item.status));
    }

    function buyItem(uint _itemId) public payable onlyIfItemExists(_itemId) {
        Item storage item = _items[_itemId];

        require(item.status == ItemStatus.active);
        require(item.price == msg.value);

        _pendingWithdrawls[item.seller] = msg.value;

        emit ItemPurchased(_itemId, msg.sender, item.seller);
    }

    function removeItem(uint _itemId) public onlyIfItemExists(_itemId) {
        Item storage item = _items[_itemId];

        require(item.seller == msg.sender);
        require(item.status == ItemStatus.active);

        item.status = ItemStatus.removed;

        emit ItemRemoved(_itemId);
    }

    function pullFunds() public returns (bool) {
        require(_pendingWithdrawls[msg.sender] > 0);

        uint outstandingFundsAmount = _pendingWithdrawls[msg.sender];

        payable(msg.sender).transfer(outstandingFundsAmount);

        emit FundsPulled(msg.sender, outstandingFundsAmount);
        return true;
    }
}