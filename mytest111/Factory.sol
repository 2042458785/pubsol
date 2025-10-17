// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Helloworld} from "./mynewfile.sol";

//通过工厂模式来对其他合约进行操作

contract Hellowordfactry{
    Helloworld  myhw;
    Helloworld[] myhws;
    function CreateHelloworld()public {
        myhw=new Helloworld();
        myhws.push(myhw);
    }
    function Getmycontract(uint256 inputindex) public view returns (Helloworld){
        return myhws[inputindex];
    }
    function Callhelloworldfromfactory (uint256 inindex,uint256 selectid) public view returns(string memory){
        return myhws[inindex].Selectwithmap(selectid);
    }
    function Sethelloworldfromfactory(uint256 inindex,string memory inputnewstring, uint256 inputnewid)public {
        myhws[inindex].Insertwithmap(inputnewstring,inputnewid);
    }
}