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
const contractAddress = '0x2FD0681f82B19CC0f8C3f37FB375ECC8B673336F';
const user = '0xC94cEa157B964e9b733145F4F385dBAF1fe2f5a9';

const configs = {
    from: user, // default from address
    // gas: gasLimit,
    // gasPrice: '20000000000' // default gas price in wei, 20 gwei in this case
};

const web3 = new Web3(address);
let contract = new web3.eth.Contract(JSON.parse(ABI), contractAddress);

// contract.getRealEstate.call(
//     1, 
//     // transactionObject, 
//     (error, result) => { 
//         console.log(result);
//         // do something with error checking/result here });
//     });

const getRealEstate = async (id) => {
    const result = await contract.methods.getRealEstate(id).call()
    console.log(result);

    return result;
};

const acceptPresent = async (id) => {
    const result = await contract.methods.acceptPresent(id).call()
    console.log(result);

    return result;
}

const buyRealEstate = async (id, price) => {
    const result = await contract.methods.buyRealEstate(id).call()
    console.log(result);

    return result;
}

const changeOwner = async (id, newOwner) => {
    const result = await contract.methods.changeOwner(id, newOwner).send(configs)
    console.log(result);

    return result;
}

const changeRestrictions = async (id) => {
    try {
        const result = await contract.methods.changeRestrictions(id).send(configs)
        console.log(result);
    
        return result;
    } catch (err) {
        throw err;
    }
}

const changeSquare = async (id, newSquare) => {
    const result = await contract.methods.changeSquare(id, newSquare).send(configs)
    console.log(result);

    return result;
}

const checkPresent = async (id) => {
    const result = await contract.methods.checkPresent(id).call()
    console.log(result);

    return result;
}

const checkSellAd = async (id) => {
    const result = await contract.methods.checkSellAd(id).call()
    console.log(result);

    return result;
}

const presentRealEstate = async (id, recepient) => {
    const result = await contract.methods.presentRealEstate(id, recepient).send(configs)
    console.log(result);

    return result;
}

const registerRealEstate = async (owner, location, square, restrictions, id) => {
    const result = await contract.methods.registerRealEstate(
            owner, 
            location, 
            square, 
            restrictions, 
        id).send(configs)
    console.log(result);

    return result;
}

const sellRealEstate = async (id, price) => {
    const result = await contract.methods.sellRealEstate(id, price).send(configs)
    console.log(result);

    return result;
}



try {
    // acceptPresent();
    // buyRealEstate()
    // changeOwner()
    // changeRestrictions(1);
    // changeSquare()
    // checkPresent()
    // checkSellAd()
    // getBalance()
    getRealEstate(1);
    // presentRealEstate()
    // registerRealEstate()
    // sellRealEstate()
    console.log(err);
} catch (err) {
    console.error(err);
}

