// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "./nft.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract LendingMarket is NFT{

uint256 public PROTOCOL_FEE = 10;
address payable private _owner;
uint256 public _orderIdCounter;
uint256 public _borrowIdCounter;

constructor(address _nativeToken){
    _owner= payable(msg.sender);
    initialize(_nativeToken);
    NativeToken=ERC20(_nativeToken);
}



struct order{
    uint256 orderId;
    address  owner;
    uint256 tokenID;
    uint256 Amount;
    bool lending;
    bool active;
    bool lended;
}

struct borrows{
    uint256 borrowId;
    uint256 tokenId;
    uint256 interst;
    uint256 starttime;
    uint256 endtime;
    uint256 amount;
    address  borrower;
    address  owner;
    bool active;
}

mapping(uint256 => order) public orders;
mapping(uint256 => borrows) public borrowOrders;

function sell(uint256 tokenID,uint256 amount, bool lend) public {
require(ownerOf(tokenID) == msg.sender,"LendingMarket : Caller is not a Owner to sell this");
 _orderIdCounter++;
orders[_orderIdCounter]= order(_orderIdCounter,payable(msg.sender),tokenID,amount,lend,true,false);
_transfer(msg.sender,address(this),tokenID);
}

function buy ( uint256 orderId) payable public {
    require(!orders[orderId].lended,"LENDING MARKET: This order is not for sale");

    NativeToken.transferFrom(msg.sender,owner(),PROTOCOL_FEE);
    NativeToken.transferFrom(msg.sender,orders[orderId].owner,orders[orderId].Amount-PROTOCOL_FEE);
    orders[orderId].active=false;
    orders[orderId].lending=false;
    _transfer(address(this),msg.sender,orders[orderId].tokenID);
}


function borrow(uint256 orderId,uint256 interest ,uint256 _amount ) public payable returns(bool){
    uint256 tokenId = orders[orderId].tokenID;
    require(orders[orderId].lending,"LENDING MARKET : the given order Id has not opened for borrow");
    _borrowIdCounter++;
    uint256 time = block.timestamp +  7 days;
    uint256 amountToBePay = orders[orderId].Amount - _amount;
    NativeToken.transferFrom(msg.sender,orders[orderId].owner,_amount);
    borrowOrders[_borrowIdCounter]=borrows(_borrowIdCounter,tokenId,interest,block.timestamp,time,amountToBePay,payable(msg.sender),orders[orderId].owner,true);
    return true;
}

function completeOrder(uint256 borrowId)public {
require(borrowOrders[borrowId].active,"LENDING MARKET : the given borrower Id allready completed");
uint256 time = borrowOrders[borrowId].endtime -block.timestamp;
uint256 InterestTime = time - borrowOrders[borrowId].starttime;
uint256 interest = borrowOrders[borrowId].interst * (InterestTime / 1 days);
NativeToken.transferFrom(msg.sender, borrowOrders[borrowId].owner,(borrowOrders[borrowId].amount + interest));
_transfer(address(this),msg.sender,borrowOrders[borrowId].tokenId);
borrowOrders[borrowId].active = false;
}

}

