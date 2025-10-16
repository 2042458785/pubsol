// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

//1.声明开源软件协议
//2.声明solidity版本 0.8.30,前面加上^符号表示编译器版本大于等于0.8.30都可以进行编译,向上兼容

contract HelloWorld{
    bool boolVar_1=true; //bool里面只有true和false
    bool boolVar_2=false;
    uint256 testint =100; //这里面是无符号整数
    int256 Varint =-8; //这里面是整数,包含负数的
    bytes32 Varbytes="Hello World!"; //bytes32就是指定了数据的大小最大就是32个字节,然后用string的话就是自动分配多少个字节
    string Strbytes="Hello Worlds!"; //string自动分配了需要用到的bytes大小 如果超出都是可以使用的
    
    //对于上面的所有数据类型 如果知道确切的 当然是更好,这样节约资源,使用限定大小的数据类型就好
    address VarAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function sayHello () public view returns(string memory ReturnBytes){
        //对于返回的string类型数据加了一个memory 这是一种数据状态的标识
        //添加上view是一种非常好的代码书写习惯 
        return Strbytes;

    }
    //下面这个函数可以修改变量
    function ResetHelloWorld ( string memory ResetString) public{
        Strbytes=ResetString;123
    }


    //对于状态来说有四种:
    //1.public  可以被外部访问
    //2.private 只能在本合约内部访问
    //3.internal 只能在本合约内部和继承本合约的合约中访问
    //4.external 只能在合约外部和外部账户访问

    //对于函数来说有三种:--- 我们具体指定之后 这是非常清晰和方便的一种读取方式
    //1.view 只能读取数据,不能修改数据
    //2.pure 不能读取和修改数据
    //3.payable 可以接收eth


}
