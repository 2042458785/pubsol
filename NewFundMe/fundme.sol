// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

//1.创建一个收款函数
//2.记录投资人并且查看
//3.在锁定期内,达到目标值,生产商可以提款
//4.在锁定期内,没有达到目标值,投资人在锁定期以后退款

contract FundMe{
    //这个mapping可以直接通过键值对 通过键来查询它的值
    mapping(address funder=> uint256) public FundersAmount;

    //我们接下来设置一个投资人的最小投资金额
    uint256 public  MINIMUM_VALUE=1*10**18; //这个单位是wei;

    //先定义了从chainlink拿到的参数
    AggregatorV3Interface internal dataFeed;

    //接下来初始化这个参数
    //constructor的作用就是在合约部署的时候初始化合约的状态变量或执行一次性设置,只在合约创建时运行一次,之后无法再次调用

    constructor (){
        dataFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }

    function fund() external payable { 
        //创建收款函数,并给投资人进行记录  

        //我们设置一个最小的收款额度,低于这个额度我们就会对这个交易进行退回
        //另外 我们想要得到这个真实的相对于USD的价格 这需要依赖chainlink网络来进行获取和计算
        require(msg.value>=MINIMUM_VALUE,"Please Send More ETH!!!");
        FundersAmount[msg.sender]=msg.value;
        //msg.sender 就是投资人的地址
        //msg.value 就是投资人的金额
    }

    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundId */,
            int256 answer,
            /*uint256 startedAt*/,
            /*uint256 updatedAt*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }

}