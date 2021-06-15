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

reset:
	@echo
	@echo "$(GREEN)# RESET: remove files $(RESET)"
	rm -rf ./testnet*
	rm -f ./priv_validator.pem
	rm -f ./privkey.pem
	rm -f ./req.csr
	rm -f ./root.crt
	rm -f ./root.key
	rm -f ./node0.crt
	rm -f ./root.srl


CHAIN_ID=irita-test
OUT_DIR=testnet

init:
	@echo
	@echo "$(GREEN)# INIT: irita testnet $(RESET)"
	irita testnet --v 1 --output-dir ./$(OUT_DIR) --chain-id=$(CHAIN_ID)

start:
	@echo
	@echo "$(GREEN)# START: irita start $(RESET)"
	irita start --home=$(OUT_DIR)/node0/irita

restart: reset init start

# http://localhost:8080/quick_start/token.html
# http://localhost:8080/console/modules/token.html
SYMBOL=mycredit
token-issue:
	irita tx token issue \
	--symbol=$(SYMBOL) \
	--name="my credit" \
	--initial-supply=10000 \
	--max-supply=100000 \
	--scale=0  \
	--min-unit=$(SYMBOL) \
	--mintable=true \
	--from=node0 \
	--chain-id=$(CHAIN_ID) \
	-b=block \
	--home=$(OUT_DIR)/node0/iritacli \
	-y

token-edit:
	irita tx token edit $(SYMBOL) \
	--max-supply=200000 \
	--mintable=true \
	--from=node0 \
	--chain-id=$(CHAIN_ID) \
	-b=block \
	--home=$(OUT_DIR)/node0/iritacli \
	-y

token-mint:
	irita tx token mint $(SYMBOL) \
	--to=iaa1lq8ye9aksqtyg2mn46esz9825zuxt5zatm5uxm \
	--amount=1000 \
	--from=node0 \
	--chain-id=$(CHAIN_ID) \
	-b=block \
	--home=testnet/node0/iritacli \
	-y

token-transfer:
	irita tx token transfer $(SYMBOL) \
	--to=iaa1lq8ye9aksqtyg2mn46esz9825zuxt5zatm5uxm \
	--from=node0 \
	--chain-id=$(CHAIN_ID) \
	-b=block \
	--home=$(OUT_DIR)/node0/iritacli \
	-y

query-token:
	irita query token token $(SYMBOL) -o=json --chain-id=$(CHAIN_ID) | jq
