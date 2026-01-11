# Comitiva

**Comitiva** is a smart contract that acts as a **basic multi-signature wallet**, allowing a group of owners to hold funds (in ETH) and spend them only when a minimum number of owners approve the transaction, as defined by the approval threshold.  

This is a **proof-of-concept (PoC)** version — minimal, safe for EOAs, and ETH-only, designed for experimentation or small-scale trusted groups.  

---

## How it works

- The **owners** and **confirmation threshold** are defined at contract deployment and are **immutable** unless an `updateThreshold` function is implemented.  
- **Only owners** can submit or confirm transactions.  
- **Transactions are executed only when enough confirmations are collected**, according to the threshold.  
- **Anyone can deposit ETH** into the contract at any time.  
- The contract **assumes all owners are EOAs**, so reentrancy protection is not required.  

**Example:**  

If 5 owners deploy the wallet with a threshold of 3, a transaction requires **at least 3 owner confirmations** before it can execute. This ensures that no single owner can unilaterally transfer funds.  

---

## Key Features

| Feature | Description |
|---------|-------------|
| Multi-owner approval | Transactions require multiple confirmations |
| Configurable threshold | Number of required confirmations set at deployment |
| Immutable owners | Owners are fixed at deployment (PoC version) |
| ETH-only transfers | Can send ETH to any address |
| Public deposits | Anyone can deposit ETH into the wallet |
| On-chain enforcement | Transaction rules are fully enforced by Ethereum |
| EOAs assumption | Owners are assumed to be externally owned accounts, so no reentrancy guard needed |

---

## Limitations (PoC)

- Only ETH transfers are supported.  
- Owners cannot be removed or added in the current minimal version (though `addOwner` can be implemented).  
- No event emissions — monitoring requires off-chain transaction inspection.  
- Loops in owner verification scale linearly with the number of owners.  
- Threshold is fixed unless `updateThreshold` is implemented.  

---

## Disclaimer

This is a **minimal proof-of-concept contract**. Only deploy and use with trusted participants and EOAs. The contract **does not include advanced security features or event logging**. Use at your own risk.  
