// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DNNSRegistry {
    struct LabelStatus {
        bool available;
        uint256 priceWei;
        uint256 minRegistrationDuration;
        uint256 gracePeriod;
    }

    struct Record {
        address owner;
        address resolver;
        uint64 expiresAt;
        string metadataURI;
    }

    address public owner;
    uint256 public basePriceWei = 0.01 ether;
    uint256 public minRegistrationDuration = 365 days;
    uint256 public gracePeriod = 90 days;

    mapping(bytes32 => Record) private records;
    mapping(bytes32 => bool) public reserved;

    event NameRegistered(bytes32 indexed node, address indexed registrant, uint64 expiresAt, string metadataURI);
    event ResolverUpdated(bytes32 indexed node, address indexed resolver);
    event MetadataURIUpdated(bytes32 indexed node, string metadataURI);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyNodeOwner(bytes32 node) {
        require(records[node].owner == msg.sender, "not node owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function ownerOf(bytes32 node) external view returns (address) {
        return records[node].owner;
    }

    function expiresAt(bytes32 node) external view returns (uint256) {
        return records[node].expiresAt;
    }

    function resolverOf(bytes32 node) external view returns (address) {
        return records[node].resolver;
    }

    function metadataURI(bytes32 node) external view returns (string memory) {
        return records[node].metadataURI;
    }

    function labelStatus(string calldata label) external view returns (LabelStatus memory) {
        bytes32 node = keccak256(bytes(label));
        return LabelStatus({
            available: records[node].owner == address(0) && !reserved[node],
            priceWei: currentPrice(label),
            minRegistrationDuration: minRegistrationDuration,
            gracePeriod: gracePeriod
        });
    }

    function register(string calldata label, address registrant, uint64 duration, string calldata metadata) external payable returns (bytes32 node) {
        require(duration >= minRegistrationDuration, "duration too short");
        node = keccak256(bytes(label));
        require(records[node].owner == address(0), "already registered");
        require(!reserved[node], "reserved");
        require(msg.value >= currentPrice(label), "insufficient payment");

        records[node] = Record({
            owner: registrant,
            resolver: address(0),
            expiresAt: uint64(block.timestamp + duration),
            metadataURI: metadata
        });

        emit NameRegistered(node, registrant, uint64(block.timestamp + duration), metadata);
    }

    function setResolver(bytes32 node, address resolver) external onlyNodeOwner(node) {
        records[node].resolver = resolver;
        emit ResolverUpdated(node, resolver);
    }

    function setMetadataURI(bytes32 node, string calldata metadata) external onlyNodeOwner(node) {
        records[node].metadataURI = metadata;
        emit MetadataURIUpdated(node, metadata);
    }

    function reserve(bytes32 node, bool value) external onlyOwner {
        reserved[node] = value;
    }

    function setPricing(uint256 newBasePriceWei) external onlyOwner {
        basePriceWei = newBasePriceWei;
    }

    function currentPrice(string memory label) public view returns (uint256) {
        uint256 len = bytes(label).length;
        if (len <= 3) return basePriceWei * 20;
        if (len == 4) return basePriceWei * 5;
        return basePriceWei;
    }
}
