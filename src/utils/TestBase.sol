// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {LZEndpointMock} from "@layerzero/mocks/LZEndpointMock.sol";
import {LzApp} from "@layerzero/LzApp.sol";
import {DataTypes} from "@types/DataTypes.sol";
import {ITestBase} from "@interfaces/ITestBase.sol";

contract TestBase is ITestBase, LzApp {
    uint16 public chainId;
    uint64 public globalNonce;
    LZEndpointMock LayerZeroEndpoint;

    mapping(uint8 => mapping(uint16 => uint256)) public delays;
    mapping(uint8 => mapping(uint16 => Status)) public received;

    function _blockingLzReceive(
        uint16, // sourceChain,
        bytes memory, // sourceAddress,
        uint64, // nonce,
        bytes memory // payload
    )
        internal
        override
    {}

    function lzSend(
        uint16 targetChain,
        address targetAddress,
        bytes memory pathTargetSource,
        bytes memory payload
    )
        internal
    {
        LayerZeroEndpoint.send(
            targetChain,
            pathTargetSource,
            payload,
            payable(address(this)),
            address(0),
            bytes("")
        );
    }
}
