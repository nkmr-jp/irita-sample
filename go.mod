module irita-sample

go 1.15

//github.com/bianjieai/bsnhub-sdk-go v1.0.0 // indirect
//github.com/bianjieai/irita-sdk-go v0.0.0-20210426091508-29597b871513
require github.com/bianjieai/irita-sdk-go v1.1.0

replace github.com/tendermint/tendermint => github.com/bianjieai/tendermint v0.34.8-irita-210413

replace github.com/gogo/protobuf => github.com/regen-network/protobuf v1.3.3-alpha.regen.1
