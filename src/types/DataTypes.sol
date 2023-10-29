// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library DataTypes {
    struct MessagePayload {
        uint16 srcChainId;
        bytes path;
        address dstAddress;
        uint64 nonce;
        uint256 gasLimit;
        bytes payload;
    }
}
