// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//指定了智能合约的版本
//comment: this is my first  smart contract

contract Helloworld{
    string readvalue="Hello world";
    function sayhello() public view returns (string memory ){
        return Addinfo(readvalue);
    }
    string RTTT1="reset ok!";
    // test:
    // string RT2="reset ok2!";
    function Resethello(string memory Mynewresetstring) public returns (string memory RT){
        readvalue=Mynewresetstring;
        return  RTTT1;
    }
    string ret="";
    string resets="";
    function Addinfo(string memory Hellost) internal pure returns(string memory outstr){
        return string.concat(Hellost,"\tthis is add string!");
    }
}
