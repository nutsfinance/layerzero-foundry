// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

interface IAppBase {
    event MessageReceived(uint16 targetChain, uint8 testId, uint256 timestamp);

    enum Status {
        NOT_SENT,
        SENT,
        RECEIVED
    }

    /// @dev add as needed
}
