const dotenv = require('dotenv').config();
const path = require('path');
const fs = require('fs');
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const mnemonic = process.env.mnemonic;
const compiledEvents = require('./build/Events.json');

const provider = new HDWalletProvider(mnemonic, 'https://rinkeby.infura.io/v3/d440958558c64391bea17b5a4d810724');
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  const result = await new web3.eth.Contract(JSON.parse(compiledEvents.interface))
    .deploy({ data: `0x${compiledEvents.bytecode}`})
    .send( { from: accounts[0] })

    console.log('Contract deployed to: ', result.options.address);

};
deploy();
