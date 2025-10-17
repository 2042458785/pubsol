// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {HelloWorld} from "../newfundme.sol";

//要么是直接引用文件 import "../newfundme.sol" 这样就会引用到这个文件里面所有的合约
//要么是精确引用到文件里面的合约 import {HelloWorld} from "../newfundme.sol" 这样就会引用到这个文件里面的这个合约

//合约的引入方式
//1.直接引入同一个文件系统下面的合约 
//2.引入Github上的合约
//3.通过包引入

contract HelloWorldFactory{
    //在这里,我们把HelloWorld当做一个数据类型
    HelloWorld Varhw;

    HelloWorld[] Varhws;

    function createHelloWorld()public{
        Varhw=new HelloWorld();
        Varhws.push(Varhw);
    }

    function getHelloWorld(uint256 Index) public view returns(HelloWorld rtHelloWorld){
        return Varhws[Index];
    }

    function CallSayHelloWorldinFactory(uint256 index,uint256 inid) public view returns(string memory) {
        return Varhws[index].GetInfoMapping(inid);
    }

    function CallSetHelloWorldinFactory(uint256 index,uint256 inid,string memory instring) public {
        Varhws[index].SetInfoMapping(inid,instring);
    }
}