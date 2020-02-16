package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"strconv"
	"time"
	"github.com/hyperledger/fabric/core/chaincode/shim"
	"github.com/hyperledger/fabric/core/chaincode/lib/cid"
	peer "github.com/hyperledger/fabric/protos/peer"
)

type crossPaymentContract struct {
	
}

type Bank struct {
	bank_id string `json:"bankid"`
	bank_name string `json:"bankname"`
	bank_type string `json:"banktype"`
	certificate_hash string `json:"cert"`
	balances map[string]float64 // populate in table 
}

type Currency struct {
	currency_id string `json:"currency"`
	amount float64 `json:"amount"`
}

type Transaction struct {
	trans_id string // util.randomstring()
	src_bank string `json:"src_bankname"`
	dest_bank string `json:"dest_bankname"`
	amount float64 `json:"amount"`
	src_curr string `json:"src_curr"`
	dest_curr string `json:"dest_curr"`
}

func (s *crossPaymentContract) Init(APIstub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (s *crossPaymentContract) Invoke(APIstub shim.ChaincodeStubInterface) peer.Response {

    function, args := APIstub.GetFunctionAndParameters()

	if function == "add_forex_currency" {
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

	return shim.Error("Invalid Smart Contract function name.")
}

func (s *crossPaymentContract) add_forex_currency(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	var bank_name = args[0]
	var currency_id = args[1]
	var exchange_rate = strconv.ParseFloat(args[2], 64)
	// TODO : To add support for a currency and set exchange rate of the same against INR
	// Will need a couchdb database store and set_exchange_rate().
	fmt.Println("	add_forex_currency	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) allocate_funds(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	var currency_id = args[0]
	var amount = strconv.ParseFloat(args[1], 64)
	// TODO : To add currency to Sponsor Bank
	// Will need a couchdb database store.
	fmt.Println("	allocate_funds	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) create_bank(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 5 {
		return shim.Error("Incorrect number of arguments. Expecting 5")
	}

	// TODO : To create a new Bank
	// Will need a couchdb database store.
	fmt.Println("	create_bank    ", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) approve_transaction(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	var bank_name = args[0]
	var trans_id = args[1]
	// TODO : To add transactions table with new transaction.
	// Will need a couchdb database store.
	fmt.Println("	approve_transaction		", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_completed_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	var bank_name = args[0]
	// TODO : To get list of completed Transactions [x]<trans_id> from a given bank by bank_name field. 
	// Will need a couchdb database query.
	fmt.Println("	get_completed_transaction	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_pending_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	var bank_name = args[0]
	// TODO : To get list of pending Transactions [x]<trans_id> from a given bank by bank_name field. 
	// Will need a couchdb database query.
	fmt.Println("	get_pending_transaction		", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_supported_currencies(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	var bank_name = args[0]
	// TODO : To get list of supported currencies [x]<currency> from a given bank by bank_name field. 
	// Will need a couchdb database query.
	fmt.Println("	get_supported_currencies	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting 1")
	}

	var bank_name = args[0]
	// TODO : To get list of supported non member banks [x]<bank_name, bank_id> from a given bank by bank_name field. 
	// Will need a couchdb database query.
	fmt.Println("	get_supported_non_member_banks	 ", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_fbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of forex banks [x]<bank_name, bank_id> 
	// Will need a couchdb database query.
	fmt.Println("	list_fbanks	")
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_mbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of member banks [x]<bank_name, bank_id>  
	// Will need a couchdb database query.
	fmt.Println("	list_mbanks	")
	return shim.Success(nil)
}

func (s *crossPaymentContract) list_rbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of routing banks [x]<bank_name, bank_id> 
	// Will need a couchdb database query.
	fmt.Println("	list_rbanks	")
	return shim.Success(nil)
}

func (s *crossPaymentContract) show_bank_details(APIstub shim.ChaincodeStubInterface) peer.Response {

	// TODO : To get list of all banks [x]<bank_name, bank_id> 
	// Will need a couchdb database query.
	fmt.Println("	show_bank_details	")
	return shim.Success(nil)
}

func (s *crossPaymentContract) query_balance(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 2 {
		return shim.Error("Incorrect number of arguments. Expecting 2")
	}

	var bank_name = args[0]
	var currency_id = args[1]
	// TODO : To get balance of a currency_id from a given bank by bank_name field and currency. 
	// Will need a couchdb database query.
	fmt.Println("	query_balance	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) set_exchange_rate(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) != 3 {
		return shim.Error("Incorrect number of arguments. Expecting 3")
	}

	var bank_name = args[0]
	var currency_id = args[1]
	var exchange_rate = strconv.ParseFloat(args[2], 64)
	// TODO : To set exchange rate for a given currency id
	// Will need a couchdb database store
	fmt.Println("	set_exchange_rate	", args)
	return shim.Success(nil)
}

func (s *crossPaymentContract) transfer_money(APIstub shim.ChaincodeStubInterface,  args []string) peer.Response {
	
	if len(args) < 5  {
		return shim.Error("Incorrect number of arguments. Expecting atlest 5")
	}

	var source_bank_name = args[0]
	var dest_bank_name = args[1]
	var amount = strconv.Atoi(args[2])
	var source_currency_id = args[3]
	var dest_currency_id = args[4]
	var forex_bank_id = ""
	var route_bank_id = ""

	if len(args) == 6
		forex_bank_id = args[5]
	
	if len(args) == 7 {
		forex_bank_id = args[5]
		route_bank_id = args[6]
	}
		
	// TODO : To add a money transfer transaction
	// Will need a couchdb database store.
	fmt.Println("	transfer_money	", args)
	return shim.Success(nil)
}

func main() {
	// Create a new Smart Contract
	err := shim.Start(new(crossPaymentContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
