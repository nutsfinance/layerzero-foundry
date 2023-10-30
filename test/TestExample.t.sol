// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {TestBase} from "./utils/TestBase.sol";
import {console} from "forge-std/console.sol";

contract TestExample is TestBase {
    function test() public {
        vm.selectFork(ethGoerliFork);

        /// @notice set the route
        uint16 source = chainEth;
        uint16 target = chainArb;

        /// @dev prepare the data
        bytes memory payload = abi.encode(target, 1, block.timestamp);
        bytes memory path = abi.encodePacked(address(appArb), address(appEth));

        /// @dev perform app logic
        appEth.send{value: 1 ether}(target, path, payload);

        /// @notice relay a message to the fork
        relayCrossChainMessage(source, target);
    }
}
