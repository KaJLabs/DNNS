import { keccak256, toUtf8Bytes } from "ethers";

export function labelhash(label: string): string {
  return keccak256(toUtf8Bytes(label.toLowerCase()));
}

export function namehash(name: string): string {
  const normalized = name.trim().toLowerCase().replace(/\.$/, "");
  if (!normalized) return "0x" + "00".repeat(32);
  return normalized.split(".").reverse().reduce((node, label) => {
    const encoded = node.slice(2) + labelhash(label).slice(2);
    return keccak256("0x" + encoded);
  }, "0x" + "00".repeat(32));
}
