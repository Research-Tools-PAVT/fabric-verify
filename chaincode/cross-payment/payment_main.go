package main

import (
	"crypto/x509"
	"encoding/json"
	"fmt"
	"strconv"
	"strings"
	"time"
	"github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

type paymentContract struct {
}

type bank struct {
	ObjectType         string            `json:"docType"`
	BankId             string            `json:"bank_id"`
	BankName           string            `json:"bank_name"`
	BankType           string            `json:"bank_type"`
	SuppNonMemberBanks string            `json:"supp_non_member_banks"`
	Certificate        *x509.Certificate `json:"certificate"`
}

type fbank_addnl_curr struct {
	ObjectType    string  `json:"docType"`
	Bank_name     string  `json:"bank_name"`
	Currency      string  `json:"currency"`
	Exchange_rate float64 `json:"exchange_rate"`
	Balance       float64 `json:"balance"`
}

type transaction struct {
	ObjectType       string  `json:"docType"`
	Origin_timestamp string  `json:"origin_time"`
	Trans_id         string  `json:"trans_id"`
	Src_bank         string  `json:"src_bank"`
	Dest_bank        string  `json:"dest_bank"`
	Amount           float64 `json:"amount"`
	Src_curr         string  `json:"src_curr"`
	Dest_curr        string  `json:"dest_curr"`
	Fbank            string  `json:"fbank"`
	Rbank            string  `json:"rbank"`
	Last_approved    string  `json:"last_approved"`
	Assigned_to      string  `json:"assigned_to"`
	Trans_status     string  `json:"trans_status"`
	Update_timestamp string  `json:"update_time"`
}

func (s *paymentContract) Invoke(APIstub shim.ChaincodeStubInterface) peer.Response {

	function, args := APIstub.GetFunctionAndParameters()

	if function == "add_forex_currency" {
		return s.add_forex_currency(APIstub, args)
	} else if function == "allocate_funds" {
		return s.allocate_funds(APIstub, args)
	} else if function == "create_bank" {
		return s.create_bank(APIstub, args)
	} else if function == "read_bank" {
		return s.read_bank(APIstub, args)
	} else if function == "approve_transaction" {
		return s.approve_transaction(APIstub, args)
	} else if function == "get_completed_transaction" {
		return s.get_completed_transaction(APIstub, args)
	} else if function == "get_all_completed_transaction" {
		return s.get_all_completed_transaction(APIstub)
	} else if function == "get_pending_transaction" {
		return s.get_pending_transaction(APIstub, args)
	} else if function == "get_all_pending_transaction" {
		return s.get_all_pending_transaction(APIstub)
	} else if function == "get_sponsor_bank" {
		return s.get_sponsor_bank(APIstub)
	} else if function == "get_supported_currencies" {
		return s.get_supported_currencies(APIstub, args)
	} else if function == "get_forex_details" {
		return s.get_forex_details(APIstub, args)
	} else if function == "get_transaction_details" {
		return s.get_transaction_details(APIstub, args)
	} else if function == "get_supported_non_member_banks" {
		return s.get_supported_non_member_banks(APIstub, args)
	} else if function == "set_supported_non_member_banks" {
		return s.set_supported_non_member_banks(APIstub, args)
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
	} else if function == "Init" {
		return s.Init(APIstub)
	}

	return shim.Error("Invalid Smart Contract function name : " + function)
}

func (s *paymentContract) create_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	// Invoke Access Check
	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "sponsor_bank" {
		return shim.Error("Failed Invoke create_bank() : Only Sponsor Bank can invoke.")
	} 

	if len(args) < 2 {
		return shim.Error("Expecting 2 args. bank_name, bank_type")
	}

	BankName := strings.ToLower(args[0])
	BankType := strings.ToLower(args[1])
	BankId := getMD5Hash(BankName + BankType)
	SuppNonMemberBanks := "None"

	// Certificate := getDummyCertificate()  //  need to import real certificate later.
	// Check against MSPID : cid.getMSPID() if create_bank() possible.
	
	Certificate, err := cid.GetX509Certificate(APIstub)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankAsBytes, err := APIstub.GetState(BankName)
	if err != nil {
		return shim.Error("Failed to Query : " + err.Error())
	} else if bankAsBytes != nil {
		return shim.Error("This bank already exists : " + BankName)
	}

	objectType := "banks"
	bankData := &bank{objectType, BankId, BankName, BankType, SuppNonMemberBanks, Certificate}
	bankJSONasBytes, err := json.Marshal(bankData)
	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(BankName, bankJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	// byteToJSON(bankJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "create_bank() invoked.", bankJSONasBytes))
}

func (s *paymentContract) get_transaction_details(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 1 args. trans_id")
	}

	transcJSONasBytes, err := APIstub.GetState(args[0])
	if err != nil {
		return shim.Error(err.Error())
	} else if transcJSONasBytes == nil {
		return shim.Error("Transaction not found. " + err.Error())
	}

	byteToJSON(transcJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "get_transaction_details() invoked.", transcJSONasBytes))
}

