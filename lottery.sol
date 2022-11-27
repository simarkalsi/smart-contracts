// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract lottery {
    address manager;
    address payable[] public members;

    constructor() {
        manager = msg.sender;
    }

    function enterLottery() public payable {
        require(msg.sender != manager, "Manager is not allow to participate");
        require(msg.value >= 1 ether, "Minimum amount for entry is 1 ether");

        members.push(payable(msg.sender));
    }

    function randomNumber() private view returns (uint) {
        return
            uint(
                sha256(
                    abi.encodePacked(block.difficulty, block.number, members)
                )
            );
    }

    function result() public {
        require(
            msg.sender == msg.sender,
            "only manager have permission to announce results"
        );
        uint index = randomNumber() % members.length;
        address contractAddress = address(this);
        members[index].transfer(contractAddress.balance);
        members = new address payable[](0);
    }
}
