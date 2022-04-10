// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "https://github.com/NomicFoundation/hardhat/blob/master/packages/hardhat-core/console.sol";
import "DelegateAccount.sol";

contract Main {
    // ["mumuseum","ethereumum"]
    // ["tree", "must", "museum", "ethereum"]
    // ["must","museum", "ethereum"]
    // ["year", "electricity", "apple"]

    using SafeMath for uint256;

    // delegateAccount1 with Transfer limit of 100 tokens
    address private _delegateAccount1;

    // delegateAccount2 with Transfer limit of 1000 tokens
    address private _delegateAccount2;

    // asliceCountign delegate account addresliceCount at the time of deployment
    constructor(address delegateAccount1, address delegateAccount2) {
        _delegateAccount1 = delegateAccount1;
        _delegateAccount2 = delegateAccount2;
    }

    // Get Reward function is called by users to get rewards. takes the string[] as input
    function getReward(string[] memory data) public returns (string memory) {
        string memory trimmedString = trimStringMirroringChars(data);
        console.log(trimmedString);

        uint256 trimmedStringLength = bytes(trimmedString).length;

        if (trimmedStringLength >= 0 && trimmedStringLength <= 5) {
            DelegateAccount delegateAccount1 = DelegateAccount(
                _delegateAccount1
            );
            delegateAccount1.transferFrom(msg.sender);
            console.log("transferred");
            return "Transferred tokens from 1st account";
        } else {
            DelegateAccount delegateAccount2 = DelegateAccount(
                _delegateAccount2
            );
            delegateAccount2.transferFrom(msg.sender);
            console.log("transferred");
            return "Transferred tokens from 2nd account";
        }
    }

    // trims mirrored chars
    function trimStringMirroringChars(string[] memory data)
        private
        pure
        returns (string memory)
    {
        if (data.length == 1) {
            return data[0];
        }
        for (uint256 i = data.length - 1; i >= 1; i--) {
            bytes memory string1Bytes = bytes(data[i - 1]);
            bytes memory string2Bytes = bytes(data[i]);

            uint256 bytes1Length = string1Bytes.length;
            uint256 bytes2Length = string2Bytes.length;

            uint256 minOfBytes = bytes1Length.min(bytes2Length);
            uint256 k = 0;

            uint256 index = 1;
            uint256 sliceCount = 0;
            for (k = 0; k < minOfBytes; ) {
                if (string2Bytes[bytes2Length - index] == string1Bytes[k]) {
                    sliceCount++;
                } else {
                    break;
                }
                index++;
                k++;
            }

            data[i] = getSlice(1, bytes2Length - sliceCount, data[i]);
            data[i - 1] = getSlice(sliceCount + 1, bytes1Length, data[i - 1]);
        }
        return concatString(data);
    }

    function getSlice(
        uint256 begin,
        uint256 end,
        string memory text
    ) internal pure returns (string memory) {
        bytes memory responseBytes = new bytes(end.sub(begin) + 1);
        for (uint256 i = 0; i <= end.sub(begin); i++) {
            responseBytes[i] = bytes(text)[i + begin - 1];
        }
        return string(responseBytes);
    }

    function concatString(string[] memory trimmedStrings)
        internal
        pure
        returns (string memory)
    {
        string memory response = "";
        for (uint256 j = trimmedStrings.length; j >= 1; j--) {
            response = string(
                bytes.concat(bytes(response), "", bytes(trimmedStrings[j - 1]))
            );
        }
        return response;
    }
}

library SafeMath {
    // Subtracts
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        if (b >= a) return (b - a);
        return (a - b);
    }

    // Gets minimum of two
    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
