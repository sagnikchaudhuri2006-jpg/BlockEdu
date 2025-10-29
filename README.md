# 🎓 On-Chain Transcript Management and Verification

A simple **Solidity smart contract** that enables universities or institutions to **store, manage, and verify student transcripts** securely on the blockchain.  
This project demonstrates how blockchain technology can ensure **authenticity, transparency, and immutability** of academic records.

---
<img width="1920" height="1080" alt="Screenshot 2025-10-29 140113" src="https://github.com/user-attachments/assets/b3039bfd-ea53-4278-9ee8-21b1aaf5c1fa" />

## 🚀 Overview

Traditional transcript management systems are centralized and prone to tampering or forgery.  
This project offers a decentralized approach — using **Ethereum smart contracts** — to make transcripts verifiable by anyone, anytime, from anywhere.

### ✨ Core Features
- 🏫 **Admin (University)** can add and verify student transcripts.
- 👨‍🎓 **Students** can have multiple transcripts stored on-chain.
- 🔍 **Anyone** can view and verify transcript authenticity.
- 💾 **Transcript files** are stored off-chain (e.g., IPFS), while only **hashes or CIDs** are stored on-chain to save gas.

---

## 🧱 Smart Contract Details

### 📁 Contract: `TranscriptManager.sol`

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TranscriptManager {
    address public admin;

    struct Transcript {
        string studentName;
        string studentID;
        string courseName;
        string transcriptHash; // IPFS CID or SHA256 hash of transcript file
        uint256 timestamp;
        bool verified;
    }

    mapping(string => Transcript[]) private transcripts;

    event TranscriptAdded(string studentID, string courseName, string transcriptHash);
    event TranscriptVerified(string studentID, string courseName);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addTranscript(
        string memory _studentName,
        string memory _studentID,
        string memory _courseName,
        string memory _transcriptHash
    ) public onlyAdmin {
        Transcript memory newTranscript = Transcript({
            studentName: _studentName,
            studentID: _studentID,
            courseName: _courseName,
            transcriptHash: _transcriptHash,
            timestamp: block.timestamp,
            verified: false
        });

        transcripts[_studentID].push(newTranscript);
        emit TranscriptAdded(_studentID, _courseName, _transcriptHash);
    }

    function verifyTranscript(string memory _studentID, uint256 index) public onlyAdmin {
        require(index < transcripts[_studentID].length, "Invalid transcript index");
        transcripts[_studentID][index].verified = true;
        emit TranscriptVerified(_studentID, transcripts[_studentID][index].courseName);
    }

    function getTranscripts(string memory _studentID)
        public
        view
        returns (Transcript[] memory)
    {
        return transcripts[_studentID];
    }
}
