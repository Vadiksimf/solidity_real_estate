const fs = require('fs');

// npm install solc npm install -g solc
// Compile contract solcjs --abi contract.sol. 
// This will create a contract_sol_contract.abi file in the same folder
const ABI = fs.readFileSync('contractAbi/contractAbi_contract_sol_Agency.abi');

// Alternative is Ethers.js
const Web3 = require("web3");
// const web3 = new Web3("https://cloudflare-eth.com");
const address = 'http://localhost:7545';

// Set Contract Address
const contractAddress = '0xCc4054501934E1B600FD6DbEbEf5fD4F101598eE';
const user = '0xCC222fed8D8cfbe01421c5c2CA4a590De1028cdA';

const configs = {
    from: user, // default from address
    // gas: gasLimit,
    // gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
};

const web3 = new Web3(address);
let contract = new web3.eth.Contract(JSON.parse(ABI), contractAddress);

// const [ argv1, argv2, argv3, argv4, argv5 ] = process.argv.slice(2, 5)

const agencyMethods = {
    getRealEstate: async (id) => {
        const result = await contract.methods.getRealEstate(id).call()
        console.log(result);
    
        return result;
    },
    acceptPresent: async (id) => {
        const result = await contract.methods.acceptPresent(id).send(configs)
        console.log(result);
    
        return result;
    },
    buyRealEstate: async (id, price) => {
        const result = await contract.methods.buyRealEstate(id).call()
        console.log(result);
    
        return result;
    },
    changeOwner: async (id, newOwner) => {
        const result = await contract.methods.changeOwner(id, newOwner).send(configs)
        console.log(result);
    
        return result;
    },
    changeRestrictions: async (id) => {
        try {
            const result = await contract.methods.changeRestrictions(id).send(configs)
            console.log(result);
        
            return result;
        } catch (err) {
            throw err;
        }
    },
    changeSquare: async (id, newSquare) => {
        const result = await contract.methods.changeSquare(id, newSquare).send(configs)
        console.log(result);
    
        return result;
    },
    checkPresent: async (id) => {
        const result = await contract.methods.checkPresent(id).call()
        console.log(result);
    
        return result;
    },
    checkSellAd: async (id) => {
        const result = await contract.methods.checkSellAd(id).call()
        console.log(result);
    
        return result;
    },
    presentRealEstate: async (id, recepient) => {
        const result = await contract.methods.presentRealEstate(id, recepient).send(configs)
        console.log(result);
    
        return result;
    },
    registerRealEstate: async (owner, location, square, restrictions, id) => {
        const result = await contract.methods.registerRealEstate(
                owner, 
                location, 
                square, 
                restrictions, 
            id).send(configs)
        console.log(result);
    
        return result;
    },
    sellRealEstate: async (id, price) => {
        const result = await contract.methods.sellRealEstate(id, price).send(configs)
        console.log(result);
    
        return result;
    }
};

module.exports.agencyMethods = agencyMethods;
