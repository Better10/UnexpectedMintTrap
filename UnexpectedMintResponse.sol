// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MintAlertResponder {
    event MintAlert(address indexed token, uint256 baseline, uint256 current, uint256 delta, uint256 blockNumber, address reporter);

    // No constructor. Minimal responder that emits an event when called by Drosera relay/agents.
    // Signature must match drosera.toml response_function below:
    // respondWithMintAlert(address token, uint256 baseline, uint256 current, uint256 delta)
    function respondWithMintAlert(address token, uint256 baseline, uint256 current, uint256 delta) external {
        emit MintAlert(token, baseline, current, delta, block.number, msg.sender);
        // Keep intentionally minimal: no transfers, no external dependencies, no owner required.
    }
}
