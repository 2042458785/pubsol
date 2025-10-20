//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// FundMe
//1.让FundMe的参与者,基于mapping来领取相应数量的通证
//2.让FundMe的参与者,transfer通证
//3.在使用完成后,burn通证

import {ERC20} from   "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {FundMe} from "./fundme.sol";


contract FundMeERC20 is ERC20 {
    FundMe fundme;
    constructor(address fundMeddr) ERC20("FundMeToken","FDFT"){
        fundme=FundMe(fundMeddr);
    }
}