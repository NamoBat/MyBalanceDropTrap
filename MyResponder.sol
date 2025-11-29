// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

contract MyResponder {
    event AnomalyHandled(
        address indexed target,
        uint256 prevBal,
        uint256 currBal,
        uint256 dropBps,
        uint256 atBlock
    );

    function handleAnomaly(bytes calldata payload) external {
        (address target, uint256 prevBal, uint256 currBal, uint256 dropBps, uint256 atBlock) =
            abi.decode(payload, (address, uint256, uint256, uint256, uint256));

        emit AnomalyHandled(target, prevBal, currBal, dropBps, atBlock);
    }
}
