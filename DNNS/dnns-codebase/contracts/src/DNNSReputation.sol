// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract DNNSReputation {
    struct TrustVector {
        uint64 successfulSettlements;
        uint64 failedSettlements;
        uint64 peerEndorsements;
        uint64 penalties;
    }

    address public owner;
    mapping(address => bool) public reporters;
    mapping(bytes32 => uint256) private scores;
    mapping(bytes32 => TrustVector) private vectors;

    event ReporterSet(address indexed reporter, bool active);
    event ScoreUpdated(bytes32 indexed node, uint256 score);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    modifier onlyReporter() {
        require(reporters[msg.sender], "not reporter");
        _;
    }

    constructor() {
        owner = msg.sender;
        reporters[msg.sender] = true;
    }

    function setReporter(address reporter, bool active) external onlyOwner {
        reporters[reporter] = active;
        emit ReporterSet(reporter, active);
    }

    function submitDelta(
        bytes32 node,
        uint64 successful,
        uint64 failed,
        uint64 endorsements,
        uint64 penalties,
        uint256 scoreDelta,
        bool increase
    ) external onlyReporter {
        TrustVector storage vector = vectors[node];
        vector.successfulSettlements += successful;
        vector.failedSettlements += failed;
        vector.peerEndorsements += endorsements;
        vector.penalties += penalties;

        if (increase) {
            scores[node] += scoreDelta;
        } else if (scoreDelta >= scores[node]) {
            scores[node] = 0;
        } else {
            scores[node] -= scoreDelta;
        }

        emit ScoreUpdated(node, scores[node]);
    }

    function scoreOf(bytes32 node) external view returns (uint256) {
        return scores[node];
    }

    function trustVectorOf(bytes32 node) external view returns (TrustVector memory) {
        return vectors[node];
    }
}
