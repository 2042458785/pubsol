//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FundMe
//1.让FundMe的参与者,基于mapping来领取相应数量的通证
//2.让FundMe的参与者,transfer通证
//3.在使用完成后,burn通证

import {ERC20} from   "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./fundme.sol";
 

contract FundMeERC20 is ERC20 {
    FundMe fundmecontract;
    constructor(address fundMeddr) ERC20("FundMeToken","FDFT"){
        fundmecontract=FundMe(fundMeddr);
    }

    function mint(uint256 MintAmount) public {
        //我们先检查用户是否有这么多的数量,有对应的数量我们才可以进行mint
        require(fundmecontract.FundersAmount(msg.sender)>=0,"you do not have enough amount!");
        //接下来我们进行mint
        _mint(msg.sender,MintAmount);
        fundmecontract.SetFundertoamount(msg.sender,fundmecontract.FundersAmount(msg.sender)-MintAmount);

    }
}