import "./style.css";
import {
  BrowserProvider,
  Contract
} from "ethers";

const contractAddress =
  "0x625c2ff915441eabac0fa568f8f6a8bb621a6407";

const abi = [
  "function setValue(uint256 newValue)",
  "function getValue() view returns (uint256)"
];

const SEPOLIA_CHAIN_ID = 11155111n;

const connectButton = document.querySelector("#connectButton");
const readButton = document.querySelector("#readButton");
const saveButton = document.querySelector("#saveButton");
const walletAddress = document.querySelector("#walletAddress");
const networkElement = document.querySelector("#network");
const storedValue = document.querySelector("#storedValue");
const valueInput = document.querySelector("#valueInput");
const statusElement = document.querySelector("#status");

let provider;
let signer;
let contract;

function setStatus(message) {
  statusElement.textContent = message;
}

async function connectWallet() {
  try {
    if (!window.ethereum) {
      throw new Error("MetaMask를 먼저 설치해 주세요.");
    }

    provider = new BrowserProvider(window.ethereum);

    await provider.send("eth_requestAccounts", []);

    signer = await provider.getSigner();

    const address = await signer.getAddress();
    const network = await provider.getNetwork();

    if (network.chainId !== SEPOLIA_CHAIN_ID) {
      throw new Error(
        `MetaMask를 Sepolia로 변경해 주세요. 현재 Chain ID: ${network.chainId}`
      );
    }

    contract = new Contract(
      contractAddress,
      abi,
      signer
    );

    walletAddress.textContent = address;
    networkElement.textContent = `Sepolia (${network.chainId})`;
    setStatus("MetaMask 연결 완료");
  } catch (error) {
    console.error(error);
    setStatus(error.message);
  }
}

async function readValue() {
  try {
    if (!contract) {
      throw new Error("MetaMask를 먼저 연결해 주세요.");
    }

    setStatus("값을 조회하고 있습니다.");

    const value = await contract.getValue();

    const result = value.toString();

    storedValue.textContent = result;
    setStatus(`조회 완료: 현재 값은 ${result}입니다.`);
  } catch (error) {
    console.error(error);
    setStatus(error.shortMessage ?? error.message);
  }
}

async function saveValue() {
  try {
    if (!contract) {
      throw new Error("MetaMask를 먼저 연결해 주세요.");
    }

    const newValue = valueInput.value;

    if (newValue === "" || Number(newValue) < 0) {
      throw new Error("0 이상의 숫자를 입력해 주세요.");
    }

    setStatus("MetaMask에서 거래를 승인해 주세요.");

    const transaction = await contract.setValue(newValue);

    setStatus(`거래 처리 중: ${transaction.hash}`);

    await transaction.wait();

    setStatus("저장 완료");
    await readValue();
  } catch (error) {
    console.error(error);
    setStatus(error.shortMessage ?? error.message);
  }
}

connectButton.addEventListener("click", connectWallet);
readButton.addEventListener("click", readValue);
saveButton.addEventListener("click", saveValue);
