// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title UnexpectedMintTrap
 * @notice A Drosera-compatible trap that detects unexpected token minting
 *         for a specified ERC20 token. Monitors totalSupply and triggers
 *         a response if the current supply exceeds the defined threshold.
 */

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata collectOutputs) external pure returns (bool, bytes memory);
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
}

contract Trap is ITrap {
    // 🎯 Monitored Token (18 decimals)
    address public constant TOKEN = 0xaae04B34391cF428c06187793f7a4e76d5b86042;

    // 🧩 Supply Parameters
    uint256 public constant BASELINE = 1_000_000 * (10 ** 18); // 1,000,000 tokens
    uint256 public constant THRESHOLD = 2_000 * (10 ** 18);    // 2,000 tokens allowed variance

    /**
     * @notice Collects the current totalSupply and block number
     * @return ABI-encoded (totalSupply, block.number)
     */
    function collect() external view override returns (bytes memory) {
        uint256 ts = IERC20(TOKEN).totalSupply();
        return abi.encode(ts, block.number);
    }

    /**
     * @notice Checks if token minting exceeds allowed threshold
     * @dev Must be pure for Drosera trap verification
     * @param collectOutputs Data collected from previous collect() calls
     * @return (true, payload) if anomaly detected
     */
    function shouldRespond(bytes[] calldata collectOutputs)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (collectOutputs.length == 0) {
            return (false, "");
        }

        (uint256 latestTotalSupply, uint256 latestBlock) =
            abi.decode(collectOutputs[0], (uint256, uint256));

        uint256 allowedMax = BASELINE + THRESHOLD;
        if (latestTotalSupply > allowedMax) {
            uint256 delta = latestTotalSupply - BASELINE;
            bytes memory payload = abi.encode(
                TOKEN,
                BASELINE,
                latestTotalSupply,
                delta,
                latestBlock
            );
            return (true, payload);
        }

        return (false, "");
    }
}
