import type { DNNSConfig, ResolutionResult } from "./types.js";

export class DNNSClient {
  private readonly apiBaseUrl: string;

  constructor(config: DNNSConfig = {}) {
    this.apiBaseUrl = config.apiBaseUrl ?? "http://localhost:8080";
  }

  async resolve(name: string): Promise<ResolutionResult> {
    const response = await fetch(`${this.apiBaseUrl}/v1/names/${encodeURIComponent(name)}/resolve`);
    if (!response.ok) {
      throw new Error(`Failed to resolve ${name}: ${response.status}`);
    }
    return response.json() as Promise<ResolutionResult>;
  }

  async availability(label: string) {
    const response = await fetch(`${this.apiBaseUrl}/v1/labels/${encodeURIComponent(label)}/availability`);
    if (!response.ok) {
      throw new Error(`Failed to fetch availability for ${label}: ${response.status}`);
    }
    return response.json() as Promise<{
      label: string;
      available: boolean;
      priceWei: string;
      minRegistrationDuration: number;
      gracePeriod: number;
    }>;
  }
}
