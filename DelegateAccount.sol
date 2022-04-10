// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "Token.sol";

contract DelegateAccount {
    address private _tokenAddress;
    uint256 private _transferLimit;

    constructor(address tokenAddress, uint256 transferLimit) {
        _tokenAddress = tokenAddress;
        _transferLimit = transferLimit;
    }

    function transferFrom(address receipient) public {
        Token token = Token(_tokenAddress);
        token.approve(address(this), _transferLimit);
        token.transferFrom(_tokenAddress, receipient, _transferLimit);
    }

    function getTransferLimit() public view returns (uint256) {
        return _transferLimit;
    }
}
