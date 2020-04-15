package main

import (
	"fmt"
	"testing"
	"github.com/gogo/protobuf/proto"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/shimtest"
	"github.com/hyperledger/fabric-protos-go/msp"
)

const certWithOutAttrs = `-----BEGIN CERTIFICATE-----
MIICXTCCAgSgAwIBAgIUeLy6uQnq8wwyElU/jCKRYz3tJiQwCgYIKoZIzj0EAwIw
eTELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWExFjAUBgNVBAcTDVNh
biBGcmFuY2lzY28xGTAXBgNVBAoTEEludGVybmV0IFdpZGdldHMxDDAKBgNVBAsT
A1dXVzEUMBIGA1UEAxMLZXhhbXBsZS5jb20wHhcNMTcwOTA4MDAxNTAwWhcNMTgw
OTA4MDAxNTAwWjBdMQswCQYDVQQGEwJVUzEXMBUGA1UECBMOTm9ydGggQ2Fyb2xp
bmExFDASBgNVBAoTC0h5cGVybGVkZ2VyMQ8wDQYDVQQLEwZGYWJyaWMxDjAMBgNV
BAMTBWFkbWluMFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEFq/90YMuH4tWugHa
oyZtt4Mbwgv6CkBSDfYulVO1CVInw1i/k16DocQ/KSDTeTfgJxrX1Ree1tjpaodG
1wWyM6OBhTCBgjAOBgNVHQ8BAf8EBAMCB4AwDAYDVR0TAQH/BAIwADAdBgNVHQ4E
FgQUhKs/VJ9IWJd+wer6sgsgtZmxZNwwHwYDVR0jBBgwFoAUIUd4i/sLTwYWvpVr
TApzcT8zv/kwIgYDVR0RBBswGYIXQW5pbHMtTWFjQm9vay1Qcm8ubG9jYWwwCgYI
KoZIzj0EAwIDRwAwRAIgCoXaCdU8ZiRKkai0QiXJM/GL5fysLnmG2oZ6XOIdwtsC
IEmCsI8Mhrvx1doTbEOm7kmIrhQwUVDBNXCWX1t3kJVN
-----END CERTIFICATE-----
`
const certWithAttrs = `-----BEGIN CERTIFICATE-----
MIIB6TCCAY+gAwIBAgIUHkmY6fRP0ANTvzaBwKCkMZZPUnUwCgYIKoZIzj0EAwIw
GzEZMBcGA1UEAxMQZmFicmljLWNhLXNlcnZlcjAeFw0xNzA5MDgwMzQyMDBaFw0x
ODA5MDgwMzQyMDBaMB4xHDAaBgNVBAMTE015VGVzdFVzZXJXaXRoQXR0cnMwWTAT
BgcqhkjOPQIBBggqhkjOPQMBBwNCAATmB1r3CdWvOOP3opB3DjJnW3CnN8q1ydiR
dzmuA6A2rXKzPIltHvYbbSqISZJubsy8gVL6GYgYXNdu69RzzFF5o4GtMIGqMA4G
A1UdDwEB/wQEAwICBDAMBgNVHRMBAf8EAjAAMB0GA1UdDgQWBBTYKLTAvJJK08OM
VGwIhjMQpo2DrjAfBgNVHSMEGDAWgBTEs/52DeLePPx1+65VhgTwu3/2ATAiBgNV
HREEGzAZghdBbmlscy1NYWNCb29rLVByby5sb2NhbDAmBggqAwQFBgcIAQQaeyJh
dHRycyI6eyJhdHRyMSI6InZhbDEifX0wCgYIKoZIzj0EAwIDSAAwRQIhAPuEqWUp
svTTvBqLR5JeQSctJuz3zaqGRqSs2iW+QB3FAiAIP0mGWKcgSGRMMBvaqaLytBYo
9v3hRt1r8j8vN0pMcg==
-----END CERTIFICATE-----
`

func setCreator(t *testing.T, stub *shimtest.MockStub, mspID string, idbytes []byte) {
    sid := &msp.SerializedIdentity{Mspid: mspID, IdBytes: idbytes}
    b, err := proto.Marshal(sid)
    if err != nil {
        t.FailNow()
    }
    stub.Creator = b
}

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

// func TestExample00_Invoke(t *testing.T) {
// 	scc := new(paymentContract)
// 	stub := shimtest.NewMockStub("ex00", scc)

// 	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

// 	fmt.Println("Test 0 Init")
// 	checkInvoke(t, stub, [][]byte{ []byte("Init") })
// }

// func TestExample01_Invoke(t *testing.T) {
// 	scc := new(paymentContract)
// 	stub := shimtest.NewMockStub("ex01", scc)

// 	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

// 	fmt.Println("Test 1 Create Banks")
// 	checkInvoke(t, stub, [][]byte{ []byte("Init") })
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("RBI"), []byte("sponsor")})
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("ICICI"), []byte("mbank")})
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("HDFC"), []byte("fbank")})
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("HSBC"), []byte("rbank")})
// }

// func TestExample02_Invoke(t *testing.T) {
// 	scc := new(paymentContract)
// 	stub := shimtest.NewMockStub("ex02", scc)

// 	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

// 	fmt.Println("Test 2 Create & Read Banks")
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("RBI"), []byte("sponsor")})
// 	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("ICICI"), []byte("mbank")})
// 	checkInvoke(t, stub, [][]byte{[]byte("read_bank"), []byte("ICICI")})
// 	checkInvoke(t, stub, [][]byte{[]byte("read_bank"), []byte("RBI")})
// }

