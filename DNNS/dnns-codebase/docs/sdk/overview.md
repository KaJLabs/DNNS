# DNNS SDK

The DNNS SDK provides a thin client for DNNS name resolution and availability checks.

## Install

```bash
npm install @litho/dnns-sdk
```

## Usage

```ts
import { DNNSClient, namehash } from "@litho/dnns-sdk";

const client = new DNNSClient({
  apiBaseUrl: "https://dnns-api.example"
});

const result = await client.resolve("arb.agent.makalu.litho");
console.log(result.records.endpoint);
console.log(namehash("arb.agent.makalu.litho"));
```

## Exports

- `DNNSClient`
- `namehash(name)`
- `labelhash(label)`
- `ResolutionResult`

## Planned additions

- Direct on-chain write helpers
- Agent negotiation helpers
- zk proof packaging helpers
- Reverse resolution helpers
