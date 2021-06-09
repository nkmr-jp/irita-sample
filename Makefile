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

# See: http://localhost:8080/installation/deployment.html
init-detail:
	@echo "$(GREEN)# INIT: 1. genesis.json ファイルを初期化する $(RESET)"
	irita init node0 --chain-id=irita-test --home=testnet
	@echo
	@echo "$(GREEN)# INIT: 2. 初期アカウントの作成 v1 $(RESET)"
	irita keys add v1
	@echo
	@echo "$(GREEN)# INIT: 3. genesis.json ファイルに v1 を追加し、アカウントに「RootAdmin」権限を追加します。 $(RESET)"
	irita add-genesis-account $(shell irita keys show v1 -a) 1000000000point --home=testnet --root-admin
	@echo
	@echo "$(GREEN)# INIT: 4.  Validatorノード node0 (手順 1 で生成) の秘密鍵を、ノード証明書の申請に便利な pem 形式にエクスポートします。 $(RESET)"
	irita genkey --home=testnet --out-file priv_validator.pem
	@echo
	@echo "$(GREEN)# INIT: 5.  ノード証明書の生成。See: http://localhost:8080/node_identity_management/cert.html $(RESET)"
	@echo "$(BLUE)# 証明書リクエスト生成（ノード）$(RESET)"
	openssl req -new -key priv_validator.pem -out req.csr -sm3 -sigopt "distid:1234567812345678"
	@echo
	@echo "$(BLUE)# ルート証明書生成（CA組織）$(RESET)"
	## ルート証明書の秘密鍵を生成する
	openssl ecparam -genkey -name SM2 -out root.key
	## ルート証明書の生成
	openssl req -new -x509 -sm3 -sigopt "distid:1234567812345678" -key root.key -out root.crt -days 365
	@echo
	@echo "$(GREEN)# INIT: 6.  IRITA ネットワークのエンタープライズ ルート証明書をインポートします。 $(RESET)"
	irita set-root-cert root.crt --home=testnet
	@echo
	@echo "$(GREEN)# INIT: 7.  genesis.json ファイルに node0 を追加します。 $(RESET)"
	@echo
	@echo "$(BLUE)# node0の証明書の生成$(RESET)"
	openssl x509 -req -in req.csr -out node0.crt -sm3 -sigopt "distid:1234567812345678" -vfyopt "distid:1234567812345678" -CA root.crt -CAkey root.key -CAcreateserial
	@echo
	@echo "$(BLUE)# node0の追加$(RESET)"
	irita add-genesis-validator --name node0 --cert node0.crt --power 100 --home=testnet --from node0

start-detail:
	irita start --home=testnet --pruning=nothing

init:
	irita testnet --v 1 --output-dir ./testnet2 --chain-id=test

start:
	irita start --home=testnet2/node0/irita

reset:
	rm -rf ./testnet*
	rm -f ./priv_validator.pem
	rm -f ./privkey.pem
	rm -f ./req.csr
	rm -f ./root.crt
	rm -f ./root.key
	rm -f ./node0.crt
	rm -f ./-CAcreateserial
	rm -f ./-CAkey
	rm -f ./-out
	rm -f ./root.srl