func (s *paymentContract) add_forex_currency(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "sponsor_bank" {
		return shim.Error("Failed to invoke add_forex_currency() : Only Sponsor Bank Allowed")
	}

	if len(args) < 3 {
		return shim.Error("Expecting atleast 3 args. bank_name, currency, exchange_rate, optional(balance)")
	}

	objectType := "fbank_addnl_curr"
	BankName := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])
	Balance := 0.000

	Exchange_rate, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error in " + args[2])
	}

	if len(args) == 4 {
		Balance, err = strconv.ParseFloat(args[3], 64)
		if err != nil {
			return shim.Error("Parse Error in " + args[3])
		}
	}

	fbankObj := &fbank_addnl_curr{objectType, BankName, Currency, Exchange_rate, Balance}
	fbankObjJSONasBytes, err := json.Marshal(fbankObj)
	if err != nil {
		return shim.Error(err.Error())
	}

	fbankObjName := BankName + Currency + "_forex"
	addfbankObj := APIstub.PutState(fbankObjName, fbankObjJSONasBytes)
	if addfbankObj != nil {
		return shim.Error(err.Error())
	}

	byteToJSON(fbankObjJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "add_forex_currency() invoked.", fbankObjJSONasBytes))
}

func (s *paymentContract) allocate_funds(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "sponsor_bank" {
		return shim.Error("Failed to invoke allocate_funds() : Only Sponsor Bank Allowed")
	}

	if len(args) != 2 {
		return shim.Error("Expecting 2 args currency, amount")
	}

	Currency := strings.ToLower(args[0])
	Amount, err := strconv.ParseFloat(args[1], 64)
	if err != nil {
		return shim.Error("Parse Float Error. " + args[1])
	}

	BankName := "rbi" // Hard Coded Sponsor Bank ?

	bankData := &fbank_addnl_curr{}
	bankIndex := BankName + Currency + "_forex"
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank/Forex not added. " + err.Error())
	}

	err = json.Unmarshal(bankDataJSONasBytes, bankData)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankData.Balance = Amount
	bankData.Currency = Currency
	bankDataJSONasBytes, _ = json.Marshal(bankData)

	err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	byteToJSON(bankDataJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "allocate_funds() invoked.", bankDataJSONasBytes))
}

func (s *paymentContract) approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args, bank_name, trans_id.")
	}

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	bankName := strings.ToLower(args[0])
	transcJSONasBytes, err := APIstub.GetState(args[1])
	if err != nil {
		return shim.Error(err.Error())
	} else if transcJSONasBytes == nil {
		return shim.Error("Transaction not found. " + err.Error())
	}

	transcObj := &transaction{}
	transcErr := json.Unmarshal(transcJSONasBytes, transcObj)
	if transcErr != nil {
		return shim.Error(err.Error())
	}

	timestamp, _ := APIstub.GetTxTimestamp()
	transcObj.Update_timestamp = time.Unix(timestamp.GetSeconds(), 0).String()

	// Update assigned_to bank currency. 
	// Not implemented yet.

	if  bank_type[mspid] == "forex_bank" {
		transcObj.Trans_status = "fbank_approved"
	} else if bank_type[mspid] == "routing_bank" {
		transcObj.Trans_status = "completed"
	} else {
		transcObj.Trans_status = "error"
	}

	transcObj.Last_approved = bankName + "_approved"

	transcJSONasBytes, _ = json.Marshal(transcObj)
	err = APIstub.PutState(args[1], transcJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	byteToJSON(transcJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "approve_transaction() invoked", transcJSONasBytes))
}

