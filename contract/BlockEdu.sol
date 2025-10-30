// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BlockEdu {

    // Owner (e.g., school authority)
    address public owner;

    // Transcript record structure
    struct Transcript {
        string studentName;
        string courseName;
        string grade;
        uint256 issuedOn;
    }

    // Stored transcript
    Transcript public transcript;

    // Restrict actions to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    // Set contract deployer as owner
    constructor() {
        owner = msg.sender;
    }

    // Function to store transcript on-chain
    function storeTranscript(
        string memory _studentName,
        string memory _courseName,
        string memory _grade
    ) public onlyOwner {
        transcript = Transcript(
            _studentName,
            _courseName,
            _grade,
            block.timestamp
        );
    }

    // Function to verify transcript details publicly
    function verifyTranscript() public view returns (
        string memory,
        string memory,
        string memory,
        uint256
    ) {
        return (
            transcript.studentName,
            transcript.courseName,
            transcript.grade,
            transcript.issuedOn
        );
    }
}
