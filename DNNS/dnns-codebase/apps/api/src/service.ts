import { ethers } from "ethers";
import { z } from "zod";
import { AGENT_REGISTRY_ABI, REGISTRY_ABI, REPUTATION_ABI, RESOLVER_ABI } from "./contracts.js";
import { namehash } from "./namehash.js";

const envSchema = z.object({
  RPC_URL: z.string().url(),
  REGISTRY_ADDRESS: z.string().length(42),
  RESOLVER_ADDRESS: z.string().length(42),
  AGENT_REGISTRY_ADDRESS: z.string().length(42),
  REPUTATION_ADDRESS: z.string().length(42)
});

export class DNNSService {
  readonly provider: ethers.JsonRpcProvider;
  readonly registry: ethers.Contract;
  readonly resolver: ethers.Contract;
  readonly agentRegistry: ethers.Contract;
  readonly reputation: ethers.Contract;

  constructor(rawEnv: Record<string, string | undefined>) {
    const env = envSchema.parse(rawEnv);
    this.provider = new ethers.JsonRpcProvider(env.RPC_URL);
    this.registry = new ethers.Contract(env.REGISTRY_ADDRESS, REGISTRY_ABI, this.provider);
    this.resolver = new ethers.Contract(env.RESOLVER_ADDRESS, RESOLVER_ABI, this.provider);
    this.agentRegistry = new ethers.Contract(env.AGENT_REGISTRY_ADDRESS, AGENT_REGISTRY_ABI, this.provider);
    this.reputation = new ethers.Contract(env.REPUTATION_ADDRESS, REPUTATION_ABI, this.provider);
  }

  async resolveName(name: string) {
    const node = namehash(name);
    const [owner, expiresAt, resolverAddress, metadataURI, evmAddress, cosmos, contenthash, endpoint, score, trustVector, agent] = await Promise.all([
      this.registry.ownerOf(node),
      this.registry.expiresAt(node),
      this.registry.resolverOf(node),
      this.registry.metadataURI(node),
      this.resolver.addr(node),
      this.resolver.cosmos(node),
      this.resolver.contenthash(node),
      this.resolver.endpoint(node),
      this.reputation.scoreOf(node),
      this.reputation.trustVectorOf(node),
      this.agentRegistry.getAgent(node).catch(() => null)
    ]);

    return {
      name,
      node,
      owner,
      expiresAt: Number(expiresAt),
      resolverAddress,
      metadataURI,
      records: {
        evmAddress,
        cosmos,
        contenthash,
        endpoint
      },
      reputation: {
        score: Number(score),
        trustVector
      },
      agent
    };
  }

  async checkAvailability(label: string) {
    const status = await this.registry.labelStatus(label.toLowerCase());
    return {
      label: label.toLowerCase(),
      available: status.available,
      priceWei: status.priceWei.toString(),
      minRegistrationDuration: Number(status.minRegistrationDuration),
      gracePeriod: Number(status.gracePeriod)
    };
  }
}
