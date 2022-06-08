pragma solidity >=0.7.0;

import "./token.sol";

// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;


contract Airdrop  {

    // Using Libs

    // Structs

    // Enum
    enum Status { ACTIVE, PAUSED, CANCELLED } // mesmo que uint8


    // Properties
    address private owner;
    address public tokenAddress;
    address[] private subscribers;
    Status contractState; 

    // Modifiers
    modifier isOwner() {
        require(msg.sender == owner , "Sender is not owner!");
        _;
    }

    // Events
    event NewSubscriber(address beneficiary, uint amount);

    // Constructor
    constructor(address token) {
        owner = msg.sender;
        tokenAddress = token; //0xf8e81D47203A594245E36C48e151709F0C19fBe8;
        contractState = Status.PAUSED;
    }


    // Public Functions

    function subscribe() public returns(bool) {
        require(hasSubscribed(msg.sender) == true);
        subscribers.push(address(msg.sender));
        return true;
        //TODO: Need Implementation

    }

    function execute() public isOwner returns(bool) {
        uint256 balance = CryptoToken(tokenAddress).balanceOf(address(this));
        uint256 amountToTransfer = balance / subscribers.length;
        for (uint i = 0; i < subscribers.length; i++) {
            require(subscribers[i] != address(0));
            require(CryptoToken(tokenAddress).transfer(subscribers[i], amountToTransfer));
            emit NewSubscriber(subscribers[i], amountToTransfer);
        }
        return true;
    }

    function state() public view returns(Status) {
        return contractState;
    }
    
    


    // Private Functions
    function hasSubscribed(address subscriber) private view returns(bool) {
        for (uint256 i = 0; i < subscribers.length; i++){
            require(subscribers[i] != subscriber, "You are already subscribed!!!");
        }
        return true;
        
    }

    function setStatus(uint256 num) public isOwner{
        if(num == 1){
             contractState = Status.PAUSED;
        }
        if (num == 0) {
             contractState = Status.ACTIVE;
        }
        if(num==2){
             contractState = Status.CANCELLED;
        }
    }

    // Kill
    function kill() public isOwner {
        require(contractState == Status.CANCELLED,"O contrato esta ativo");
        selfdestruct(payable(owner));
    }
    
    
}
