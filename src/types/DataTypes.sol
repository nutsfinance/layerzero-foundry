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

    struct sendData {
        uint16 targetChainId;
        bytes sourceAddress;
        address targetAddress;
        uint64 nonce;
        uint256 extraGas;
        bytes payload;
    }
}
