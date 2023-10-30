// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AppBase} from "./utils/AppBase.sol";
import {ILayerZeroEndpoint} from "@layerzero/interfaces/ILayerZeroEndpoint.sol";
import {LzApp} from "@lz/LzApp.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract AppContract is Ownable, AppBase {
    constructor(uint16 currentChain, address endpoint) Ownable() LzApp(endpoint) {
        chainId = currentChain;
        LayerZeroEndpoint = ILayerZeroEndpoint(endpoint);
    }

    function send(
        uint16 targetChain,
        bytes memory pathTargetSource,
        bytes memory payload
    )
        external
        payable
    {
        /// @dev Send as you normally would
        LayerZeroEndpoint.send{value: msg.value}(
            targetChain,
            pathTargetSource,
            payload,
            payable(address(1)),
            address(0),
            bytes("")
        );
    }

    /// @notice LayerZero handle override
    function lzReceive(
        uint16 sourceChain,
        bytes calldata, // sourceAddress,
        uint64, // nonce,
        bytes calldata payload
    )
        public
        override
    {
        (uint16 targetChain, uint8 testId, uint256 timestamp) =
            abi.decode(payload, (uint16, uint8, uint256));
        uint256 delay = block.timestamp - timestamp;

        delays[testId][sourceChain] = delay;
        received[testId][sourceChain] = Status.RECEIVED;

        emit MessageReceived(targetChain, testId, timestamp);
    }
}
