package main

import (
	sdk "github.com/bianjieai/bsnhub-sdk-go"
	"github.com/bianjieai/irita-sdk-go/types"
	"github.com/bianjieai/irita-sdk-go/types/store"
)

const (
	nodeURI  = "tcp://127.0.0.1:26657"
	grpcAddr = "localhost:9090"
	chainID  = "test"
)

func main() {
	options := []types.Option{
		types.KeyDAOOption(store.NewMemory(nil)),
		types.TimeoutOption(10),
	}
	cfg, err := types.NewClientConfig(nodeURI, chainID, grpcAddr, options...)
	if err != nil {
		panic(err)
	}
	client := sdk.NewIRITAClient(cfg)
	oracleClient := sdk.OracleClient(client)
	println(oracleClient)
}
