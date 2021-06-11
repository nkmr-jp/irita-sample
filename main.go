package main

import (
	sdk "github.com/bianjieai/bsnhub-sdk-go"
	"github.com/bianjieai/irita-sdk-go/types"
	"github.com/bianjieai/irita-sdk-go/types/store"
)

func main() {
	nodeURI := "tcp://localhost:26657"
	chainID := "test"
	grpcAddr := "0.0.0.0:9090"
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
