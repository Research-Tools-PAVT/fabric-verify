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

func TestExample00_Invoke(t *testing.T) {
	scc := new(paymentContract)
	stub := shimtest.NewMockStub("ex00", scc)

	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

	fmt.Println("Test 0 Init")
	checkInvoke(t, stub, [][]byte{ []byte("Init") })
}

func TestExample01_Invoke(t *testing.T) {
	scc := new(paymentContract)
	stub := shimtest.NewMockStub("ex01", scc)

	setCreator(t, stub, "Org1MSP", []byte(certWithAttrs))

	fmt.Println("Test 1 Create Banks")
	checkInvoke(t, stub, [][]byte{ []byte("Init") })
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("RBI"), []byte("sponsor")})
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("ICICI"), []byte("mbank")})
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("HDFC"), []byte("fbank")})
	checkInvoke(t, stub, [][]byte{[]byte("create_bank"), []byte("HSBC"), []byte("rbank")})
}

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

