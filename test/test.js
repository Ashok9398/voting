const {ethers} =require("hardhat");
const {expect ,assert} = require('chai');
const { isCallTrace } = require("hardhat/internal/hardhat-network/stack-traces/message-trace");

let accounts;
let electionfact;
let election;
describe('Voting Contract', () => { 
    beforeEach("Deploys a contract",async()=>{
        accounts = await ethers.getSigners();
        const electionFact = await ethers.getContractFactory("ElectionFact");        
        electionfact = await electionFact.deploy();
        await electionfact.createElection('ap@gmail.com','Ap Voting',"Andhra pradesh Voting");
        const electiondetails = await electionfact.getDeployedElection('ap@gmail.com');
        election = await ethers.getContractAt('Election',electiondetails.deployedAddress);

    })
    it ("Retrieves election Details",async()=>{
        [election_name,election_desc] = await election.getElectionDetails();
        expect(election_name).to.equal('Ap Voting');
        expect(election_desc).to.equal('Andhra pradesh Voting');
        
    })
    describe("it test for addCandidate Function ",()=>{
        beforeEach("it adds data",async()=>{
            await election.addCandidate('Qwe',"Qwerty",'we','qw@gmail.com');
        })
        it("it checks for candidates mapping",async()=>{
            const candidate= await election.candidates(0);
            expect(candidate.name).to.equal('Qwe');
        })
        it("it checks for candidateslength",async()=>{
            expect(await election.getCandidates()).to.equal(1);
        })
        it("checks for vote function",async()=>{
            await election.vote(0,'Ashok');
            expect(await election.getVoters()).to.equal(1);
            const candidate = await election.candidates(0);
            expect(candidate.voteCount).to.equal(1);
        })
        it("Checks for get Winner fucntion",async()=>{
            await election.addCandidate('As',"Ash",'as','as@gmail.com');
            await election.addCandidate('zx',"zxcvy",'ZX','zx@gmail.com');
            await election.vote(0,'Reddy');
            await election.vote(1,'Raja');
            await election.vote(0,'Ram');
            const candidate = await election.candidates(0);
            expect(candidate.voteCount).to.equal(2);

            expect(await election.getWinner()).to.equal(0);

        })

})
 })