# irita-sample
See: https://github.com/bianjieai/irita/tree/master/docs

# 準備
## Irita インストール
```sh
# 他のバージョンは未検証
go version
# > go version go1.15.5 darwin/amd6
```
```sh
git clone https://github.com/bianjieai/irita.git
cd irita 
git checkout v2.0.0
make install
```

```sh
irita version --long
# >    name: irita
# >    server_name: irita
# >    version: 2.0.0
# >    commit: 5ce9b33ec68c65a5fbcf193ced2c318323218218
# >    build_tags: netgo,ledger
# >    go: go version go1.15.5 darwin/amd64
# >    build_deps:
# >    - github.com/99designs/keyring@v1.1.6
# >    - github.com/ChainSafe/go-schnorrkel@v0.0.0-20200405005733-88cbf1b4c40d
# >    - github.com/CosmWasm/wasmd@v0.15.1
...
```

## ドキュメント起動
```sh
# 他のバージョンは未検証
node --version
# > v15.11.0
yarn --version
# > 1.22.10
```

```sh
cd irita/docs
yarn
yarn serve
# > success [15:46:31] Build edebaa finished in 8703 ms! 
# > > VuePress dev server listening at http://localhost:8080/
```

## Openssl インストール
- See: http://localhost:8080/installation/deployment.html
- See: https://github.com/openssl/openssl/blob/openssl-3.0.0-alpha4/INSTALL.md#quick-installation-guide

```sh
# インストール
git clone -b openssl-3.0.0-alpha4 https://github.com/openssl/openssl.git
cd openssl && ./config
make
make test
sudo make install

# 確認
openssl version
# > OpenSSL 3.0.0-alpha4 25 Jun 2020 (Library: OpenSSL 3.0.0-alpha4 25 Jun 2020)
```

# testnet起動 (node1台構成)
```sh
make init
make start
```

# リセット
```sh
make reset
```

# token
```sh
# トークン作成
make token-issue
make token-issue | jq -R 'fromjson?' # 整形して表示したい場合
# 編集
make token-edit
# 発行
make token-mint
# 所有権を譲渡
make token-transfer
# 紹介
make query-token
```