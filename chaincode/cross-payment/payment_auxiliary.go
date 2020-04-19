package main

import (
	"bytes"
	"encoding/json"
	"encoding/hex"
	"time"
	"fmt"
	"crypto/md5"
	"strings"
	"crypto/x509/pkix"
	"math/big"
	"crypto/x509"
	"github.com/TylerBrock/colorjson"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	peer "github.com/hyperledger/fabric-protos-go/peer"
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

var	bank_type map[string]string
var	dummy_transactions map[string][]string

func (s *paymentContract) Init(APIstub shim.ChaincodeStubInterface) peer.Response {

	bank_type = make(map[string]string)
	dummy_transactions = make(map[string][]string)
	bank_type["Org1MSP"] = "sponsor_bank"
	bank_type["Org2MSP"] = "member_bank"
	bank_type["Org3MSP"] = "routing_bank"
	bank_type["Org4MSP"] = "forex_bank"

	return shim.Success(nil)
}

func (s *paymentContract) read_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args. bank_name")
	}

	BankName := strings.ToLower(args[0])
	bankDataJSONasBytes, err := APIstub.GetState(BankName)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + BankName + "\"}"
		return shim.Error(jsonResp)
	} else if bankDataJSONasBytes == nil {
		jsonResp := "{\"Error\":\"Bank does not exist: " + BankName + "\"}"
		return shim.Error(jsonResp)
	}

	byteToJSON(bankDataJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "read_bank() invoked.", bankDataJSONasBytes))
}

func (s *paymentContract) get_forex_details(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args. bank_name, currency")
	}

	BankName := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])
	bankIndex := BankName + Currency + "_forex"
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank/Forex not added. " + err.Error())
	}

	byteToJSON(bankDataJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "get_forex_details() invoked.", bankDataJSONasBytes))
}

func (s *paymentContract) set_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args. bank_name, supported_non_member_banks")
	}

	BankName := strings.ToLower(args[0])
	bankDataJSONasBytes, err := APIstub.GetState(BankName)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + BankName + "\"}"
		return shim.Error(jsonResp)
	} else if bankDataJSONasBytes == nil {
		jsonResp := "{\"Error\":\"Bank does not exist: " + BankName + "\"}"
		return shim.Error(jsonResp)
	}

	bankData := &bank{}
	err = json.Unmarshal(bankDataJSONasBytes, bankData)
	if err != nil {
		return shim.Error("Marshal Error" + err.Error())
	}

	bankData.SuppNonMemberBanks = strings.ToLower(args[1])

	bankDataJSONasBytes, err = json.Marshal(bankData)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(BankName, bankDataJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	byteToJSON(bankDataJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "set_supported_non_member_banks() invoked.", bankDataJSONasBytes))
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

func get_csv_fbanks(APIstub shim.ChaincodeStubInterface) ([]string, error) {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return nil, err
	}

	if bank_type[mspid] != "member_bank"  {
		return nil, err
	}

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"fbank\"}, \"fields\":[\"bank_name\"]}")

	queryResults, err := getQueryResultArrayForQueryString(APIstub, queryString)
	if err != nil {
		return nil, err
	}

	return queryResults, nil
}

func get_csv_rbanks(APIstub shim.ChaincodeStubInterface) ([]string, error) {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return nil, err
	}

	if bank_type[mspid] != "member_bank"  {
		return nil, err
	}

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"rbank\"}, \"fields\":[\"bank_name\"]}")

	queryResults, err := getQueryResultArrayForQueryString(APIstub, queryString)
	if err != nil {
		return nil, err
	}

	return queryResults, nil
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

func getQueryResultArrayForQueryString(APIstub shim.ChaincodeStubInterface, queryString string) ([]string, error) {
	
	resultsIterator, err := APIstub.GetQueryResult(queryString)
	if err != nil {
		return nil, err
	}

	defer resultsIterator.Close()

	var resultArray []string 
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return nil, err
		}

		fmt.Println("Key : "  + string(queryResponse.Key))
		fmt.Println("Value : "  + string(queryResponse.Value))

		resultArray = append(resultArray, string(queryResponse.Value))
	}

	return resultArray, nil
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