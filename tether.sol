// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Tether{
    string public name='Tether';
    string public symbol='USDT';
    uint256 public totalSupply=1000000000000000000000000; //1 million supply
    uint256 public decimals=18; 
    

    event transaction(address from , address to, uint256 amount);
    event allowance(address from , address to, uint256 amount);


    mapping(address=>uint256) public balanceOf;
    mapping(address=> mapping(address=>uint256)) public allowanceBalance;

    constructor() {
        balanceOf[msg.sender]=totalSupply;
    }

    function transfer(address receiverAddress , uint256 amount) public returns(bool success){
        require(balanceOf[msg.sender]>=amount);
        balanceOf[msg.sender] -=balanceOf[receiverAddress];
        balanceOf[receiverAddress]+=balanceOf[msg.sender];
        emit transaction(msg.sender,receiverAddress,amount);
        return true;

    }

    function allocation(address receiverAddress, uint amount) public {
        require(balanceOf[msg.sender]>=amount);

        allowanceBalance[msg.sender][receiverAddress] +=amount;

        emit allowance(msg.sender,receiverAddress, amount);
       

    }

    function transferFrom(address from ,uint256 amount) public returns(bool success){
        require(balanceOf[from]>=amount);
        require(allowanceBalance[from][msg.sender]>=amount);

        balanceOf[msg.sender] +=amount;
        balanceOf[from]-= amount;
        allowanceBalance[from][msg.sender] -=amount;
        
        emit allowance (from, msg.sender ,amount);

        return true;

    }


    




}