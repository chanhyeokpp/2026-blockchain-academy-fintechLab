# 2026 Blockchain Academy — Seoul Fintech Lab

제2서울핀테크랩 **Blockchain Academy**에서 학습한 블록체인 이론과 Solidity·Web3 실습을 기록하는 저장소입니다.

> 교육 기간: 2026년 7월 20일 ~ 7월 22일
> 개인 학습 및 복습을 위한 비공식 저장소입니다.

## 현재까지 구현한 내용

- Solidity 데이터 저장 및 조회
- 컨트랙트의 가상 ETH 입금·출금
- 지갑 주소별 중복 투표 방지
- OpenZeppelin 기반 ERC-20 토큰 발행·전송
- Remix VM과 Sepolia 테스트넷 배포
- ethers.js를 이용한 MetaMask·Storage 컨트랙트 연결

## 프로젝트 구조

```text
.
├── contracts/
│   ├── AcademyToken.sol
│   ├── SimpleVault.sol
│   ├── Storage.sol
│   └── Voting.sol
├── frontend/
│   ├── src/
│   │   ├── main.js
│   │   └── style.css
│   ├── index.html
│   └── package.json
├── .gitignore
└── README.md
```

## 빠른 실행

### 1. Solidity 컨트랙트

1. [Remix IDE](https://remix.ethereum.org/)에 접속합니다.
2. `contracts` 폴더에 원하는 `.sol` 파일을 복사합니다.
3. Solidity Compiler `0.8.20` 이상으로 컴파일합니다.
4. 처음에는 `Remix VM`, 이후에는 `Browser Extension + Sepolia`에 배포합니다.

### 2. Web3 프런트엔드

```bash
cd frontend
npm install
npm run dev
```

브라우저에서 [http://localhost:5173](http://localhost:5173)을 열고 MetaMask를 연결합니다.

프런트엔드는 아래 Sepolia Storage 컨트랙트를 사용합니다.

```text
0x625c2ff915441eabac0fa568f8f6a8bb621a6407
```

네트워크 정보:

```text
Network: Ethereum Sepolia
Chain ID: 11155111
```

<details>
<summary><strong>개발 환경 및 준비물</strong></summary>

### 프로그램

- Chrome
- MetaMask 브라우저 확장
- Visual Studio Code
- Node.js 22 LTS 이상
- Git

### 웹사이트

- [Remix IDE](https://remix.ethereum.org/)
- [Sepolia Etherscan](https://sepolia.etherscan.io/)
- [OpenZeppelin Contracts Wizard](https://wizard.openzeppelin.com/)
- [Ethereum 테스트넷 안내](https://ethereum.org/developers/docs/networks/)

### 설치 확인

```bash
node --version
npm --version
git --version
```

### 프런트엔드 라이브러리

```bash
npm install ethers
```

- `ethers`: 브라우저에서 MetaMask 및 스마트 컨트랙트와 통신
- `Vite`: 프런트엔드 개발 서버 및 빌드 도구
- `OpenZeppelin Contracts`: ERC-20·ERC-721 표준 구현

</details>

<details>
<summary><strong>1. Storage — 블록체인 데이터 저장과 조회</strong></summary>

`Storage.sol`은 숫자 하나를 블록체인 상태에 저장하고 조회하는 가장 단순한 컨트랙트입니다.

```text
setValue(123) → 상태 변경 트랜잭션
getValue()    → 저장된 값 조회
```

학습 내용:

- Solidity 컨트랙트 작성과 컴파일
- 컨트랙트 배포
- 상태 변경 함수와 `view` 함수의 차이
- `msg.sender`와 이벤트
- Remix VM과 Sepolia의 상태가 서로 분리된다는 점

Sepolia에서는 `setValue`가 테스트 ETH를 가스비로 사용하지만 `getValue` 조회는 지갑 승인이 필요하지 않습니다.

</details>

<details>
<summary><strong>2. SimpleVault — 가상 ETH 입금과 출금</strong></summary>

`SimpleVault.sol`은 컨트랙트가 ETH를 받고 소유자가 출금하는 과정을 실습합니다.

```text
deposit()       → payable 함수로 ETH 입금
getBalance()    → 컨트랙트 잔액 조회
withdraw(amount) → 배포자만 출금
```

Remix VM 실습 예시:

```text
Value: 1 ether
deposit()
getBalance() → 1000000000000000000 wei
withdraw(1000000000000000000)
getBalance() → 0
```

학습 내용:

- `payable`
- `msg.value`
- `address(this).balance`
- `require`
- `owner` 권한 검사
- ETH와 wei의 관계

</details>

<details>
<summary><strong>3. Voting — 주소별 투표와 중복 방지</strong></summary>

`Voting.sol`은 후보 목록을 생성하고 지갑 주소별로 한 번만 투표하게 합니다.

배포 시 생성자 예시:

```text
["Alice", "Bob", "Charlie"]
```

후보 ID는 `0`부터 시작합니다.

```text
0 → Alice
1 → Bob
2 → Charlie
```

학습 내용:

- `struct`와 배열
- `mapping(address => bool)`
- 생성자
- 이벤트
- `require`를 이용한 중복 투표 방지
- 지갑 주소가 서로 다른 사용자 역할을 한다는 점

</details>

<details>
<summary><strong>4. AcademyToken — ERC-20 발행과 전송</strong></summary>

`AcademyToken.sol`은 OpenZeppelin의 `ERC20` 구현을 상속해 토큰을 생성합니다.

```text
Name: AcademyToken
Symbol: ACT
Initial supply: 1,000,000 ACT
Decimals: 18
```

확인할 함수:

- `name()`
- `symbol()`
- `decimals()`
- `totalSupply()`
- `balanceOf(address)`
- `transfer(address, amount)`
- `approve(address, amount)`
- `transferFrom(address, address, amount)`

100 ACT의 최소 단위:

```text
100 × 10^18 = 100000000000000000000
```

`transfer`의 `value`는 ACT 수량이고, Remix 하단의 `Value`는 함께 보낼 ETH이므로 서로 다릅니다. ERC-20 전송 시 ETH `Value`는 `0 wei`로 둡니다.

</details>

<details>
<summary><strong>5. MetaMask와 Sepolia 테스트넷</strong></summary>

진행 순서:

1. MetaMask에서 테스트 네트워크를 표시합니다.
2. `Sepolia`를 선택합니다.
3. Ethereum 공식 문서에 연결된 faucet에서 무료 테스트 ETH를 받습니다.
4. Remix 환경에서 `Browser Extension`을 선택합니다.
5. MetaMask 계정과 Sepolia 네트워크를 확인합니다.
6. `Storage.sol`을 배포합니다.
7. 배포 주소를 Sepolia Etherscan에서 검색합니다.

확인할 값:

```text
Network: Sepolia
Chain ID: 11155111
```

테스트넷 ETH에는 실제 금전적 가치가 없습니다. 복구 문구·개인키·비밀번호를 faucet이나 웹사이트에 입력하지 않습니다.

</details>

<details>
<summary><strong>6. Web3 프런트엔드와 ethers.js</strong></summary>

프런트엔드의 호출 흐름:

```text
웹페이지
→ ethers.js
→ MetaMask 서명
→ Sepolia
→ Storage 컨트랙트
```

주요 객체:

- `window.ethereum`: MetaMask가 브라우저에 제공하는 객체
- `BrowserProvider`: 블록체인 네트워크와 통신
- `Signer`: 사용자 계정으로 트랜잭션 서명
- `Contract`: 컨트랙트 주소와 ABI를 이용한 함수 호출

컨트랙트 연결에 필요한 정보:

```text
1. 배포된 컨트랙트 주소
2. 컨트랙트 ABI
```

지원 기능:

- MetaMask 계정 연결
- Sepolia Chain ID 검증
- `getValue()` 조회
- `setValue(uint256)` 트랜잭션 실행
- 거래 처리 상태 표시

</details>

<details>
<summary><strong>7. 핵심 개념 요약</strong></summary>

### 스마트 컨트랙트

블록체인 네트워크에서 실행되는 프로그램입니다.

### 컴파일

사람이 읽는 Solidity 코드를 EVM이 실행할 바이트코드와 외부 호출 설명서인 ABI로 변환합니다.

### 배포

컴파일된 컨트랙트를 블록체인에 등록해 고유한 컨트랙트 주소를 생성합니다. 같은 코드를 여러 번 배포하면 주소와 상태가 서로 다른 인스턴스가 만들어집니다.

### 트랜잭션과 조회

```text
상태 변경 → 트랜잭션, 가스 필요
상태 조회 → call, 일반적으로 사용자 가스 불필요
```

### 지갑 주소와 컨트랙트 주소

- 지갑 주소: 개인키로 제어하는 사용자 계정
- 컨트랙트 주소: 배포된 프로그램이 존재하는 위치

### Remix VM과 Sepolia

- Remix VM: 브라우저 내부의 학습용 가상 블록체인
- Sepolia: 공개 이더리움 테스트넷
- Ethereum Mainnet: 실제 자산이 사용되는 운영 네트워크

</details>

<details>
<summary><strong>8. STO·RWA·CBDC</strong></summary>

### STO

`Security Token Offering`의 약자로, 증권 성격의 권리를 블록체인 토큰으로 발행하는 방식입니다.

### RWA

`Real World Assets`의 약자로, 부동산·채권·금 등 현실 자산이나 그 권리를 블록체인 토큰과 연결하는 개념입니다.

### CBDC

`Central Bank Digital Currency`의 약자로, 중앙은행이 발행하는 디지털 형태의 법정통화입니다.

</details>

## 보안 수칙

- 실제 자산이 없는 학습 전용 MetaMask 지갑을 사용합니다.
- 복구 문구, 개인키, 비밀번호를 저장소에 기록하지 않습니다.
- `.env`와 `node_modules`를 커밋하지 않습니다.
- 거래 승인 전에 네트워크와 예상 가스비를 확인합니다.
- 이번 실습에서는 Ethereum Mainnet을 사용하지 않습니다.

## 다음 학습

- ERC-20 `approve`와 `transferFrom`
- ERC-721 NFT 발행과 전송
- OpenZeppelin `Ownable`과 접근 제어
- NFT 메타데이터와 IPFS
- 컨트랙트 테스트 및 보안

## Disclaimer

이 저장소의 코드는 교육 목적으로 작성되었으며 보안 감사를 거치지 않았습니다. 실제 자산을 관리하는 메인넷 또는 상용 환경에 그대로 사용하지 마세요.
