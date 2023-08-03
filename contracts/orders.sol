// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./nft.sol";

contract LedningMarket is NFT{

uint256 public creatorFee = 100;
address payable private _owner;
uint256 public _orderIdCounter;

constructor(){
    _owner= payable(msg.sender);
    initialize();
}



struct order{
    uint256 orderId;
    address payable owner;
    uint256 tokenID;
    uint256 Amount;
    bool lending;
    bool active;
}

mapping(uint256 => order) public orders;

function sell(uint256 tokenID,uint256 amount, bool lend) public {
require(ownerOf(tokenID) == msg.sender,"LendingMarket : Caller is not a Owner to sell this");
 _orderIdCounter++;
orders[_orderIdCounter]= order(_orderIdCounter,payable(msg.sender),tokenID,amount,lend,true);
_transfer(msg.sender,address(this),tokenID);
}


function buy ( uint256 orderId) payable public {
    require(orders[orderId].Amount == msg.value);
    _owner.send(creatorFee);
    orders[orderId].owner.transfer(msg.value);
    orders[orderId].active=false;
    orders[orderId].lending=false;
    _transfer(address(this),msg.sender,orders[orderId].tokenID);
}


}