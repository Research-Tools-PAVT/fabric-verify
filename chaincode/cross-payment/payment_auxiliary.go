package main

import (
	"bytes"
	"encoding/json"
	"encoding/hex"
	"time"
	"fmt"
	"crypto/md5"
	"crypto/x509/pkix"
	"math/big"
	"crypto/x509"
	"github.com/TylerBrock/colorjson"
	"github.com/hyperledger/fabric-chaincode-go/shim"
)

const (
	CODESUCCESS		string = "200"
	CODERROR		string = "500"
	CODEFATALERROR	string = "800"
)

type callResponse struct {
	Code    	string `json:"code"`
	Message 	string `json:"message"`
	Payload 	[]byte `json:"payload"`
	TxnID 		string `json:"txn_id"`
	Timestamp	string `json:"txn_timestamp"`
}

func getMD5Hash(src string) string {
    hasher := md5.New()
    hasher.Write([]byte(src))
    return hex.EncodeToString(hasher.Sum(nil))
}

func (f *callResponse) JSONformatResponse() []byte {

	var buffer bytes.Buffer

	buffer.WriteString("{\"code\":")
	buffer.WriteString("\"")
	buffer.WriteString(f.Code)
	buffer.WriteString("\",")
	buffer.WriteString("\"message\":")
	buffer.WriteString("\"")
	buffer.WriteString(f.Message)
	buffer.WriteString("\",")
	if f.Payload != nil {
		buffer.WriteString("\"payload\":")
		buffer.WriteString("\"")
		buffer.Write(f.Payload)
		buffer.WriteString("\",")
	}
	buffer.WriteString("\"txn_id\":")
	buffer.WriteString("\"")
	buffer.WriteString(f.TxnID)
	buffer.WriteString("\",")
	buffer.WriteString("\"txn_timestamp\":")
	buffer.WriteString("\"")
	buffer.WriteString(f.Timestamp)
	buffer.WriteString("\"}")
	return buffer.Bytes()
}

func getDummyCertificate() x509.Certificate {
	return x509.Certificate{
		SerialNumber: big.NewInt(5899654),
		Subject: pkix.Name{
			Organization: []string{"PayZ Inc"},
		},
		NotBefore: time.Now(),
		NotAfter:  time.Now().Add(time.Hour * 24 * 180),
		KeyUsage:              x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:           []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		BasicConstraintsValid: true,
	}
}

func byteToJSON(data []byte, indent int8) error {
	
	var obj map[string]interface{}
	err := json.Unmarshal(data, &obj)
	if err != nil {
		fmt.Println("Marshal Error : " + err.Error()) 
		return err
	}

	f := colorjson.NewFormatter()
    f.Indent = 2

    l, _ := f.Marshal(obj)
	fmt.Println(string(l))

	return nil
}

func getQueryResultForQueryString(APIstub shim.ChaincodeStubInterface, queryString string) ([]byte, error) {

	fmt.Printf("- getQueryResultForQueryString queryString:\n%s\n", queryString)

	resultsIterator, err := APIstub.GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}
	defer resultsIterator.Close()

	buffer, err := constructQueryResponseFromIterator(resultsIterator)
	if err != nil {
		return nil, err
	}

	fmt.Printf("- getQueryResultForQueryString queryResult:\n%s\n", buffer.String())

	return buffer.Bytes(), nil
}

func constructQueryResponseFromIterator(resultsIterator shim.StateQueryIteratorInterface) (*bytes.Buffer, error) {
	// buffer is a JSON array containing QueryResults
	var buffer bytes.Buffer
	buffer.WriteString("[")

	bArrayMemberAlreadyWritten := false
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}
		// Add a comma before array members, suppress it for the first array member
		if bArrayMemberAlreadyWritten == true {
			buffer.WriteString(",")
		}
		buffer.WriteString("{\"Key\":")
		buffer.WriteString("\"")
		buffer.WriteString(queryResponse.Key)
		buffer.WriteString("\"")

		buffer.WriteString(", \"Record\":")
		// Record is a JSON object, so we write as-is
		buffer.WriteString(string(queryResponse.Value))
		buffer.WriteString("}")
		bArrayMemberAlreadyWritten = true
	}
	buffer.WriteString("]")

	return &buffer, nil
}

func createResult(APIstub shim.ChaincodeStubInterface, code string, message string, payload []byte) []byte {
	txnID := APIstub.GetTxID()
	timestamp, _ := APIstub.GetTxTimestamp()
	resultResponse := callResponse{code, message, payload, txnID, time.Unix(timestamp.GetSeconds(), 0).String()}
	return resultResponse.JSONformatResponse()
}