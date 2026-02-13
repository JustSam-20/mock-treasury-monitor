# ðŸ›¡ï¸ Treasury Drain Monitor (Drosera Trap)

> **Network:** Hoodi Testnet  
> **Status:** ðŸŸ¢ Active / Hardened  
> **Framework:** Drosera Network (v1)

## ðŸ“– Overview
This repository contains a fully hardened **Drosera Trap** designed to monitor a specific Treasury Wallet for unauthorized drains or low liquidity events. 

If the balance of the monitored token (`DTRE`) drops below a critical threshold (`500,000 DTRE`), the trap triggers an on-chain response to alert operators or pause protocol functionality.

## ðŸ—ï¸ Architecture

The system consists of three main components:
1. **The Trap (`TreasuryTrap.sol`):** A stateless watchdog that queries the blockchain.
2. **The Response (`TreasuryResponse.sol`):** An authorized contract that executes emergency actions.
3. **The Target:** A Mock Token and Treasury Wallet on the Hoodi testnet.

### Logic Flow
1. **Collect (View):** Operator queries the `MockToken` contract for the `TreasuryWallet` balance.
2. **Analyze (Pure):** The trap logic compares `currentBalance` vs `MIN_BALANCE` (500k).
3. **Decide:** - If `balance >= 500k`: Returns `false` (Green/Secure).
   - If `balance < 500k`: Returns `true` (Red/Alert).
4. **Respond:** The Drosera Executor calls `alertTreasuryDrain()` on the Response contract.

## ðŸ”’ Security Hardening (Reviewer Notes)
This trap implements strict security patterns to ensure reliability in a decentralized operator environment:

- **âœ… Crash Protection:** `collect()` is wrapped in a `try/catch` block. If the target token pauses or reverts, the trap returns empty bytes instead of bricking the operator node.
- **âœ… Data Guard:** `shouldRespond()` strictly enforces `data.length` checks. It rejects any payload that isn't exactly 64 bytes (two `uint256` slots), preventing ABI decoding crashes.
- **âœ… Statelessness:** The logic relies purely on chain state samples, compatible with Drosera's shadow-fork execution model.
- **âœ… Access Control:** The Response contract explicitly authorizes the **Drosera Executor** (`0x91cB...`) to ensure alerts are successfully delivered.

## ðŸ“ Deployed Contracts (Hoodi Testnet)

| Component | Address |
|-----------|---------|
| **Trap Logic** | `0xe04d0c303f6E48e44c2Dac3E4Db4D00E237093E3` |
| **Response** | `0xfFcacf4e403E5d053459373e79ffE5f92aE720c6` |
| **Monitored Token** | `0x33c934b97be8FC22683Ab235F5Cb35C355e8BEA4` |
| **Treasury Wallet** | `0xcF75BeA7A11Eb8A764dC85DEf2F36c3ed826aE59` |

## ðŸš€ Usage

### Prerequisites
- [Foundry](https://github.com/foundry-rs/foundry)
- [Drosera CLI](https://github.com/drosera-network/drosera-cli)

### Build
```bash
forge build
```

### Test Logic (Dryrun)
```bash
drosera dryrun
```

## ðŸ“œ License
MIT
