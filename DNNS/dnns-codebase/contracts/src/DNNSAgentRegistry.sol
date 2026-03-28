// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IAgentRegistryOwner {
    function ownerOf(bytes32 node) external view returns (address);
}

contract DNNSAgentRegistry {
    struct Agent {
        bool active;
        string endpoint;
        string[] capabilities;
        uint256 stake;
        bytes32 identityCommitment;
        string metadataURI;
    }

    IAgentRegistryOwner public immutable registry;
    mapping(bytes32 => Agent) private agents;

    event AgentRegistered(bytes32 indexed node, string endpoint, uint256 stake);
    event AgentStatusChanged(bytes32 indexed node, bool active);

    constructor(address registryAddress) {
        registry = IAgentRegistryOwner(registryAddress);
    }

    modifier onlyNodeOwner(bytes32 node) {
        require(registry.ownerOf(node) == msg.sender, "not node owner");
        _;
    }

    function registerAgent(
        bytes32 node,
        string calldata endpoint,
        string[] calldata capabilities,
        bytes32 identityCommitment,
        string calldata metadataURI
    ) external payable onlyNodeOwner(node) {
        Agent storage agent = agents[node];
        agent.active = true;
        agent.endpoint = endpoint;
        agent.identityCommitment = identityCommitment;
        agent.metadataURI = metadataURI;
        agent.stake += msg.value;
        delete agent.capabilities;
        for (uint256 i = 0; i < capabilities.length; i++) {
            agent.capabilities.push(capabilities[i]);
        }
        emit AgentRegistered(node, endpoint, agent.stake);
    }

    function setAgentStatus(bytes32 node, bool active) external onlyNodeOwner(node) {
        agents[node].active = active;
        emit AgentStatusChanged(node, active);
    }

    function getAgent(bytes32 node) external view returns (Agent memory) {
        return agents[node];
    }
}
