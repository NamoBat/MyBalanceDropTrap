// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "./ITrap.sol";

contract MyBalanceDropTrap is ITrap {
    address public constant TARGET = wallet_address;
    uint256 public constant DROP_BPS_THRESHOLD = 1_000;
    uint8   public constant MIN_SAMPLES = 2;

    constructor() {}

    function collect() external view override returns (bytes memory) {
        uint256 bal = TARGET.balance;
        uint256 blk = block.number;
        return abi.encode(bal, blk);
    }

    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < MIN_SAMPLES) return (false, "");

        (uint256 balNow, uint256 blkNow)   = abi.decode(data[0], (uint256, uint256));
        (uint256 balPrev, /*blkPrev*/)     = abi.decode(data[1], (uint256, uint256));

        if (balPrev == 0 || balNow >= balPrev) return (false, "");

        uint256 dropBps = ((balPrev - balNow) * 10_000) / balPrev;
        if (dropBps < DROP_BPS_THRESHOLD) return (false, "");

        bytes memory payload = abi.encode(TARGET, balPrev, balNow, dropBps, blkNow);
        return (true, payload);
    }
}
