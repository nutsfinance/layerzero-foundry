// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface ITestBase {
    event MessageReceived(uint16 targetChain, uint8 testId, uint256 timestamp);

    enum Status {
        NOT_SENT,
        SENT,
        RECEIVED
    }

    function lzSend(
        uint16 targetChain,
        address targetAddress,
        bytes memory pathTargetSource,
        bytes memory payload
    )
        external;

    function lzReceive(
        uint16 sourceChain,
        bytes calldata, // sourceAddress,
        uint64, // nonce,
        bytes calldata payload
    )
        external;
}
