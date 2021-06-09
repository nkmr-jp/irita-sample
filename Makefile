# See: https://gist.github.com/rsperl/d2dfe88a520968fbc1f49db0a29345b9
# define standard colors
BLACK        := $(shell tput -Txterm setaf 0)
RED          := $(shell tput -Txterm setaf 1)
GREEN        := $(shell tput -Txterm setaf 2)
YELLOW       := $(shell tput -Txterm setaf 3)
LIGHTPURPLE  := $(shell tput -Txterm setaf 4)
PURPLE       := $(shell tput -Txterm setaf 5)
BLUE         := $(shell tput -Txterm setaf 6)
WHITE        := $(shell tput -Txterm setaf 7)

RESET := $(shell tput -Txterm sgr0)


init:
	# See: http://localhost:8080/installation/deployment.html
	@echo "$(GREEN)# INIT: 1. genesis.json ファイルを初期化する $(RESET)"
	irita init node0 --chain-id=irita-test --home=testnet
	@echo
	@echo "$(GREEN)# INIT: 2. 初期アカウントの作成 v1 $(RESET)"
	irita keys add v1
	@echo
	@echo "$(GREEN)# INIT: 3. Genesis.json ファイルに v1 を追加し、アカウントに「RootAdmin」権限を追加します。 $(RESET)"
	irita add-genesis-account $(shell irita keys show v1 -a) 1000000000point --home=testnet --root-admin
	@echo
	@echo "$(GREEN)# INIT: 4.  Validatorノード node0 (手順 1 で生成) の秘密鍵を、ノード証明書の申請に便利な pem 形式にエクスポートします。 $(RESET)"
	irita genkey --home=testnet --out-file priv_validator.pem
	@echo
	@echo "$(GREEN)# INIT: 5.  ノード証明書の生成。See: http://localhost:8080/node_identity_management/cert.html $(RESET)"
	openssl req -new -key priv_validator.pem -out req.csr -sm3 -sigopt "distid:1234567812345678"
	@echo
	@echo "$(GREEN)# INIT: 6.  IRITA ネットワークのエンタープライズ ルート証明書をインポートします。 $(RESET)"
	irita set-root-cert ca.crt --home=testnet
	@echo
	@echo "$(GREEN)# INIT: 7.  genesis.json ファイルに node0 を追加します。 $(RESET)"
	irita add-genesis-validator --name node0 --cert node0.crt --power 100 --home=testnet --from node0

start:
	irita start --home=testnet --pruning=nothing

reset:
	rm -rf ./testnet
	rm -f ./priv_validator.pem
	rm -f ./privkey.pem
	rm -f ./req.csr


# See: http://localhost:8080/node_identity_management/cert.html
cert:
	openssl req -new -key priv_validator.pem -out req.csr -sm3 -sigopt "distid:1234567812345678"
