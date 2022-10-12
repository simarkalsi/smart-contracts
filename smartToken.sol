// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract simarTocken{

    address minter;

    event transaction(address sender,address receiver, uint amount );

    constructor() {
    minter=msg.sender;
    }

    mapping(address=>uint) public balances;

  function minting(address receiver, uint amount)public{
      require(msg.sender==minter);
      balances[receiver] += amount;
  }

   function sending(address receiver, uint amount) public {
       require(balances[msg.sender]>=amount,"Insufficient Balance!");
       balances[msg.sender] -= amount;
       balances[receiver] += amount;
       emit transaction(msg.sender,receiver,amount);

   }
   function balance()public view returns(uint){
       return balances[msg.sender];
   }
}