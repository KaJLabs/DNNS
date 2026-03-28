# DNNS API

The DNNS API is a thin service layer above Makalu EVM contracts. It offers aggregated reads and a stable JSON interface for apps, wallets, explorers, and agent runtimes.

## Base URL

```text
http://localhost:8080
```

## Endpoints

### `GET /health`
Returns service health.

### `GET /v1/names/:name/resolve`
Returns aggregated records, reputation, and agent state for a DNNS name.

### `GET /v1/labels/:label/availability`
Returns registration availability and pricing information for a label.

## Example response

```json
{
  "name": "arb.agent.makalu.litho",
  "node": "0x...",
  "owner": "0x1234...",
  "expiresAt": 1791764980,
  "resolverAddress": "0xabcd...",
  "metadataURI": "ipfs://...",
  "records": {
    "evmAddress": "0x1234...",
    "cosmos": "litho1...",
    "contenthash": "0xe301...",
    "endpoint": "https://agent.example"
  },
  "reputation": {
    "score": 840,
    "trustVector": {
      "successfulSettlements": 34,
      "failedSettlements": 1,
      "peerEndorsements": 12,
      "penalties": 0
    }
  },
  "agent": {
    "active": true,
    "endpoint": "https://agent.example",
    "capabilities": ["swap", "quote", "settle"],
    "stake": "2000000000000000000",
    "identityCommitment": "0x...",
    "metadataURI": "ipfs://..."
  }
}
```

## Design choices

- Aggregation reduces client round-trips.
- The API does not mutate on-chain state in this reference build.
- Signing, rate limiting, caching, and indexing should be added before public deployment.