func (s *paymentContract) get_completed_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "member_bank" {
		return shim.Error("Failed to invoke get_completed_transaction() : Only Member Bank Allowed")
	}

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"src_bank\":\"%s\",\"trans_status\":\"completed\"}, \"fields\":[\"bank_name\",\"trans_id\",\"src_bank\",\"dest_bank\",\"src_curr\",\"dest_curr\",\"last_approved\",\"assigned_to\",\"update_time\"]}", bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_completed_transaction() invoked", queryResults))
}

func (s *paymentContract) get_pending_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"assigned_to\":\"%s\",\"trans_status\":\"pending\"}, \"fields\":[\"bank_name\",\"trans_id\",\"src_bank\",\"dest_bank\",\"src_curr\",\"dest_curr\",\"last_approved\",\"assigned_to\",\"update_time\"]}", bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_pending_transaction() invoked", queryResults))
}

func (s *paymentContract) get_all_pending_transaction(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"trans_status\":\"pending\"},\"fields\":[\"bank_name\",\"trans_id\",\"src_bank\",\"dest_bank\",\"src_curr\",\"dest_curr\",\"last_approved\",\"assigned_to\",\"update_time\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_all_pending_transaction() invoked", queryResults))
}

func (s *paymentContract) get_all_completed_transaction(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"trans_status\":\"completed\"},\"fields\":[\"bank_name\",\"trans_id\",\"src_bank\",\"dest_bank\",\"src_curr\",\"dest_curr\",\"last_approved\",\"assigned_to\",\"update_time\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_all_completed_transaction() invoked", queryResults))
}

func (s *paymentContract) get_supported_currencies(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"fbank_addnl_curr\",\"bank_name\":\"%s\"}, \"fields\":[\"bank_name\",\"currency\"]}", bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_supported_currencies() invoked", queryResults))
}

func (s *paymentContract) get_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_name\":\"%s\"}, \"fields\":[\"supp_non_member_banks\"]}", bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_supported_non_member_banks() invoked", queryResults))
}

func (s *paymentContract) get_sponsor_bank(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"sponsor\"}, \"fields\":[\"bank_name\", \"bank_type\", \"bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "get_sponsor_bank() invoked", queryResults))
}

func (s *paymentContract) list_fbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "member_bank"  {
		return shim.Error("Failed to invoke list_fbanks() : Only Member Bank Allowed")
	}

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"fbank\"}, \"fields\":[\"bank_name\", \"bank_type\", \"bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "list_fbanks() invoked", queryResults))
}

func (s *paymentContract) list_mbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "member_bank"  {
		return shim.Error("Failed to invoke list_mbanks() : Only Member Bank Allowed")
	}

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"mbank\"}, \"fields\":[\"bank_name\", \"bank_type\", \"bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "list_mbanks() invoked", queryResults))
}

func (s *paymentContract) list_rbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "member_bank"  {
		return shim.Error("Failed to invoke list_rbanks() : Only Member Bank Allowed")
	}

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"rbank\"}, \"fields\":[\"bank_name\", \"bank_type\", \"bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "list_rbanks() invoked", queryResults))
}

func (s *paymentContract) show_bank_details(APIstub shim.ChaincodeStubInterface) peer.Response {

	// Invoke Access Check
	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "sponsor_bank" {
		return shim.Error("Failed Invoke show_bank_details() : Only Sponsor Bank can invoke.")
	} 

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\"}, \"fields\":[\"bank_name\", \"bank_id\", \"bank_type\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "show_bank_details() invoked", queryResults))
}

func (s *paymentContract) query_balance(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args, bank_name, currency.")
	}

	BankName := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])

	bankData := &fbank_addnl_curr{}
	bankIndex := BankName + Currency + "_forex"
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank not added. " + err.Error())
	}

	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	byteToJSON(bankDataJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "query_balance() invoked", bankDataJSONasBytes))
}