func TestExample03_Invoke(t *testing.T) {
	scc := new(paymentContract)
	stub := shimtest.NewMockStub("ex03", scc)

	fmt.Println("Test End-To-End Scenario")

	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

	fmt.Println("Creating and Updating Sponsor Bank")
	checkInvoke(t, stub, [][]byte{ []byte("Init") })
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("RBI"), []byte("sponsor")})
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("RBI"), []byte("INR"), []byte("1.00"), []byte("0.00")})
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("RBI"), []byte("USD"), []byte("1.00"), []byte("0.00")})

	fmt.Println("Allocating Funds to Sponsor Bank")
	checkInvoke(t, stub, [][]byte{[]byte("allocate_funds"), []byte("USD"), []byte("10000")})
	checkInvoke(t, stub, [][]byte{[]byte("allocate_funds"), []byte("INR"), []byte("100000")})

	fmt.Println("Set Exchange Rate for Sponsor Bank")
	checkInvoke(t, stub, [][]byte{[]byte("set_exchange_rate"), []byte("RBI"), []byte("INR"), []byte("1.00")})
	checkInvoke(t, stub, [][]byte{[]byte("set_exchange_rate"), []byte("RBI"), []byte("USD"), []byte("0.015")})

	fmt.Println("Sponsor Bank creates other Banks")

	fmt.Println("ICICI BANK")
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("ICICI"), []byte("mbank")})

	fmt.Println("HSBC BANK")
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("HSBC"), []byte("fbank")})

	fmt.Println("BOA BANK")
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("BOA"), []byte("rbank")})

	fmt.Println("Added Forex Currency Support")
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("ICICI"), []byte("INR"), []byte("1.00"), []byte("0.00")})
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("HSBC"), []byte("INR"), []byte("1.00"), []byte("0.00")})
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("HSBC"), []byte("USD"), []byte("0.015"), []byte("0.00")})
	checkInvoke(t, stub, [][]byte{[]byte("add_forex_currency"), []byte("BOA"), []byte("USD"), []byte("0.015"), []byte("0.00")})

	fmt.Println("Transfer Money from Sponsor Bank to Other Banks")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("RBI"), []byte("ICICI"), []byte("10000"), []byte("INR"), []byte("INR")})
	fmt.Println("Transfer Money from Sponsor Bank to Other Banks")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("RBI"), []byte("HSBC"), []byte("10000"), []byte("INR"), []byte("INR")})
	fmt.Println("Transfer Money from Sponsor Bank to Other Banks")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("RBI"), []byte("HSBC"), []byte("1000"), []byte("USD"), []byte("USD")})
	fmt.Println("Transfer Money from Sponsor Bank to Other Banks")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("RBI"), []byte("BOA"), []byte("1000"), []byte("USD"), []byte("USD")})

	fmt.Println("Approve Transaction : ICICI")
	setCreator(t, stub, "Org2MSP", []byte(certWithAttrs))
	checkInvoke(t, stub, [][]byte{[]byte("dummy_approve_transaction"), []byte("ICICI")})

	fmt.Println("Approve Transaction : HSBC")
	setCreator(t, stub, "Org3MSP", []byte(certWithAttrs))
	checkInvoke(t, stub, [][]byte{[]byte("dummy_approve_transaction"), []byte("HSBC")})

	fmt.Println("Approve Transaction : BOA")
	setCreator(t, stub, "Org4MSP", []byte(certWithAttrs))
	checkInvoke(t, stub, [][]byte{[]byte("dummy_approve_transaction"), []byte("BOA")})

	setCreator(t, stub, "Org2MSP", []byte(certWithAttrs))
	fmt.Println("Transfer : ICICI to HSBC, 1000 INR")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("ICICI"), []byte("HSBC"), []byte("1000"), []byte("INR"), []byte("INR")})

	setCreator(t, stub, "Org3MSP", []byte(certWithAttrs))
	fmt.Println("Transfer : HSBC to BOA, 1000 INR Equivalent USD")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_transfer_money"), []byte("HSBC"), []byte("BOA"), []byte("1000"), []byte("INR"), []byte("USD")})
	fmt.Println("Transfer : HSBC to BOA, 1000 INR Equivalent USD")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_approve_transaction"), []byte("HSBC")})

	setCreator(t, stub, "Org4MSP", []byte(certWithAttrs))
	fmt.Println("Transfer : HSBC to BOA, 1000 INR Equivalent USD")
	checkInvoke(t, stub, [][]byte{[]byte("dummy_approve_transaction"), []byte("BOA")})

	fmt.Println("Query Balance : ")
	checkInvoke(t, stub, [][]byte{[]byte("query_balance"), []byte("RBI"), []byte("INR")})
	fmt.Println("Query Balance : ")
	checkInvoke(t, stub, [][]byte{[]byte("query_balance"), []byte("ICICI"), []byte("INR")})
	fmt.Println("Query Balance : ")
	checkInvoke(t, stub, [][]byte{[]byte("query_balance"), []byte("HSBC"), []byte("INR")})
	fmt.Println("Query Balance : ")
	checkInvoke(t, stub, [][]byte{[]byte("query_balance"), []byte("HSBC"), []byte("USD")})
	fmt.Println("Query Balance : ")
	checkInvoke(t, stub, [][]byte{[]byte("query_balance"), []byte("BOA"), []byte("USD")})
}

