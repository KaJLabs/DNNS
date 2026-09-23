# DNNS Documentation

This documentation set is structured for a GitHub repository and can be rendered directly in GitHub or moved into MkDocs, Docusaurus, Nextra, or Fumadocs.

## Supported explorer interface

The supported explorer-resolution interface is the DNNS v0 deployment on
**Lithosphere Kamet**. Makalu explorers resolve `.litho` names by making
read-only requests to this Kamet deployment; there is no independently
supported Makalu DNNS registry.

| Field | Authoritative value |
| --- | --- |
| Network | Lithosphere Kamet |
| EVM chain ID | `900523` |
| Cosmos chain ID | `lithosphere_900523-2` |
| RPC | `https://rpc-3.litho.ai` |
| TLD | `.litho` |
| Supported name form | One second-level label (2LD) |

### Deployed contracts

| Contract | Address |
| --- | --- |
| Registry | `0x316dc15bF377F7187e5BE38BA19e673Ca823d1ab` |
| Base registrar | `0xB3D1a8e92FFAD73Ab8a07BF37A8E1374df8B3722` |
| Registrar controller | `0xb042145B0Fd44b53691b59E98bE8F9F9EB0365c5` |
| Original public resolver | `0xc0F0849e09Df12E54fe4345ab4535B1F521f2190` |
| Wrapper-aware public resolver | `0x54639d978418766ccaD25ffb22C58fd5A5Df8C09` |
| Reverse registrar | `0xDeFae50866342C8f72bd03292FFeAeb53eC781C2` |
| Zero-price oracle | `0xD3E0f31AB733C845ED9E4121d547Ca05E99384EB` |
| Name wrapper | `0xc47E49259b8dDa2C9D57941E1a52747E4c721Cb9` |

Clients must obtain the resolver for each name from the registry. They must
not assume that every name uses the same public resolver.

### Normalization and resolution rules

- Trim surrounding whitespace and lowercase the input.
- Accept exactly one label before `.litho`.
- Require at least three label characters.
- Permit only `a-z`, `0-9`, and hyphens; reject leading or trailing hyphens.
- Reject subdomains and malformed names before making an RPC request.
- Treat an unset resolver or zero address as "not found" and distinguish that
  result from an RPC/provider failure.

For reverse resolution, compute the standard `<lowercase-address>.addr.reverse`
node and read its registry-selected resolver. A returned reverse name is never
authoritative by itself: clients may display it only after the name resolves
forward to the queried checksum address. The nominated stable acceptance
fixture is:

- Name: `kamet.litho`
- Address: `0xE9267bDf7084815B0754545049AE45FE744Aefa8`

Explorer clients do not persist positive or negative DNNS resolution results.
This avoids stale results after an on-chain record change.

## Contents

- [Architecture](./architecture/overview.md)
- [API Overview](./api/overview.md)
- [OpenAPI Spec](./api/openapi.yaml)
- [SDK Guide](./sdk/overview.md)
