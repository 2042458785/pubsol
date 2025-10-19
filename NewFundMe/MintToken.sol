// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FundToken{
    //1.通证的名字 
    //2.通证的简称
    //3.通证的发行数量
    //4.owner地址 合约权限控制者地址
    //5.balance address =>uint256 合约余额地址

    string public TokenName  ;
    string public TokenSymbol  ;
    uint256  public TotalSupply ;
    address public owner;
    mapping (address user => uint256 balance) public balance;

    constructor(string memory inTokenName,string memory inTokenSymbol){
        TokenName=inTokenName;
        TokenSymbol=inTokenSymbol;
        owner=msg.sender;
    }


    //mint:获取通证
    function Mint(uint256 Amount) public {
        balance[msg.sender]+=Amount;
        TotalSupply+=Amount;
    }
    //transfer: transfer 通证
    function TransferToken(address Toaddress,uint256 Amount)public{
        require(balance[msg.sender]>=Amount,"You don't have enough balance to transfer!");
        balance[msg.sender]-=Amount;
        balance[Toaddress]+=Amount;
    }
    //balanceOf: 查看某一个地址的通证数量
    function balanceOf(address OneAddr) public view returns(uint256){
        return balance[OneAddr];
    }
}