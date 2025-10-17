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

    address public owner;
    //在sepolia测试网上找到ETH/USD

    //先定义一个部署时间的时间戳
    uint256 developtimestamp;
    //再去定义一个需要填写的锁定时间
    uint256 locktime;
    constructor(uint256 needblocktime) {
        dataFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        //将部署这个合约的人设置为owner
        owner=msg.sender;
        //我们为时间戳赋予当前的时间
        developtimestamp=block.timestamp;
        locktime=needblocktime;
    }

    mapping (address addr => uint256 much) public  funderstoAmount;
    //将最小值设置为100美元
    uint256 MINIUM_VALUE=10; //USD
    //我们也可以用ETH但是ETH的单位是(wei)
    //也就是 1ETH=10 ** 18wei
    //所以我们的最小值就应该设置为 uint256 MINIUM_VALUE=1 * 10 ** 18

    //将目标收款额设置为1000USD
    uint256 FLAG=20; //USD

    function fund() external payable windownotclosed {
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

    //这个函数用于修改owner
    function Resetowner(address Newowner) public onlyOwner{
        owner=Newowner;
    }

    //这个函数用于在达到目标值之后,生产商可以提款
    //第一要满足达到目标值
    //第二要达到身份是生产商
    function Getmoneyifover() external windowClosed{
        //先满足收款额达到目标值
        require(convertETHtoUSDT(address(this).balance) >= FLAG,"balance is not reach to FLAG!");
        //再满足发起提款的身份
        require(msg.sender == owner,"you are not owner");
        // //再满足已经超过锁定时间
        // require(block.timestamp > developtimestamp + locktime,"time is not reached!");
        //验证上述身份之后我们就开始转账
        //将账户里面所有的钱转给这个人也就是owner
        //转账有三种方式
        //transfer 
        // payable(msg.sender).transfer(address(this).balance);
        //send
        //需要用一个bool类型的变量来接收返回值
        // bool success = payable(msg.sender).send(address(this).balance);
        //call(最广泛的,建议使用这种方式发送转账)
        bool mystatus;
        (mystatus, ) = payable(msg.sender).call{value: address(this).balance}("");
        //判断owner的退款是否发送成功
        require(mystatus,"owner's refund is Fail!");
        //其他用户也不能提款,但是也要把owner的资产清零
        funderstoAmount[msg.sender] = 0;
    }
    //在规定时间内,没有达到目标值的情况下,每个用户就可以退款了
    function Refund()external windowClosed{
        //判断如果总金额小于目标金额
        require(convertETHtoUSDT(address(this).balance) < FLAG,"reach the FLAG!");
        //判断这个要提款的用户的金额是否为空
        //如果为空不能提款,非空才能提款
        require(funderstoAmount[msg.sender] != 0,"there is no your money!");
        // //再满足已经超过锁定时间
        // require(block.timestamp > developtimestamp + locktime,"time is not reached!");
        //如果这两个条件都通过了那么就可以用call退回这个用户的钱了
        bool refundstatus;
        (refundstatus, )=payable(msg.sender).call{value: funderstoAmount[msg.sender]}("");
        //判断退款是否发送成功
        require(refundstatus,"refund Fail!");
        //如果发送成功的话就把该用户资产清零
        funderstoAmount[msg.sender]=0;
    }
    //这是超过锁定时间的判断
    modifier windowClosed{
        //再满足已经超过锁定时间
        require(block.timestamp > developtimestamp + locktime,"time is not reached!");
        _;
    }
    //只有owner才能修改owner
    modifier onlyOwner{
        require(msg.sender == owner,"you are not owner");
        _;
    }
    //确认没有超过锁定时间
    modifier windownotclosed{
        require(block.timestamp < developtimestamp + locktime,"time is out,you can't fund in!");
        _;
    }
    
}