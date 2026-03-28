# Lithosphere DNNS

Author: J. King Kasr  
Maintainer: KaJ Labs  
Contributors: KaJ Labs Research, Lithosphere Core Dev Team

DNNS is a decentralized naming and identity stack for Lithosphere Web4 environments. This repository includes:

- EVM contracts for Makalu testnet deployment
- A TypeScript API service for registration, resolution, agent discovery, and reputation reads
- A TypeScript SDK for apps, wallets, and agent runtimes
- GitHub-ready docs for architecture, SDK, and API usage

## Monorepo layout

```text
apps/api            Fastify-based DNNS service
packages/sdk        TypeScript SDK
contracts           Solidity contracts for Makalu EVM deployment
docs                GitHub documentation
config              Example environment and deployment config
```

## Makalu network defaults

- EVM Chain ID: `777777`
- Cosmos Chain ID: `lithosphere_777777-1`
- RPC: `https://rpc.litho.ai`
- Name root: `.litho`

## Quick start

```bash
npm install
cp config/.env.example apps/api/.env
npm run build:sdk
npm run dev:api
```

## Contract suite

- `DNNSRegistry.sol` — root registry, expiries, metadata pointers
- `DNNSResolver.sol` — EVM/Cosmos/content/API resolution records
- `DNNSAgentRegistry.sol` — agent descriptors, capabilities, stake data
- `DNNSReputation.sol` — score aggregation and signed updates
- `DNNSZKRegistry.sol` — zk identity commitments and verifier hooks

## Status

This is a production-oriented reference codebase and documentation set for DNNS v1 on Makalu. Contract integration points for Lithic, LEP100, and zk circuits are scaffolded but should be connected to the exact chain runtime and verifier artifacts before mainnet launch.
