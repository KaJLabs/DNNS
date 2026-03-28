export const REGISTRY_ABI = [
  "function ownerOf(bytes32 node) view returns (address)",
  "function expiresAt(bytes32 node) view returns (uint256)",
  "function resolverOf(bytes32 node) view returns (address)",
  "function metadataURI(bytes32 node) view returns (string)",
  "function labelStatus(string label) view returns (tuple(bool available,uint256 priceWei,uint256 minRegistrationDuration,uint256 gracePeriod))"
] as const;

export const RESOLVER_ABI = [
  "function addr(bytes32 node) view returns (address)",
  "function cosmos(bytes32 node) view returns (string)",
  "function contenthash(bytes32 node) view returns (bytes)",
  "function text(bytes32 node, string key) view returns (string)",
  "function endpoint(bytes32 node) view returns (string)"
] as const;

export const AGENT_REGISTRY_ABI = [
  "function getAgent(bytes32 node) view returns (tuple(bool active, string endpoint, string[] capabilities, uint256 stake, bytes32 identityCommitment, string metadataURI))"
] as const;

export const REPUTATION_ABI = [
  "function scoreOf(bytes32 node) view returns (uint256)",
  "function trustVectorOf(bytes32 node) view returns (tuple(uint64 successfulSettlements,uint64 failedSettlements,uint64 peerEndorsements,uint64 penalties))"
] as const;
