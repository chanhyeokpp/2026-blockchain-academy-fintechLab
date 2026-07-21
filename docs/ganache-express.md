# Ganache + Express + Web3.js 실습

강의 템플릿을 이용해 브라우저, Express, Web3.js, Ganache, Solidity 컨트랙트를 연결한 실습 기록입니다.

## 구성

```text
브라우저
→ Express 서버 (localhost:3001)
→ Web3.js
→ Ganache RPC (127.0.0.1:7545)
→ Solidity 컨트랙트
```

## 실행

### 1. Ganache

```bash
npx ganache@7.9.2 \
  --server.port 7545 \
  --chain.chainId 1337 \
  --chain.hardfork shanghai \
  --database.dbPath "/Users/biohealth_team2/Documents/BlockChain_Academy/.ganache-db"
```

정상 실행 메시지:

```text
RPC Listening on 127.0.0.1:7545
```

### 2. Remix

```text
Environment: Custom - External HTTP Provider
Endpoint: http://127.0.0.1:7545
Solidity compiler: 0.8.34
EVM version: paris
```

Ganache 7과 최신 Solidity 컴파일러를 함께 사용할 때 `invalid opcode`가 발생하면 EVM target을 `paris`로 지정하고 다시 컴파일합니다.

### 3. Express

강의 템플릿 저장소에서 실행합니다.

```bash
cd "/Users/biohealth_team2/Documents/BlockChain_Academy/ethereum-template/tutorials"
PORT=3001 npm start
```

```text
Home: http://localhost:3001
Hello World: http://localhost:3001/hello-world
My Token: http://localhost:3001/my-token
Voting: http://localhost:3001/voting
```

## 컨트랙트 연결

Ganache를 새로 초기화하면 컨트랙트를 다시 배포하고 강의 템플릿의 주소를 교체해야 합니다.

```javascript
const address = "0xYOUR_DEPLOYED_CONTRACT_ADDRESS";
```

대상 파일:

```text
tutorials/contract/helloWorld.js
tutorials/contract/myToken.js
tutorials/contract/voting.js
```

로컬 Ganache 주소는 비밀정보는 아니지만 실행할 때마다 달라질 수 있으므로 이 저장소에는 실제 주소를 저장하지 않습니다.

## 실습 내용

### HelloWorld

- 생성자에서 초기 문자열 저장
- 웹 화면에서 `update()` 트랜잭션 실행
- 새 블록과 변경된 메시지 확인

### MyToken

- 배포자에게 초기 수량 지급
- 주소별 잔액 조회
- 토큰 추가 발행
- 계정 간 토큰 전송

`MyToken`은 학습용 단순 토큰이며 ERC-20 전체 표준 구현이 아닙니다.

### TutorialVoting

- `bytes32` 후보 목록 생성
- 후보 추가
- 후보별 득표수 조회
- 투표 트랜잭션 실행

이 예제는 중복 투표를 막지 않는 학습용 구현입니다. 주소별 중복 투표 방지는 `contracts/Voting.sol`에서 별도로 확인합니다.

## 보안 주의사항

- Ganache가 출력한 개인키와 mnemonic을 저장소에 커밋하지 않습니다.
- Ganache 계정은 로컬 개발 전용으로만 사용합니다.
- MetaMask의 실제 자산 계정과 Ganache 테스트 계정을 분리합니다.
- `.ganache-db`, `node_modules`, `.env`는 Git에서 제외합니다.
- 이 코드들은 보안 감사를 거치지 않았으므로 메인넷에서 사용하지 않습니다.
