// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {TestBase} from "./utils/TestBase.sol";
import {LzApp} from "@layerzero/LzApp.sol";

contract AppContract is TestBase {
    constructor(uint16 currentChain, address endpoint) LzApp(endpoint) {
        chainId = currentChain;
    }

    function send(
        uint16 targetChain,
        address targetAddress,
        uint8 testId,
        uint256 timestamp
    )
        external
        payable
    {
        // Pack your data as needed
        bytes memory payload = abi.encode(targetChain, testId, timestamp);

        // Send
        lzSend(
            targetChain,
            targetAddress,
            abi.encodePacked(targetAddress, address(this)), // 40 bytes path
            payload
        );
    }

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
