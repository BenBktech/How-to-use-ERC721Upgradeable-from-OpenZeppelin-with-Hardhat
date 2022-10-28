// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./BenBKNFT.sol";

contract BenBKNFTV2 is BenBKNFT {

    function version() external pure returns(string memory) {
        return "V2!";
    }

}