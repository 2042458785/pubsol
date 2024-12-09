// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

// 1. 创建一个收款函数
// 2. 记录投资人并且查看
// 3. 在锁定期内，达到目标值，生产商可以提款
// 4. 在锁定期内，没有达到目标值，投资人在锁定期以后退款

contract Fundtome{
    //导入外部包中的类型
    AggregatorV3Interface internal dataFeed;

    //在sepolia测试网上找到ETH/USD
    constructor() {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
    }
    mapping (address addr => uint256 much) public  funderstoAmount;
    //将最小值设置为100美元
    uint256 MINIUM_VALUE=100; //USD
    //我们也可以用ETH但是ETH的单位是(wei)
    //也就是 1ETH=10 ** 18wei
    //所以我们的最小值就应该设置为 uint256 MINIUM_VALUE=1 * 10 ** 18

    function fund() external payable {
        //我们要确保转入的钱大于1个ETH,而在msg里面的计量单位是wei
        require(convertETHtoUSDT(msg.value) >= MINIUM_VALUE,"please send more money");
        funderstoAmount[msg.sender]=msg.value;
    }


    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        // prettier-ignore
        (
            /* uint80 roundID */,
            int answer,
            /*uint startedAt*/,
            /*uint timeStamp*/,
            /*uint80 answeredInRound*/
        ) = dataFeed.latestRoundData();
        return answer;
    }
    function convertETHtoUSDT(uint256 getethnumber) internal view returns(uint256){
        uint256 oneprice=uint256(getChainlinkDataFeedLatestAnswer());
        return getethnumber * oneprice / (10 ** 26); 
        //USD的精度是10 ** 8 ,ETH的精度是10 ** 18,所以就是 10 ** 26
    }
}