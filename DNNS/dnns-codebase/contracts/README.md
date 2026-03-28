# DNNS Contracts

This folder contains the Makalu EVM reference contracts for DNNS v1.

## Contracts

- `DNNSRegistry.sol` — registration, pricing, resolver binding, expiry metadata
- `DNNSResolver.sol` — resolution records for EVM, Cosmos, content, API endpoints, and text records
- `DNNSAgentRegistry.sol` — agent profiles with endpoint, capabilities, stake, zk identity commitment
- `DNNSReputation.sol` — trust vectors and reporter-based score updates
- `DNNSZKRegistry.sol` — zk commitment storage and verifier hook

## Deployment order

1. Deploy `DNNSRegistry`
2. Deploy `DNNSResolver(registry)`
3. Deploy `DNNSAgentRegistry(registry)`
4. Deploy `DNNSReputation()`
5. Deploy `DNNSZKRegistry(verifier)`
6. Set environment variables in `apps/api/.env`
