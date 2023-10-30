// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ILayerZeroEndpoint} from "@layerzero/interfaces/ILayerZeroEndpoint.sol";
import {LzApp} from "@lz/LzApp.sol";
import {DataTypes} from "@types/DataTypes.sol";
import {IAppBase} from "@interfaces/IAppBase.sol";
import {console} from "lib/forge-std/src/console.sol";

abstract contract AppBase is IAppBase, LzApp {
    uint16 public chainId;
    ILayerZeroEndpoint LayerZeroEndpoint;

    mapping(uint8 => mapping(uint16 => uint256)) public delays;
    mapping(uint8 => mapping(uint16 => Status)) public received;

    function lzSend(
        uint16 targetChain,
        bytes memory pathTargetSource,
        bytes memory payload
    )
        public
        payable
    {
        LayerZeroEndpoint.send{value: msg.value}(
            targetChain,
            pathTargetSource,
            payload,
            payable(address(1)),
            address(0),
            bytes("")
        );
    }

    function _blockingLzReceive(
        uint16, // sourceChain,
        bytes memory, // sourceAddress,
        uint64, // nonce,
        bytes memory // payload
    )
        internal
        override
    {}
}
