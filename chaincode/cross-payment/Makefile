gofmt:
	@echo "gofmt running on goalng chaincode"
	sudo gofmt -s *.go > /dev/null

vet: gofmt
	sudo go vet 

test: vet
	sudo go test -v
	
calls: 
	sudo go build -work -x payment_main.go payment_auxiliary.go 1> transcript.txt 2>&1
