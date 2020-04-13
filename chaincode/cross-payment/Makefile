gofmt:
	@echo "gofmt running on goalng chaincode"
	sudo gofmt -s *.go > /dev/null

vet: gofmt
	sudo go vet 

test: vet
	sudo go test -v
