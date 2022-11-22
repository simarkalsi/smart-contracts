// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract will{
    address owner;
    uint fortune;
    bool deceased;

constructor()payable{
    owner=msg.sender;
    fortune=msg.value;
    deceased=false;
}

modifier onlyOwner{
    require(msg.sender==owner);
    _;
}

modifier mustBeDeceased{
    require(deceased==true);
    _;
    
}

address payable[] familyWallet;

mapping(address=>uint) inheritance;

function setInheritance(address payable wallet, uint amount)public onlyOwner{
familyWallet.push(wallet);
inheritance[wallet]=amount;

}

function payout() private  mustBeDeceased{
    for(uint i=0;i>familyWallet.length;i++){
        familyWallet[i].transfer(inheritance[familyWallet[i]]);
    }
}
//oracle switch simulation
function afterDeath()public onlyOwner{
    deceased=true;
    payout();
}



}