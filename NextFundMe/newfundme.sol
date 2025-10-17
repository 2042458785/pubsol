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
    function ResetHelloWorld (string memory ResetString) public{
        Strbytes=ResetString;
    }

    function Addinfo(string memory OrigionString) internal pure returns(string memory AddinfoStr){
        return string.concat(OrigionString,"From Ddy's Contract");
    }

    function sayHelloAddinfo()public view returns(string memory SayHello){
        return Addinfo(Strbytes);
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

    //对于变量状态来说来说有6种类型
    //1.storage 
    //2.memory 
    //3.calldata
    //4.stack
    //5.codes
    //6.logs
    //memory和calldata是暂时性存储 他们的区别就是memory是在运行中可以被修改的,而calldata在运行中是不能被修改的
    //memory和calldata一般都是放在函数里面的 一般是放在入参和返回值哪里的参数类型
    //storage 就一般是放在合约里面的 一个永久性存储
    //在合约中常量的话,就是默认为storage的类型
    
    //永久性存储和暂时性存储的区别就是,永久性存储是永远存储在区块链上面的,而暂时性存储就是在调用这个合约或者说这个函数的时候,才会进行暂时性存储的一个变量,交易或者合约结束就不存在了
    //还有就是简单的数据类型不用去指定这些东西 因为编译器会自动去指定它的数据类型,复杂的数据类型就需要去指定了 指定它的具体存储状态


    //数组,映射,结构体
    // struct 结构体:把多种不同的数据类型合在一起去使用 uint,int,string,bytes32等
    // array 数组: 把单个基础数据类型存在一起
    // mapping 映射: 通过键值对的方式进行存储数据 通过键来找到对应的值

    struct Info{
        uint256 id;
        string phrase;
        address addr;
    }
    Info[] Infos;
    function SetInfoStruct(uint256 inid,string memory instring) public {
        Info memory oneinfo=Info(inid,instring,msg.sender);
        //我们想创造一个结构来存储Info这个结构体,我们创建一个永久存储的结构体切片,那我们直接在合约里面创建就OK了,合约里面的就是默认为永久存储数据storage
        Infos.push(oneinfo);
    }

}