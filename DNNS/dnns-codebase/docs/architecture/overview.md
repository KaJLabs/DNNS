# DNNS Architecture Overview

Author: J. King Kasr  
Maintained by: KaJ Labs

## Goals

DNNS provides identity, naming, resolution, agent discovery, and reputation infrastructure for Lithosphere Web4 workloads.

## Components

```mermaid
graph TD
    Client[Wallet / App / Agent Runtime] --> SDK[DNNS SDK]
    SDK --> API[DNNS API Service]
    SDK --> EVM[Makalu EVM Contracts]
    API --> EVM
    EVM --> Registry[DNNSRegistry]
    EVM --> Resolver[DNNSResolver]
    EVM --> Agents[DNNSAgentRegistry]
    EVM --> Reputation[DNNSReputation]
    EVM --> ZK[DNNSZKRegistry]
```

## Flow: Resolve a name

```mermaid
sequenceDiagram
    participant C as Client
    participant S as SDK
    participant A as API
    participant R as Registry
    participant Z as Resolver
    participant P as Reputation
    participant G as AgentRegistry

    C->>S: resolve("arb.agent.makalu.litho")
    S->>A: GET /v1/names/:name/resolve
    A->>R: ownerOf, expiresAt, resolverOf, metadataURI
    A->>Z: addr, cosmos, endpoint, contenthash
    A->>P: scoreOf, trustVectorOf
    A->>G: getAgent
    A-->>S: aggregated response
    S-->>C: ResolutionResult
```

## Storage model

| Component | Key | Value |
|---|---|---|
| Registry | `bytes32 node` | owner, resolver, expiry, metadata URI |
| Resolver | `bytes32 node` | EVM/Cosmos/content/API/text records |
| Agent registry | `bytes32 node` | agent descriptor, stake, commitment |
| Reputation | `bytes32 node` | score and trust vector |
| zk registry | `bytes32 node` | commitment, schema, nullifier usage |

## Security notes

- The API is read-focused by default.
- Ownership enforcement is handled on-chain.
- Reputation uses trusted reporter accounts until decentralized attestation is enabled.
- zk proofs require a production verifier and audited circuits before launch.
