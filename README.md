UnexpectedMintTrap

Network: Hoodi Testnet
Category: Proof-of-Concept Drosera Trap
Trap Type: ERC20 Mint Anomaly Detector

🧠 Overview

UnexpectedMintTrap is a Drosera proof-of-concept trap designed to detect unexpected token minting on a specific ERC20 token.
It monitors the total supply and triggers a response if it exceeds a defined threshold over the known baseline.

This PoC demonstrates how Drosera Traps can automate on-chain anomaly detection without relying on vaults, treasuries, or external dependencies.

⚙️ Configuration Summary
Parameter	Value
Monitored Token	0xaae04B34391cF428c06187793f7a4e76d5b86042
Baseline Supply	1,000,000 * 10¹⁸
Threshold	2,000 * 10¹⁸
Network	Hoodi Testnet (chainId = 560048)
Ethereum RPC	https://ethereum-hoodi-rpc.publicnode.com/
Drosera RPC	https://relay.hoodi.drosera.io/
Drosera Address	0x91cB447BaFc6e0EA0F4Fe056F5a9b1F14bb06e5D
🧩 Contract Architecture
1️⃣ Trap (main logic)

Monitors the ERC20 token supply.

Implements Drosera interface (collect() and shouldRespond(...)).

Fully self-contained: no constructors, no post-deploy function calls.

2️⃣ MintAlertResponder (response contract)

Minimal responder emitting an event when the trap triggers.

Called automatically by Drosera via response_function in drosera.toml.

