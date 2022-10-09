// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 < 0.9.0;

contract CrowdFunding{

    
    mapping(address=>uint) public contributor;
    address public manager;
    uint  public minimumContribution;
    uint public  deadline;
    uint public target;
    uint public raisedAmount;
    uint public noOfContributor;

    struct Request{
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;

    }
    mapping(uint=>Request) public requests;
    uint public numRequests;

    constructor(uint _target,uint _deadline){
        target=_target;
        deadline=block.timestamp+_deadline;
        minimumContribution=100 wei;
        manager=msg.sender;
    }

    function sendEth() public payable{
        require(block.timestamp< deadline,"deadline has passed");
        require(msg.value>=minimumContribution,"Amount should be greater then 99 Wei");
        if(contributor[msg.sender]==0){
            noOfContributor++;

        }
        contributor[msg.sender]+=msg.value;
        raisedAmount+=msg.value;
        }

     function getContractBalance() public view returns(uint){
         return address(this).balance;
     }   

     function refund() public{
         require(block.timestamp>deadline && raisedAmount<target,"you are not eligible for refund");
         require(contributor[msg.sender]>0,"you didn't contribite");
         address payable user =payable(msg.sender);
         user.transfer(contributor[msg.sender]);
         contributor[msg.sender]=0;


     }

     modifier onlyManager(){
         require(msg.sender==manager,"only manager can call requests");
         _;

     }

     function createRequest(string memory _description,address payable _recipient,uint _value) public onlyManager{
         Request storage newRequest=requests[numRequests];
         numRequests++;
         newRequest.description=_description;
         newRequest.recipient=_recipient;
         newRequest.value=_value;
         newRequest.completed=false;
         newRequest.noOfVoters=0;
     }

     function voteRequest(uint _requestNo)public{
         require(contributor[msg.sender]>0,"you are not a comtributor");
         Request storage thisRequest=requests[_requestNo];
         require(thisRequest.voters[msg.sender]==false,"you have already voted");
         thisRequest.voters[msg.sender]=true;
         thisRequest.noOfVoters++;

     }
     function makePayment(uint _requestNo) public onlyManager{
         require(raisedAmount>=target,"sorry!");
         Request storage thisRequest=requests[_requestNo];
         require(thisRequest.completed=false,"request already completed");
         require(thisRequest.noOfVoters>noOfContributor/2,"Less Votes");
         thisRequest.recipient.transfer(thisRequest.value);
         thisRequest.completed=true;

     }
}