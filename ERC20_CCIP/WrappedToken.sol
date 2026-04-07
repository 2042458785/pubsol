// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import { Drunk } from "ERC20_CCIP/NFT.sol";

contract WrappedNFT is Drunk{
    constructor(string memory TokenName,string memory TokenSymbol)
    Drunk(TokenName,TokenSymbol)
    {}

    function mintTokenwithTokenID(address to,uint256 token_id) public {
        _safeMint(to,token_id);
    }
}