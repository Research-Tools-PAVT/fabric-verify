package main

import (
	// "bytes"
	"encoding/json"
	"strconv"
	// "strings"
	// "time"
	"fmt"
	// "crypto/md5"
	"crypto/x509"
	// "io"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	// "github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

type crossPaymentContract struct {

}

type Bank struct {
	ObjectType 			  string `json:"docType"`
	bank_id               string `json:"bank_id"`
	bank_name             string `json:"bank_name"`
	bank_type             string `json:"bank_type"`
	certificate      	  *x509.Certificate `json:"certificate"`
}

type fbank_addnl_curr struct {
	ObjectType 		string  `json:"docType"`
	bank_name		string  `json:"bank_name"`
	currency 		string  `json:"currency"`
	exchange_rate 	float64 `json:exchange_rate`
	balance 		float64 `json:balance`
}

type Currency struct {
	ObjectType 	string  `json:"docType"`
	curr_id     string  `json:"curr_id"`
	curr_amount float64 `json:"curr_amount"`
}

type Transaction struct {
	ObjectType 	string  `json:"docType"`
	trans_id  string  `json:"trans_id"`
	src_bank  string  `json:"src_bank"`
	dest_bank string  `json:"dest_bank"`
	amount    float64 `json:"amount"`
	src_curr  string  `json:"src_curr"`
	dest_curr string  `json:"dest_curr"`
}

func (s *crossPaymentContract) Init(APIstub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (s *crossPaymentContract) Invoke(APIstub shim.ChaincodeStubInterface) peer.Response {

	function, args := APIstub.GetFunctionAndParameters()
	fmt.Println("Invoke is running : " + function)

	if function == "initChaincodePayment" {
		return s.initChaincodePayment(APIstub, args)
	} else if function == "add_forex_currency" {
		return s.add_forex_currency(APIstub, args)
	} else if function == "allocate_funds" {
		return s.allocate_funds(APIstub, args)
	} else if function == "create_bank" {
		return s.create_bank(APIstub, args)
	} else if function == "approve_transaction" {
		return s.approve_transaction(APIstub, args)
	} else if function == "get_completed_transaction" {
		return s.get_completed_transaction(APIstub, args)
	} else if function == "get_pending_transaction" {
		return s.get_pending_transaction(APIstub, args)
	} else if function == "get_supported_currencies" {
		return s.get_supported_currencies(APIstub, args)
	} else if function == "get_supported_non_member_banks" {
		return s.get_supported_non_member_banks(APIstub, args)
	} else if function == "list_fbanks" {
		return s.list_fbanks(APIstub)
	} else if function == "list_mbanks" {
		return s.list_mbanks(APIstub)
	} else if function == "list_rbanks" {
		return s.list_rbanks(APIstub)
	} else if function == "show_bank_details" {
		return s.show_bank_details(APIstub)
	} else if function == "query_balance" {
		return s.query_balance(APIstub, args)
	} else if function == "set_exchange_rate" {
		return s.set_exchange_rate(APIstub, args)
	} else if function == "transfer_money" {
		return s.transfer_money(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name : " + function)
}

func (s *crossPaymentContract) initChaincodePayment (APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 2 {
		return shim.Error("Expecting 2 args <Sponsor_name>, <Sponsor_curr>.")
	}

 	return shim.Success(nil)
}

func (s *crossPaymentContract) add_forex_currency(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 3 {
		return shim.Error("Expecting 3 args bank_name, currency, exchange_rate, optional(balance)")
	}

	// Add fores currency support and update fbank_addnl_curr table.
	bank_name := args[0]
	currency := args[1]
	exchange_rate, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error in " + args[2]) 
	}

	objectType := "fbank_addnl_curr"
	balance := 0.00
	
	if len(args) == 4 {
		balance, err = strconv.ParseFloat(args[3], 64)
		if err != nil {
			return shim.Error("Parse Error in " + args[3]) 
		}
	}

	fbankObj := &fbank_addnl_curr{objectType, bank_name, currency, exchange_rate, balance}

	fbankObjJSONasBytes, err := json.Marshal(fbankObj)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Add to couchdb database.
	fbankObjName := bank_name + currency + "_forex"
	addfbankObj := APIstub.PutState(fbankObjName, fbankObjJSONasBytes)
	if addfbankObj != nil {
		return shim.Error(err.Error())
	}

	// Check if object really added. 
	testObj, err := APIstub.GetState(fbankObjName)
	if err != nil {
			return shim.Error(err.Error())
	}
	testPrintErr := json.Unmarshal([]byte(testObj), fbankObj)
	if testPrintErr != nil {
			return shim.Error(err.Error())
	}
	fmt.Println(fbankObj)

	// TODO : To add support for a currency and set exchange rate of the same against INR
	// Will need a couchdb database store and set_exchange_rate().
	return shim.Success(nil)
}

func (s *crossPaymentContract) allocate_funds(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args currency, amount")
	}

	currency := args[0]
	amount, err := strconv.ParseFloat(args[1], 64)
	if err != nil {
		return shim.Error("Parse Float Error. " + args[1])
	}

	// Check if bank exists and forex entry available. 
	bank_name := "RBI" // Hard Coded Sponsor Bank, later we change to getSponsorBank()
	bankIndex := bank_name + currency + "_forex"
	bankData := &fbank_addnl_curr{}

	// Get bank data to see if it already exists. 
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		fmt.Println("Failed to fetch fbank entry. " + bank_name)
		return shim.Error(err.Error())
	} else if bankDataJSONasBytes == nil {
		fmt.Println("Adding new fbank Entry. " + bank_name)
		s.add_forex_currency(APIstub, []string{"RBI", currency, "1.00", args[1]}) // initial exchange_rate = 1.00 default
	}

	// Bank data already exists
	fmt.Println("Allocating funds to Sponsor Bank. " + bank_name)
	// Get the fresh bank data.
	bankDataJSONasBytes, err = APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	// Modify amount. 
	exchange_rate := bankData.exchange_rate
	// old_amount := bankData.balance
	objectType := "fbank_addnl_curr"

	bankData = &fbank_addnl_curr{objectType, bank_name, currency, exchange_rate, amount}
	bankDataJSONasBytes, _ = json.Marshal(bankData)

	// Add back (rewrite) the data to fbank_addnl_curr table. 
	err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Check if object really added. 
	bankDataJSONasBytes, err = APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankErr = json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	fmt.Println(bankData)
	
	// TODO : To add currency to Sponsor Bank
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func (s *crossPaymentContract) create_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3.")
	}

	// TODO : To create a new Bank
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func (s *crossPaymentContract) approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2.")
	}

	// TODO : To add transactions table with new transaction.
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_completed_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1.")
	}

	// TODO : To get list of completed Transactions [x]<trans_id> from a given bank by bank_name field.
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_pending_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1.")
	}

	// TODO : To get list of pending Transactions [x]<trans_id> from a given bank by bank_name field.
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_supported_currencies(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1.")
	}

	// TODO : To get list of supported currencies [x]<currency> from a given bank by bank_name field.
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1.")
	}

	// TODO : To get list of supported non member banks [x]<bank_name, bank_id> from a given bank by bank_name field.
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_fbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of forex banks [x]<bank_name, bank_id>
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_mbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of member banks [x]<bank_name, bank_id>
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_rbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of routing banks [x]<bank_name, bank_id>
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) show_bank_details(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of all banks [x]<bank_name, bank_id>
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) query_balance(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	// TODO : To get balance of a currency_id from a given bank by bank_name field and currency.
	// Will need a couchdb database query.
	return shim.Success(nil)
}

func (s *crossPaymentContract) set_exchange_rate(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	// TODO : To set exchange rate for a given currency id
	// Will need a couchdb database store
	return shim.Success(nil)
}

func (s *crossPaymentContract) transfer_money(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 5 {
		return shim.Error("Incorrect number of arguments. Expecting atlest 5")
	}

	// TODO : To add a money transfer transaction
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func main() {
	// Create a new Smart Contract
	err := shim.Start(new(crossPaymentContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
