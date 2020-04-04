gomod:
	@echo "Vendoring Packages"
	sudo GO11MODULE=on go mod vendor

gofmt:
	@echo "gofmt running on goalng z3-code"
	sudo gofmt -s *.go > /dev/null

test: gofmt
	sudo go test -v
