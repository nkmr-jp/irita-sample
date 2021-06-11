package main

import (
	"os"

	sdk "github.com/bianjieai/irita-sdk-go"
	// sdk "github.com/bianjieai/irita-sdk-go"
	"github.com/bianjieai/irita-sdk-go/types"
	"github.com/bianjieai/irita-sdk-go/types/store"
	// sdk "github.com/bianjieai/bsnhub-sdk-go"
)

// SDK の初期化
// http://localhost:8080/SDK/Go_SDK/overview.html
// https://github.com/irisnet/irishub-sdk-go/issues/69
// https://github.com/irisnet/irishub-sdk-go
// http://localhost:8080/quick_start/sdk_init.html
func main() {
	// 定义客户端配置变量
	nodeURI := "tcp://localhost:26657"
	// network := types.Mainnet
	chainID := "test"
	gas := 200000
	fee := types.NewDecCoins(types.NewDecCoin("point", types.NewInt(5)))
	mode := types.Commit
	algo := "sm2"
	timeout := 10
	level := "info"
	dbPath, _ := os.Getwd()

	// 生成客户端配置对象
	clientConfig := types.ClientConfig{
		NodeURI: nodeURI,
		// Network:   "network",
		ChainID: chainID,
		Gas:     uint64(gas),
		Fee:     fee,
		Mode:    mode,
		Algo:    algo,
		KeyDAO:  store.NewFileDAO(dbPath),
		Timeout: uint(timeout),
		Level:   level,
	}

	// if err != nil {
	// 	panic(err)
	// }

	client := sdk.NewIRITAClient(clientConfig)
	println(client)
}
