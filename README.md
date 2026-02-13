# Drosera Treasury Drain Monitor (Hoodi Testnet)

> **Status:** 🟢 Active / Hardened  
> **Network:** Hoodi Testnet (Chain ID: 560048)

This project implements a security trap on the **Drosera Network** (Hoodi Testnet). It monitors a specific Treasury Wallet (holding MockToken) and triggers an automated incident response if the balance drops below a critical threshold.

## 🏗 Architecture

The security system consists of four main components:

1.  **Target Token (MockToken):** An ERC-20 token representing a DAO treasury asset.
    * **Address:** `0x33c934b97be8FC22683Ab235F5Cb35C355e8BEA4`

2.  **Monitored Treasury:** The specific wallet being watched.
    * **Address:** `0xcF75BeA7A11Eb8A764dC85DEf2F36c3ed826aE59`

3.  **The Trap (TreasuryTrap):** A stateless contract that checks the token balance.
    * **Logic:** Triggers if balance < `500,000 DTRE`.
    * **Type:** Private Trap (Stateless)
    * **Deployed Address:** `0xe04d0c303f6E48e44c2Dac3E4Db4D00E237093E3`

4.  **Response (TreasuryResponse):** An authorized contract that executes defensive actions (alerting) when the trap triggers.
    * **Address:** `0xfFcacf4e403E5d053459373e79ffE5f92aE720c6`

## 🔒 Security Hardening (Reviewer Notes)
This trap implements strict security patterns to ensure reliability in a decentralized operator environment:

- **✅ Crash Protection:** `collect()` is wrapped in a `try/catch` block. If the target token pauses or reverts, the trap returns empty bytes instead of bricking the operator node.
- **✅ Data Guard:** `shouldRespond()` strictly enforces `data.length` checks (Must be exactly 64 bytes), preventing ABI decoding crashes.
- **✅ Access Control:** The Response contract explicitly authorizes the **Drosera Executor** (`0x91cB...`) to ensure alerts are successfully delivered.

## 🚀 Setup & Installation

### Prerequisites
* [Foundry](https://book.getfoundry.sh/) (Forge)
* [Drosera CLI](https://docs.drosera.io/)
* Docker (for Operator node)

### Build
This project uses manual library mappings for stability.
```bash
forge build
```

### Configuration
Ensure your `.env` file is set (NOT included in repo for security):
```bash
PRIVATE_KEY=your_private_key
RPC_URL=[https://rpc.hoodi.ethpandaops.io](https://rpc.hoodi.ethpandaops.io)
```

## 🛠 Operational Commands

### Dry Run (Test Logic)
Simulates the trap execution locally against the live network.
```bash
drosera dryrun
```

### Deploy / Update
Registers the trap configuration with the Drosera Protocol.
```bash
drosera apply
```

## 📂 Directory Structure
* `src/` - Solidity smart contracts (Trap, MockToken, Response).
* `lib/` - Dependencies (OpenZeppelin, Drosera Interfaces).
* `drosera.toml` - Network and Trap configuration.

---
*Maintained by JustSam-20*
