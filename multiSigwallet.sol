// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

//MAIN ACCESS CONTRACT (Incompelete)
contract AccessRegistry{

    address public topOwner;
    MultiSig child;

    struct  SignatorData{
        uint totalSigned;
        uint agreed;
        uint disAgreed;
        mapping(address=>bool) Requests;

    }
    mapping(address=>SignatorData)  data;

 
    

    constructor(address mainAdmin){
        topOwner=mainAdmin;
    }
    
    modifier onlyTopOnwer(){
        require(msg.sender==topOwner,"only topOwner is allowed to call this function");
        _;
    }


    function adding(address newOwner) public onlyTopOnwer{
        child=MultiSig(newOwner);
        child.addingOwner(newOwner);
    }

     function transfer(uint reqNum)public onlyTopOnwer{
        child.directTransfer(reqNum);
    }

    //trying but pop in mapping is not working in revoking & renouncing
    function revoking(uint reqNum)public onlyTopOnwer{
        
    }

    function renouncing()public onlyTopOnwer{

    }

   
}


//CHILD CONTRACT (MultiSig) (Completed)
contract MultiSig{
    address[] public owners;
    mapping(address=>bool) isOwner;


    struct Request{
        address payable to;
        uint amount;
        bool completed;
        uint noOfVoters;
        mapping(address=>bool) voters;
    }

    mapping(uint=>Request) public requests; 

    uint public numRequests;


    modifier onlyOwner() {
        require(isOwner[msg.sender],"you are not owner");
        _;
    }

    function request(address payable _to, uint _amount) public onlyOwner{
        Request storage newRequest=requests[numRequests];
        numRequests++;
        newRequest.to=_to;
        newRequest.amount=_amount;
        newRequest.completed=false;
        newRequest.noOfVoters=0;


    }

    function voting(uint _requestNo, bool decision) public onlyOwner{

         Request storage thisRequest=requests[_requestNo];
         require(thisRequest.voters[msg.sender]==false,"you have already voted");
         thisRequest.voters[msg.sender]=decision;
         thisRequest.noOfVoters++;

    }

    function transaction(uint _requestNo) public onlyOwner{
        Request storage thisRequest=requests[_requestNo];
        require(thisRequest.noOfVoters>(owners.length*60)/100,"Voting Should be more than 60% of owners");
        thisRequest.to.transfer(thisRequest.amount);
         thisRequest.completed=true;

    }



    //Functions call by Parent contract(AccessRegistry)
    AccessRegistry Parent;
    function addingOwner(address newOwner) external  {

        require(newOwner!=address(0),"Invalid Owner");
        require(!isOwner[newOwner],"owner is not unique");

            owners.push(newOwner);
            isOwner[newOwner]=true;
    }

    function directTransfer(uint _requestNo) external{
         Request storage thisRequest=requests[_requestNo];
         thisRequest.to.transfer(thisRequest.amount);
         thisRequest.completed=true;
    }
    

}