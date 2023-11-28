### create .env file
``` shell
SEPOLIA_RPC_URL=https://sepolia.infura.io/v3/xxx
PRIVATE_KEY=wallet private key
ETHERSCAN_API_KEY=
```

### compile
`make build`

### test
`make test`

### deploy
- local deploy ,must start anvil
`make deploy`
- deploy in sepolia test chain
`make deploy ARGS="--network sepolia"`