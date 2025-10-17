// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//1.创建一个收款函数
//2.记录投资人并且查看
//3.在锁定期内,达到目标值,生产商可以提款
//4.在锁定期内,没有达到目标值,投资人在锁定期以后退款

contract FundMe{
    //这个mapping可以直接通过键值对 通过键来查询它的值
    mapping(address funder=> uint256) public FundersAmount;
    function fund() external payable { 
        //创建收款函数,并给投资人进行记录
        FundersAmount[msg.sender]=msg.value;
        //msg.sender 就是投资人的地址
        //msg.value 就是投资人的金额
    }
}