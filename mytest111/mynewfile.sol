// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

//指定了智能合约的版本
//comment: this is my first  smart contract

contract Helloworld{
    string readvalue="Hello world";
    function sayhello() public view returns (string memory ){
        return Addinfo(readvalue);
    }
    struct Infostruct{
        string phrase;
        uint256 id;
        address addr;
    }

    Infostruct[] infostructs;

    mapping (uint256 storeid => Infostruct storestruct) Infomapping;

    string RTTT1="reset ok!";
    // test:
    // string RT2="reset ok2!";
    function Resethello(string memory Mynewresetstring) public returns (string memory RT){
        readvalue=Mynewresetstring;
        return  RTTT1;
    }
    string ret="";
    function Addinfo(string memory Hellost) internal pure returns(string memory outstr){
        return string.concat(Hellost,"\tthis is add string!");
    }

    function Sethelloworld(string memory Newstring,uint256 newid) public {
        Infostruct memory infostruct=Infostruct(Newstring,newid,msg.sender);
        infostructs.push(infostruct);
    }

    function Selecthelloworld(uint256 inputid) public  view returns (string memory) {
        for (uint256 i=0;i < infostructs.length;i++){
            if (infostructs[i].id==inputid){
                return Addinfo(infostructs[i].phrase);
            }
        }
        return Addinfo(readvalue);
    }


    function Insertwithmap(string memory inputnewstring, uint256 inputnewid)public {
        Infostruct  memory infostruct=Infostruct(inputnewstring,inputnewid,msg.sender);
        Infomapping[inputnewid]=infostruct;
    }

    function Selectwithmap(uint256 selectid) public view returns(string memory){
        if (Infomapping[selectid].addr==address(0x0)){
            //说明在map中没有这个地址,那么就说吗没有这个数据
            //返回没有这个数据
            return Addinfo(readvalue);
        }else {
            return Addinfo(Infomapping[selectid].phrase);
        }
    }
}
