export interface DNNSConfig {
  apiBaseUrl?: string;
  chainId?: number;
  rpcUrl?: string;
}

export interface ResolutionResult {
  name: string;
  node: string;
  owner: string;
  expiresAt: number;
  resolverAddress: string;
  metadataURI: string;
  records: {
    evmAddress: string;
    cosmos: string;
    contenthash: string;
    endpoint: string;
  };
  reputation: {
    score: number;
    trustVector: {
      successfulSettlements: bigint;
      failedSettlements: bigint;
      peerEndorsements: bigint;
      penalties: bigint;
    };
  };
  agent: null | {
    active: boolean;
    endpoint: string;
    capabilities: string[];
    stake: bigint;
    identityCommitment: string;
    metadataURI: string;
  };
}
