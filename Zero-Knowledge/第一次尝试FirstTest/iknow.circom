pragma circom 2.0.0;

template Multiplier() {
    signal input a; //私有输入
    signal input b; //公开输入
    signal output c; //公开输出

    c <== a * b;
}

component main {public [b]} = Multiplier();