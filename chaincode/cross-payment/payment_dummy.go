package main

import (
	"encoding/json"
	"fmt"
	"strings"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

var	bank_type map[string]string
var	dummy_transactions map[string][]string

func (s *crossPaymentContract) Init(APIstub shim.ChaincodeStubInterface) peer.Response {

	bank_type = make(map[string]string)
	dummy_transactions = make(map[string][]string)
	bank_type["Org1MSP"] = "sponsor_bank"
	bank_type["Org2MSP"] = "member_bank"
	bank_type["Org3MSP"] = "routing_bank"
	bank_type["Org4MSP"] = "forex_bank"
	fmt.Println(bank_type)

	return shim.Success(nil)
}

func (s *crossPaymentContract) read_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

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

func (s *crossPaymentContract) get_forex_details(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

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

func (s *crossPaymentContract) set_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

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

func (s *crossPaymentContract) automate_approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"dest_bank\":\"%s\",\"trans_status\":\"pending\"}, \"fields\":[\"trans_id\"]}", bank_name)

	resultsIterator, err := APIstub.GetQueryResult(queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	defer resultsIterator.Close()

	var params []string 

	// Populate transaction IDs pending on bank.
	for resultsIterator.HasNext() {
		queryResponse, err := resultsIterator.Next()
		if err != nil {
			return shim.Error(err.Error())
		}

		fmt.Println("Key : "  + string(queryResponse.Key))
		fmt.Println("Value : "  + string(queryResponse.Value))

		params = append(params, string(queryResponse.Value))
	}

	// Approve each transaction
	for trans_index := range params {
		/* go */  s.approve_transaction(APIstub, []string{bank_name, params[trans_index]})
	}
	
	return shim.Success(nil)
}

func (s *crossPaymentContract) dummy_approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])

	for trans_index := range dummy_transactions[bank_name] {
		new_args := []string{bank_name, dummy_transactions[bank_name][trans_index]}
		/* go */  s.approve_transaction(APIstub, new_args)
	}
	
	return shim.Success(nil)
}