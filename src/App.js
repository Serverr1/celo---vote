import { useState, useEffect, useCallback } from "react";

import Header from './components/Header';
import Addarguments from './components/Addarguments';


import Web3 from "web3";
import { newKitFromWeb3 } from "@celo/contractkit";
import BigNumber from "bignumber.js";


import celovote from "./contracts/celovote.abi.json";
import IERC from "./contracts/IERC.abi.json";
import { Arguments } from "./components/Arguments";



const ERC20_DECIMALS = 18;


const contractAddress = "0x36Cb6c9d9C5C74f717DC23FB52f3A4409a10c2D6";
const cUSDContractAddress = "0x874069Fa1Eb16D44d622F2e0Ca25eeA172369bC1";
const voteAmmount = "1"


function App() {

  const [showAddArgument, setShowAddArgument] = useState(false)
  const [contract, setcontract] = useState(null);
  const [address, setAddress] = useState(null);
  const [kit, setKit] = useState(null);
  const [cUSDBalance, setcUSDBalance] = useState(0);
  const [argumentss, setArguments] = useState([]);


  const connectToWallet = async () => {
    if (window.celo) {
      try {
        await window.celo.enable();
        const web3 = new Web3(window.celo);
        let kit = newKitFromWeb3(web3);

        const accounts = await kit.web3.eth.getAccounts();
        const user_address = accounts[0];

        kit.defaultAccount = user_address;

        await setAddress(user_address);
        await setKit(kit);
      } catch (error) {
        console.log(error);
      }
    } else {
      console.log("Error Occurred");
    }
  };

  const getBalance = useCallback(async () => {
    try {
      const balance = await kit.getTotalBalance(address);
      const USDBalance = balance.cUSD.shiftedBy(-ERC20_DECIMALS).toFixed(2);

      const contract = new kit.web3.eth.Contract(celovote, contractAddress);
      setcontract(contract);
      setcUSDBalance(USDBalance);
    } catch (error) {
      console.log(error);
    }
  }, [address, kit]);


  


  const getArguments = useCallback(async () => {
    const argumentsLength = await contract.methods.getargumentsLength().call();
    const argumentss = [];

    for (let index = 0; index < argumentsLength; index++) {
      let _arguments = new Promise(async (resolve, reject) => {
      let argument = await contract.methods.readArguments(index).call();

        resolve({
          index: index,
          owner: argument[0],
          topic: argument[1],
          arg1: argument[2],
          arg2: argument[3],
          arg1Votes: argument[4],
          arg2Votes: argument[5]     
        });
      });
      argumentss.push(_arguments);
    }

    const _arguments = await Promise.all(argumentss);
    setArguments(_arguments);
  }, [contract]);


  const addArgument = async (
    _topic,
    _arg1,
    _arg2
  ) => {
    try {
      await contract.methods
        .addArgument(_topic, _arg1, _arg2)
        .send({ from: address });
      getArguments();
    } catch (error) {
      console.log(error);
    }
  };


  

  const voteforArg = async (_index, _isArg1) => {
    try {
      const cUSDContract = new kit.web3.eth.Contract(IERC, cUSDContractAddress);
      const cost = new BigNumber(voteAmmount)
        .shiftedBy(ERC20_DECIMALS)
        .toString();
      await cUSDContract.methods
        .approve(contractAddress, cost)
        .send({ from: address });
      await contract.methods.voteArg(_index, cost, _isArg1).send({ from: address });
      getArguments();
      getBalance();
    } catch (error) {
      console.log(error);
    }};


  useEffect(() => {
    connectToWallet();
  }, []);

  useEffect(() => {
    if (kit && address) {
      getBalance();
    }
  }, [kit, address, getBalance]);

  useEffect(() => {
    if (contract) {
      getArguments();
    }
  }, [contract, getArguments]);
  
  return (
    <div>
    <Header cUSDBalance={cUSDBalance} onAdd={() =>setShowAddArgument(!showAddArgument)} />
  {showAddArgument && <Addarguments addArgument={addArgument} />}
  <Arguments argumentss={argumentss} voteforArg ={voteforArg} />
  
    </div>
  );
}


export default App;
