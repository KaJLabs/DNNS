// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

interface IVerifier {
    function verifyProof(bytes calldata proof, uint256[] calldata publicInputs) external view returns (bool);
}

contract DNNSZKRegistry {
    struct IdentityProofRecord {
        bytes32 commitment;
        bytes32 schema;
        uint64 updatedAt;
    }

    address public owner;
    IVerifier public verifier;
    mapping(bytes32 => IdentityProofRecord) public commitments;
    mapping(bytes32 => bool) public nullifiers;

    event CommitmentUpdated(bytes32 indexed node, bytes32 commitment, bytes32 schema);
    event ProofValidated(bytes32 indexed node, bytes32 nullifier);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor(address verifierAddress) {
        owner = msg.sender;
        verifier = IVerifier(verifierAddress);
    }

    function setVerifier(address verifierAddress) external onlyOwner {
        verifier = IVerifier(verifierAddress);
    }

    function setCommitment(bytes32 node, bytes32 commitment, bytes32 schema) external {
        commitments[node] = IdentityProofRecord({
            commitment: commitment,
            schema: schema,
            updatedAt: uint64(block.timestamp)
        });
        emit CommitmentUpdated(node, commitment, schema);
    }

    function verifyAndConsume(bytes32 node, bytes32 nullifier, bytes calldata proof, uint256[] calldata publicInputs) external returns (bool) {
        require(!nullifiers[nullifier], "nullifier already used");
        bool ok = verifier.verifyProof(proof, publicInputs);
        require(ok, "invalid proof");
        nullifiers[nullifier] = true;
        emit ProofValidated(node, nullifier);
        return true;
    }
}
