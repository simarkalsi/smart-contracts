// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract pay{
    uint[] public name=[1,2,3];
    function arr() public view returns(uint[] memory){
        return name;
    }

    address payable user=payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    function payEther() public payable{

    }
    function balance() public view returns(uint){
        return address(this).balance;
    }
    function sendEth() public{
        user.transfer(1 ether);
    }
}
