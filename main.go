package main

import (
	sdk "github.com/bianjieai/bsnhub-sdk-go"
	"github.com/bianjieai/irita-sdk-go/types"
)

func main() {

	// SDK の初期化
	// http://localhost:8080/SDK/Go_SDK/overview.html
	options := []types.Option{
		types.KeyDAOOption(store.NewMemory(nil)),
		types.TimeoutOption(10),
	}

	cfg, err := types.NewClientConfig(nodeURI, chainID, options...)
	if err != nil {
		panic(err)
	}

	client := sdk.NewIRITAClient(cfg)
	println(client)
}
