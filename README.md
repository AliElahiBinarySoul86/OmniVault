# OmniVault — ERC20 Streaming & Vesting Engine

OmniVault is a production-grade ERC20 smart contract that combines
on-chain vesting, continuous token streaming, and role-based treasury
management into a single, audit-ready architecture.

This project is intentionally designed as a senior-level Solidity
portfolio showcase.

## Core Features

- ERC20 compliant token (OpenZeppelin)
- Continuous linear token streaming
- Multi-stream support per beneficiary
- Pull-based claim mechanism
- Role-based treasury control (DAO-ready)
- No loops during claims (highly scalable)
- Gas-optimized storage layout
- Custom errors for lower gas costs
- Reentrancy protection

## Use Cases

- Team & advisor vesting
- Token payroll / salary streaming
- DAO treasury distributions
- Web3 startup token allocation
- Security and audit demonstrations

## Architecture

- Tokens are minted directly to the contract vault
- Treasury assigns time-based streams to beneficiaries
- Beneficiaries claim vested tokens on demand
- No admin intervention required after stream creation

## Security Design

- Pull-over-push payments
- ReentrancyGuard on all external state changes
- Strict AccessControl roles
- Overflow-safe arithmetic (Solidity ^0.8.x)
- No external calls except ERC20 transfers

## Tech Stack

- Solidity ^0.8.24
- OpenZeppelin Contracts
- EVM-compatible chains

## Why OmniVault

This repository demonstrates:
- Real-world token mechanics
- Clean, readable Solidity
- Security-first design
- Production readiness

## License

MIT
