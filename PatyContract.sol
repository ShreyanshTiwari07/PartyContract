// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


contract PartyContract{

address public owner;
   
 constructor(){
owner=msg.sender;
 }
  modifier OnlyOwner(){
require(msg.sender==owner);
_;
    }
uint256 public remainingAmount;
bool public PaymentStatus;
 
uint256 public MembersCount;

 mapping(address=>bool) public CheckMember;
 mapping(uint256=>address) public Members;
 

 function JoinParty()public payable{
     require(msg.value>=1*(10**18), "Insufficient amount");
     require(!CheckMember[msg.sender], "Already a member");
     MembersCount=MembersCount+1;
    Members[MembersCount]=msg.sender;

     CheckMember[msg.sender]=true;
     
    
}

function BillPayment(address payable _address, uint256 _bill) public OnlyOwner{
    require(!PaymentStatus, "Payment already done");
    payable(_address).transfer(_bill);
    PaymentStatus=true;
    remainingAmount=address(this).balance-_bill;
}

function GetBalance() public view returns(uint256){
    return address(this).balance;
}

function refund()public OnlyOwner{
    uint256 eachRefund=remainingAmount/MembersCount;
    for(uint256 i=0; i<MembersCount;i++){
  payable(Members[i]).transfer(eachRefund);
    }
}
}