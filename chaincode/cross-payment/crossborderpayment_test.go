package main

import (
	"fmt"
	"testing"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/shimtest"
)

func checkInit(t *testing.T, stub *shimtest.MockStub, args [][]byte) {
	res := stub.MockInit("1", args)
	if res.Status != shim.OK {
		fmt.Println("Init failed", string(res.Message))
		t.FailNow()
	}
}

func checkState(t *testing.T, stub *shimtest.MockStub, name string, value string) {
	bytes := stub.State[name]
	if bytes == nil {
		fmt.Println("State", name, "failed to get value")
		t.FailNow()
	}
	if string(bytes) != value {
		fmt.Println("State value", name, "was not", value, "as expected")
		t.FailNow()
	}
}

func checkQuery(t *testing.T, stub *shimtest.MockStub, name string, value string) {
	res := stub.MockInvoke("1", [][]byte{[]byte("query"), []byte(name)})
	if res.Status != shim.OK {
		fmt.Println("Query", name, "failed", string(res.Message))
		t.FailNow()
	}
	if res.Payload == nil {
		fmt.Println("Query", name, "failed to get value")
		t.FailNow()
	}
	if string(res.Payload) != value {
		fmt.Println("Query value", name, "was not", value, "as expected")
		t.FailNow()
	}
}

func checkInvoke(t *testing.T, stub *shimtest.MockStub, args [][]byte) {
	res := stub.MockInvoke("1", args)
	if res.Status != shim.OK {
		fmt.Println("Invoke", args, "failed", string(res.Message))
		t.FailNow()
	}
}

func TestExample01_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex01", scc)
	fmt.Println("Test 1")
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("RBI"), []byte("USD"), []byte("1.20")})
}

func TestExample02_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex02", scc)
	fmt.Println("Test 2")
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("RBI"), []byte("USD"), []byte("85.55"), []byte("1000000")})
}

func TestExample03_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex03", scc)
	fmt.Println("Test 3")
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("RBI"), []byte("USD"), []byte("85.55"), []byte("100000")})
	checkInvoke(t, stub, [][]byte{[]byte("allocate_funds"), []byte("USD"), []byte("10000")})
}

func TestExample04_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex04", scc)
	fmt.Println("Test 4")
	checkInvoke(t, stub, [][]byte{[]byte("allocate_funds"), []byte("USD"), []byte("10000")})
}

func TestExample05_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex05", scc)
	fmt.Println("Test 5")
	checkInvoke(t, stub, [][]byte{[]byte("transfer_money"), []byte("RBI"), []byte("BOA"), []byte("10000"), []byte("INR"), []byte("USD")})
}

func TestExample06_Invoke(t *testing.T) {
	scc := new(crossPaymentContract)
	stub := shimtest.NewMockStub("ex06", scc)
	fmt.Println("Test 6")
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("RBI"), []byte("SPONSOR")})
}
