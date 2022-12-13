// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

contract ElectionFact {
    
    struct ElectionDet {
        address deployedAddress;
        string el_n;
        string el_d;
    }
    
    mapping(string=>ElectionDet) companyEmail;
    
    function createElection(string memory email,string memory election_name, string memory election_description) public{
        Election newElection = new Election(msg.sender , election_name, election_description);
        
        companyEmail[email].deployedAddress = address(newElection);
        companyEmail[email].el_n = election_name;
        companyEmail[email].el_d = election_description;
    }
    
    function getDeployedElection(string memory email) public view returns (ElectionDet memory) {
        address val =  companyEmail[email].deployedAddress;
        require(!(val ==address(0)));
            return (companyEmail[email]);
    }
}
contract Election{
    address election_authority;
    string election_name;
    string election_description;
    bool status;

    constructor(address _ele_auth,string memory _ele_name,string memory elec_desc){
        election_authority = _ele_auth;
        election_name = _ele_name;
        election_description = elec_desc;
        status = true;
    }
    struct Canditate{
        string name;
        string description;
        string imgHash;
        uint voteCount;
        string email;
    }
    modifier  owner {
        require(msg.sender == election_authority,"Only Election Authority");
        _;
    }

    mapping(uint=>Canditate) public candidates;
    struct Voter{
        uint canditate_id_voted;
        bool voted;
    }
    mapping(string =>Voter) public voters;
    uint numberCandidates;
    uint numberVoters;

    function addCandidate(string memory candidate_name,string memory candiate_desc,string memory imgHas,string memory candiate_email)public owner{
        uint candiadateId = numberCandidates++;
        candidates[candiadateId] = Canditate(candidate_name,candiate_desc,imgHas,0,candiate_email);

    }
    function vote(uint candidate_id,string memory e)public{
        require(!voters[e].voted,"No duplication vote");
        voters[e] = Voter(candidate_id,true);
        numberVoters++;
        candidates[candidate_id].voteCount++;
    }
    function getCandidates()public view returns(uint){
        return numberCandidates;
    }
    function getVoters()public view returns(uint){
        return numberVoters;
    }
    function getCandidate(uint id)public view returns(string memory ,string memory,string memory,uint ,string memory){
        return (candidates[id].name,candidates[id].description,candidates[id].imgHash,candidates[id].voteCount,candidates[id].email);
    }
    function getWinner()public view returns(uint){
        uint largestVotes = candidates[0].voteCount;
        uint candidateid;
        for(uint i=1;i<numberCandidates;i++){
            if(largestVotes<candidates[i].voteCount){
                largestVotes = candidates[i].voteCount;
                candidateid= i;

            }
        }
        return candidateid;

    }
    function getElectionDetails()public view returns(string memory,string memory){
        return (election_name,election_description);
    }
}