// Always needs to be done against INR, i.e 74.50 INR = 1 USD, then Exchange_rate = 74.50 
func (s *paymentContract) set_exchange_rate(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	// Invoke Access Check
	mspid, err := cid.GetMSPID(APIstub)
	if err != nil {
		return shim.Error("Failed to get MSPID for the peer calling it.")
	}

	if bank_type[mspid] != "sponsor_bank" {
		return shim.Error("Failed Invoke set_exchange_rate() : Only Sponsor Bank can invoke.")
	} 

	if len(args) != 3 {
		return shim.Error("Expecting 3 args, bank_name, currency, exchange_rate.")
	}

	BankName := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])
	Exchange_rate, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error Occured : " + err.Error())
	}

	bankData := &fbank_addnl_curr{}
	bankIndex := BankName + Currency + "_forex"
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank not added. " + err.Error())
	}

	err = json.Unmarshal(bankDataJSONasBytes, bankData)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankData.Exchange_rate = Exchange_rate
	bankDataJSONasBytes, _ = json.Marshal(bankData)

	err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(createResult(APIstub, CODESUCCESS, "set_exchange_rate() invoked", bankDataJSONasBytes))
}

func (s *paymentContract) transfer_money(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 5 {
		return shim.Error("Expecting atlest 5 args. src_bank, dest_bank, amount, src_curr, dest_curr.")
	}

	timestamp, _ := APIstub.GetTxTimestamp()

	fbank_list, err := get_csv_fbanks(APIstub)
	if err != nil {
		return shim.Error("Could not get fbank data : " + err.Error())
	}  

	rbank_list, err := get_csv_rbanks(APIstub)
	if err != nil {
		return shim.Error("Could not get rbank data : " + err.Error())
	}  

	Src_bank := strings.ToLower(args[0])
	Dest_bank := strings.ToLower(args[1])
	Src_curr := strings.ToLower(args[3])
	Dest_curr := strings.ToLower(args[4])
	
	Fbank := fbank_list[0] // Choosing the first bank that we get. MIght be buggy if bank peer is down.
	Rbank := rbank_list[0] // Choosing the first bank that we get. MIght be buggy if bank peer is down.

	Origin_timestamp := time.Unix(timestamp.GetSeconds(), 0).String()
	Trans_id := getMD5Hash(Src_bank + Dest_bank + Src_curr + Dest_curr + Origin_timestamp)
	ObjectType := "transaction"
	Amount, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error Occured : " + err.Error())
	}

	bankData := &fbank_addnl_curr{}
	bankIndex := Src_bank + Src_curr + "_forex"
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank not added. " + err.Error())
	}

	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	new_balance := 0.00
	if Src_curr == Dest_curr {
		new_balance = bankData.Balance - Amount 
	} else {
		new_balance = bankData.Balance - (Amount * bankData.Exchange_rate)
	}

	bankData.Balance = new_balance
	var transcJSONasBytes []byte

	if bankData.Balance >= 0 {

		// Add back updated balance entry.
		bankDataJSONasBytes, _ = json.Marshal(bankData)

		// Add back (rewrite) the data to fbank_addnl_curr table.
		err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
		if err != nil {
			return shim.Error(err.Error())
		}

		transcObj := &transaction{ObjectType, Origin_timestamp, Trans_id, Src_bank, Dest_bank, Amount, Src_curr, Dest_curr, Fbank, Rbank, Src_bank, Dest_bank, "mbank_submitted", Origin_timestamp}
		transcJSONasBytes, err = json.Marshal(transcObj)
		if err != nil {
			return shim.Error(err.Error())
		}

		dummy_transactions[Dest_bank] = append(dummy_transactions[Dest_bank], Trans_id)

		err = APIstub.PutState(Trans_id, transcJSONasBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
	} else {
		return shim.Error("Insufficient Balance Error.")
	}

	byteToJSON(transcJSONasBytes, 2)
	return shim.Success(createResult(APIstub, CODESUCCESS, "transfer_money() invoked", transcJSONasBytes))
}

func main() {
	err := shim.Start(new(paymentContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}

