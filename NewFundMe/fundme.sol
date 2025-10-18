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
    //我们想用USD美元来作为单位 
    uint256  MINIMUM_VALUE=100*10**18; //这个单位是wei;

    //先定义了从chainlink拿到的参数
    AggregatorV3Interface internal dataFeed;
    
    //我们定义一个目标值常量---1000USD
    uint256 constant public target =1000 * 10 ** 18;

    address public owner;

    //这是我们设置的锁定期
    uint256 developmenttimestamp;
    uint256 locktime;

    //接下来初始化这个参数
    //constructor的作用就是在合约部署的时候初始化合约的状态变量或执行一次性设置,只在合约创建时运行一次,之后无法再次调用

    constructor (uint256 inlocktime){
        dataFeed=AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        //设置合约权限者为当前部署合约的人
        owner=msg.sender;
        //设置合约部署时的时间戳
        developmenttimestamp=block.timestamp;
        //设置合约锁定期
        locktime=inlocktime;
    }

    function fund() external payable InWindowTime { 
        //创建收款函数,并给投资人进行记录  

        //我们设置一个最小的收款额度,低于这个额度我们就会对这个交易进行退回
        //另外 我们想要得到这个真实的相对于USD的价格 这需要依赖chainlink网络来进行获取和计算
        //最后得到的结果是ETH数量value乘以单价 ETH/USD 得到总价 也就是USD*10**18 美元乘以10的18次方
        require(convertEthToUsd(msg.value)>=MINIMUM_VALUE,"Please Send More ETH!!!");
        
        //我们要验证一下锁定期
        

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

    function convertEthToUsd(uint256 ethAmount)internal view returns(uint256){
        uint256 price=uint256(getChainlinkDataFeedLatestAnswer());
        return ethAmount* price/(10 ** 8);
    }

    //转移合约权限者的函数
    function TransferOwnership(address newowner) public onlyOwner{
        //转移合约权限
        owner=newowner;
    }

    function getFund() external WindowNotClosed onlyOwner{
        //检查合约地址上的余额是否已经满足提现要求
        require(convertEthToUsd(address(this).balance)>=MINIMUM_VALUE,"Fund is too low!");
        //检查用户有权限提出现在的余额
        require(msg.sender==owner,"this function can only bu called by owner");
        
        //我们进行锁定时间的判断
        

        //现在我们要进行合约地址余额的转出

        //transfer : transfer ETH and revert if tx fail
        //默认 我们的msg不是payable我们先把它变成payable
        //我们把这个账户上的余额全部转走
        payable(msg.sender).transfer(address(this).balance);

        //send: transfer ETH and return false if failed 
        bool status = payable(msg.sender).send(address(this).balance);
        //如果转账失败会返回false
        require(status,"tx failed");

        //call: transfer ETH with data return value of function and bool
        //(bool,result)=addr.call{value:value}("");
        //返回的是bool 是否调用成功 和一个结果result 然后value代表需要发送的ETH,后面的用来上传数据,比如调用的数据(或者函数名等)
        //如果我们没有调用函数,那么result这个返回的值我们可以不关心
        bool success;
        (success ,)=payable(msg.sender).call{value: address(this).balance}(""); 
        require(success,"tx failed");

        //我们也在这里把投资人的余额设置为0,不管它是不是owner
        FundersAmount[msg.sender]=0;

    }

    function refund() external WindowNotClosed{
        //先检查是否到达目标价
        require(convertEthToUsd(address(this).balance)<target,"target is reached!");
        //检查用户是否有fund
        require(FundersAmount[msg.sender]!=0,"you don't have fund,there is no fund for you!");
       
        //进行锁定时间的判断
        
       
        //接下来使用call方式进行转账
        //退还该用户fund的金额
        bool successstatus;
        (successstatus,)=payable(msg.sender).call{value: FundersAmount[msg.sender]}("");
        require(successstatus,"tx fail!");

        //在每次调用完转账之后我们都要将这个用户的账户余额在mapping中清零
        FundersAmount[msg.sender]=0;
    }


    //我们添加几个modifier来减少重复出现的语句
    modifier onlyOwner(){ //限制只有合约权限用户能对这个函数进行操作
        require(msg.sender==owner,"this function can only be called by owner");
        _;
    }

    modifier WindowNotClosed(){ //限制函数只有在锁定期结束才能够被调用
        require(block.timestamp>=developmenttimestamp+locktime,"Time Window is not closed!");    
        _;
    }

    modifier  InWindowTime(){ //限制函数只能在锁定期也就是窗口期才能够被调用
        require(block.timestamp<developmenttimestamp+locktime,"Time Window is closed!");
        _;
    }

}