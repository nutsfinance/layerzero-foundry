// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AppContract} from "../../src/App.sol";
import {DSTestFull, LZEndpointMock} from "./DSTestFull.sol";
import {DataTypes} from "@types/DataTypes.sol";
import {console} from "lib/forge-std/src/console.sol";

contract TestBase is DSTestFull {
    uint256 ethGoerliFork;
    uint256 arbGoerliFork;
    LZEndpointMock endpointEth;
    LZEndpointMock endpointEth2;
    LZEndpointMock endpointArb;
    LZEndpointMock endpointArb2;
    AppContract appEth;
    AppContract appArb;
    uint8 nonce;

    mapping(uint16 => LZEndpointMock) endpoints;
    mapping(uint16 => uint256) forks;

    /// @dev add chains as necessary
    uint16 chainEth = 10_121;
    uint16 chainArb = 10_143;

    function setUp() public {
        ethGoerliFork = vm.createFork("goerli");
        arbGoerliFork = vm.createFork("arb-goerli");

        vm.selectFork(ethGoerliFork);
        endpointEth = new LZEndpointMock(chainEth);
        appEth = new AppContract(chainEth, address(endpointEth));

        vm.selectFork(arbGoerliFork);
        endpointArb = new LZEndpointMock(chainArb);
        appArb = new AppContract(chainArb, address(endpointArb));

        /// @dev register trusted remotes source => target
        endpointArb.setDestLzEndpoint(address(appEth), address(endpointArb));
        vm.selectFork(ethGoerliFork);
        endpointEth.setDestLzEndpoint(address(appArb), address(endpointEth));

        endpoints[chainEth] = endpointEth;
        endpoints[chainArb] = endpointArb;
        forks[chainEth] = ethGoerliFork;
        forks[chainArb] = arbGoerliFork;
    }

    function relayCrossChainMessage(uint16 sourceChain, uint16 targetChain) public {
        DataTypes.sendData memory data =
            endpoints[sourceChain].getSendData(targetChain, getNonce());

        vm.selectFork(forks[targetChain]);
        try endpoints[targetChain].receivePayload(
            data.targetChainId,
            data.sourceAddress,
            data.targetAddress,
            data.nonce,
            data.extraGas,
            data.payload
        ) {} catch (bytes memory reason) {
            console.logBytes(reason);
        }
    }

    function getNonce() public returns (uint8) {
        nonce = ++nonce;
        return nonce;
    }
}
