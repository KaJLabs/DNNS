// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IRegistryOwner {
    function ownerOf(bytes32 node) external view returns (address);
}

contract DNNSResolver {
    IRegistryOwner public immutable registry;

    mapping(bytes32 => address) private evmAddrs;
    mapping(bytes32 => string) private cosmosAddrs;
    mapping(bytes32 => bytes) private contentHashes;
    mapping(bytes32 => string) private endpoints;
    mapping(bytes32 => mapping(string => string)) private textRecords;

    event AddrChanged(bytes32 indexed node, address addr);
    event CosmosChanged(bytes32 indexed node, string cosmos);
    event ContenthashChanged(bytes32 indexed node, bytes hash);
    event EndpointChanged(bytes32 indexed node, string endpoint);
    event TextChanged(bytes32 indexed node, string key, string value);

    constructor(address registryAddress) {
        registry = IRegistryOwner(registryAddress);
    }

    modifier onlyNodeOwner(bytes32 node) {
        require(registry.ownerOf(node) == msg.sender, "not node owner");
        _;
    }

    function addr(bytes32 node) external view returns (address) {
        return evmAddrs[node];
    }

    function cosmos(bytes32 node) external view returns (string memory) {
        return cosmosAddrs[node];
    }

    function contenthash(bytes32 node) external view returns (bytes memory) {
        return contentHashes[node];
    }

    function endpoint(bytes32 node) external view returns (string memory) {
        return endpoints[node];
    }

    function text(bytes32 node, string calldata key) external view returns (string memory) {
        return textRecords[node][key];
    }

    function setAddr(bytes32 node, address value) external onlyNodeOwner(node) {
        evmAddrs[node] = value;
        emit AddrChanged(node, value);
    }

    function setCosmos(bytes32 node, string calldata value) external onlyNodeOwner(node) {
        cosmosAddrs[node] = value;
        emit CosmosChanged(node, value);
    }

    function setContenthash(bytes32 node, bytes calldata value) external onlyNodeOwner(node) {
        contentHashes[node] = value;
        emit ContenthashChanged(node, value);
    }

    function setEndpoint(bytes32 node, string calldata value) external onlyNodeOwner(node) {
        endpoints[node] = value;
        emit EndpointChanged(node, value);
    }

    function setText(bytes32 node, string calldata key, string calldata value) external onlyNodeOwner(node) {
        textRecords[node][key] = value;
        emit TextChanged(node, key, value);
    }
}
