package main

import (
	// "bytes"
	"encoding/json"
<<<<<<< HEAD:chaincode/dev/dump.go
	"strconv"
=======
	"encoding/hex"
	// "strconv"
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
	"time"
	"strings"
	"fmt"
	"crypto/x509"
	"crypto/x509/pkix"
	"math/big"
	"github.com/hyperledger/fabric-chaincode-go/shim"
<<<<<<< HEAD:chaincode/dev/dump.go
=======
	"github.com/TylerBrock/colorjson"
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
	// "github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

type crossPaymentContract struct {

}

<<<<<<< HEAD:chaincode/dev/dump.go
type Bank struct {
	ObjectType 			  string 	`json:"docType"`
	Bank_id               string 	`json:"Bank_id"`
	Bank_name             string 	`json:"Bank_name"`
	Bank_type             string 	`json:"bank_type"`
	Certificate      	  x509.Certificate `json:"Certificate"` // Can be MSP ID ? It is unique.
	Supp_non_member_banks string 	`json:"Supp_non_member_banks"` // parse the CSV later.
}

type Fbank_addnl_curr struct {
	ObjectType 		string  `json:"docType"`
	Bank_name		string  `json:"Bank_name"`
	Currency 		string  `json:"Currency"`
	Exchange_rate 	float64 `json:Exchange_rate`
	Balance 		float64 `json:Balance`
}

type Transaction struct {
	ObjectType 			string 	`json:"docType"`
	Origin_timestamp 	string 	`json:"Origin_timestamp"`
	Trans_id  			string  `json:"Trans_id"`
	Src_bank  			string  `json:"Src_bank"`
	Dest_bank 			string  `json:"Dest_bank"`
	Amount    			float64 `json:"Amount"`
	Src_curr  			string  `json:"Src_curr"`
	Dest_curr 			string  `json:"Dest_curr"`
	Fbank 				string  `json:"Fbank"`
	Rbank 				string  `json:"Rbank"`
	Last_approved 		string 	`json:"last_approved"`
	Assigned_to 		string 	`json:"Assigned_to"`
	Trans_status 		string 	`json:"Trans_status"`
	Update_timestamp 	string 	`json:"Update_timestamp"`
=======
type bank struct {
	ObjectType 			 string 	`json:"docType"`
	BankId               string 	`json:"bank_id"`
	BankName             string 	`json:"bank_name"`
	BankType             string 	`json:"bank_type"`
	SuppNonMemberBanks	 string 	`json:"supp_non_member_banks"`
	Certificate      	 x509.Certificate `json:"certificate"`
}

type errResponse struct {
	ErrCode 	int16 `json:err_code`
	ErrString	string `json:err_string`
}

func getMD5Hash(src string) string {
    hasher := md5.New()
    hasher.Write([]byte(src))
    return hex.EncodeToString(hasher.Sum(nil))
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
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

// Takes a []byte array of data and prints a colored json output
func prettyPrintJSON(data []byte, indent int8) error {
	
	var obj map[string]interface{}
	err := json.Unmarshal(data, &obj)
	if err != nil {
		fmt.Println("Marshal Error")
		return err
	}

	f := colorjson.NewFormatter()
    f.Indent = 2

    l, _ := f.Marshal(obj)
	fmt.Println(string(l))

	return nil
}

func (s *crossPaymentContract) Init(APIstub shim.ChaincodeStubInterface) peer.Response {
	return shim.Success(nil)
}

func (s *crossPaymentContract) Invoke(APIstub shim.ChaincodeStubInterface) peer.Response {

	function, args := APIstub.GetFunctionAndParameters()
	fmt.Println("Invoke is running : " + function)

	if function == "initChaincodePayment" {
		return s.initChaincodePayment(APIstub, args)
	// } else if function == "add_forex_currency" {
	// 	return s.add_forex_currency(APIstub, args)
	// } else if function == "allocate_funds" {
	// 	return s.allocate_funds(APIstub, args)
	} else if function == "create_bank" {
		return s.create_bank(APIstub, args)
	} else if function == "read_bank" {
		return s.read_bank(APIstub, args)
<<<<<<< HEAD:chaincode/dev/dump.go
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
	} else if function == "list_Fbanks" {
		return s.list_fbanks(APIstub)
	} else if function == "list_mbanks" {
		return s.list_mbanks(APIstub)
	} else if function == "list_rbanks" {
		return s.list_rbanks(APIstub)
	} else if function == "show_bank_details" {
		return s.show_bank_details(APIstub)
	} else if function == "query_Balance" {
		return s.query_balance(APIstub, args)
	} else if function == "set_Exchange_rate" {
		return s.set_exchange_rate(APIstub, args)
	} else if function == "transfer_money" {
		return s.transfer_money(APIstub, args)
=======
	// } else if function == "approve_transaction" {
	// 	return s.approve_transaction(APIstub, args)
	// } else if function == "get_completed_transaction" {
	// 	return s.get_completed_transaction(APIstub, args)
	// } else if function == "get_pending_transaction" {
	// 	return s.get_pending_transaction(APIstub, args)
	// } else if function == "get_supported_currencies" {
	// 	return s.get_supported_currencies(APIstub, args)
	// } else if function == "get_supported_non_member_banks" {
	// 	return s.get_supported_non_member_banks(APIstub, args)
	// } else if function == "list_fbanks" {
	// 	return s.list_fbanks(APIstub)
	// } else if function == "list_mbanks" {
	// 	return s.list_mbanks(APIstub)
	// } else if function == "list_rbanks" {
	// 	return s.list_rbanks(APIstub)
	// } else if function == "show_bank_details" {
	// 	return s.show_bank_details(APIstub)
	// } else if function == "query_balance" {
	// 	return s.query_balance(APIstub, args)
	// } else if function == "set_exchange_rate" {
	// 	return s.set_exchange_rate(APIstub, args)
	// } else if function == "transfer_money" {
	// 	return s.transfer_money(APIstub, args)
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
	} else if function == "say_hello" {
		return s.say_hello(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name : " + function)
}

func (s *crossPaymentContract) initChaincodePayment (APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

 	return shim.Success(nil)
}

<<<<<<< HEAD:chaincode/dev/dump.go
func (s *crossPaymentContract) add_forex_currency(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 3 {
		return shim.Error("Expecting 3 args Bank_name, Currency, Exchange_rate, optional(Balance)")
	}

	// Add fores Currency support and update Fbank_addnl_curr table.
	Bank_name := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])
	Exchange_rate, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error in " + args[2])
	}

	objectType := "Fbank_addnl_curr"
	Balance := 0.00

	if len(args) == 4 {
		Balance, err = strconv.ParseFloat(args[3], 64)
		if err != nil {
			return shim.Error("Parse Error in " + args[3])
		}
	}

	FbankObj := &Fbank_addnl_curr{objectType, Bank_name, Currency, Exchange_rate, Balance}

	FbankObjJSONasBytes, err := json.Marshal(FbankObj)
	if err != nil {
		return shim.Error(err.Error())
	}

	// Add to couchdb database.
	FbankObjName := Bank_name + Currency + "_forex"
	addFbankObj := APIstub.PutState(FbankObjName, FbankObjJSONasBytes)
	if addFbankObj != nil {
		return shim.Error(err.Error())
	}

	// Check if object really added.
	testObj, err := APIstub.GetState(FbankObjName)
	if err != nil {
			return shim.Error(err.Error())
	}
	testPrintErr := json.Unmarshal([]byte(testObj), FbankObj)
	if testPrintErr != nil {
			return shim.Error(err.Error())
	}
	fmt.Println(FbankObj)

	// TODO : To add support for a Currency and set exchange rate of the same against INR
	// Will need a couchdb database store and set_Exchange_rate().
	return shim.Success(nil)
}

func (s *crossPaymentContract) allocate_funds(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args Currency, Amount")
	}

	Currency := strings.ToLower(args[0])
	Amount, err := strconv.ParseFloat(args[1], 64)
	if err != nil {
		return shim.Error("Parse Float Error. " + args[1])
	}

	// Check if bank exists and forex entry available.
	Bank_name := "rbi" // Hard Coded Sponsor Bank, later we change to getSponsorBank()
	bankIndex := Bank_name + Currency + "_forex"
	bankData := &Fbank_addnl_curr{}

	// Get bank data to see if it already exists.
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		fmt.Println("Failed to fetch Fbank entry. " + Bank_name)
		return shim.Error(err.Error())
	} else if bankDataJSONasBytes == nil {
		fmt.Println("Adding new Fbank Entry. " + Bank_name)
		s.add_forex_currency(APIstub, []string{"rbi", Currency, "1.00", args[1]}) // initial Exchange_rate = 1.00 default
	}

	// Bank data already exists
	fmt.Println("Allocating funds to Sponsor Bank. " + Bank_name)
	// Get the fresh bank data.
	bankDataJSONasBytes, err = APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	// Modify Amount.
	Exchange_rate := bankData.Exchange_rate
	// old_Amount := bankData.Balance
	objectType := "Fbank_addnl_curr"

	bankData = &Fbank_addnl_curr{objectType, Bank_name, Currency, Exchange_rate, Amount}
	bankDataJSONasBytes, _ = json.Marshal(bankData)

	// Add back (rewrite) the data to Fbank_addnl_curr table.
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

	// TODO : To add Currency to Sponsor Bank
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func (s *crossPaymentContract) read_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting only name of the bank to query")
	}

	name := strings.ToLower(args[0])
	valAsbytes, err := APIstub.GetState(name)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + name + "\"}"
		return shim.Error(jsonResp)
	} else if valAsbytes == nil {
		jsonResp := "{\"Error\":\"Bank does not exist: " + name + "\"}"
		return shim.Error(jsonResp)
	}

	byteToJSON(valAsbytes, 2)
	return shim.Success(valAsbytes)
}

func (s *crossPaymentContract) create_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 2 {
		return shim.Error("Expecting 2. Bank_name, bank_type")
	}

	Bank_name := strings.ToLower(args[0])
	Bank_type := strings.ToLower(args[1])
	Bank_id := getMD5Hash(Bank_name + Bank_type)
	objectType := "bank"
	Supp_non_member_banks := "" // What to keep here initially?
	cert := getDummyCertificate() 

	// get Certificate details. Needs the peer to be running in the infrastructure.
	// cert, err := cid.GetX509Certificate(APIstub)
	// if err != nil {
	// 	return shim.Error(err.Error())
	// }

	// ObjectType 			  string 	`json:"docType"`
	// Bank_id               string 	`json:"Bank_id"`
	// Bank_name             string 	`json:"Bank_name"`
	// Bank_type             string 	`json:"bank_type"`
	// Certificate      	  *x509.Certificate `json:"certificate"` // Can be MSP ID ? It is unique.
	// Supp_non_member_banks string 	`json:"Supp_non_member_banks"` // parse the CSV later.

	// Create bank object.
	bankObj := &Bank{objectType, Bank_id, Bank_name, Bank_type, cert, Supp_non_member_banks}
	bankObjJSONasBytes, err := json.Marshal(bankObj)
=======
func (s *crossPaymentContract) say_hello(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	fmt.Println("Chaincode Installed and Initaited")
 	return shim.Success(nil)
}

// ======================================================
// Create Bank Data - create bank data in chaincode state
// ======================================================
func (s *crossPaymentContract) create_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	bankName := strings.ToLower(args[0])
	bankType := strings.ToLower(args[1])
	bankId := getMD5Hash(bankName + bankType)
	suppNonMemberBanks := "None"
	certificate := getDummyCertificate()  //  need to import real certificate later. 

	bankAsBytes, err := APIstub.GetState(bankName)
	if err != nil {
		return shim.Error("Failed to Query : " + err.Error())
	} else if bankAsBytes != nil {
		return shim.Error("This bank already exists : " + bankName)
	}

	objectType := "bankDoc"
	bank := &bank{objectType, bankId, bankName, bankType, suppNonMemberBanks, certificate}
	bankJSONasBytes, err := json.Marshal(bank)
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
	if err != nil {
		return shim.Error(err.Error())
	}

<<<<<<< HEAD:chaincode/dev/dump.go
	// Add bank to state.
	err = APIstub.PutState(Bank_name, bankObjJSONasBytes)
=======
	err = APIstub.PutState(bankName, bankJSONasBytes)
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

<<<<<<< HEAD:chaincode/dev/dump.go
func (s *crossPaymentContract) approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args, Bank_name, trans_id.")
	}

	// Get the transaction by index
	transcIndex := strings.ToLower(args[0]) + args[1] + "_trans"
	transcJSONasBytes, err := APIstub.GetState(transcIndex)
	if err != nil {
		return shim.Error(err.Error())
	} else if transcJSONasBytes == nil {
		return shim.Error("Transaction not found. " + err.Error())
	}

	// Modify the state
	transcObj := Transaction{}
	transcErr := json.Unmarshal(transcJSONasBytes, transcObj)
	if transcErr != nil {
		return shim.Error(err.Error())
	}

	// Update the new timestamp and approval status
	transcObj.Update_timestamp = time.Now().String()
	if transcObj.Dest_bank == args[0] {
		transcObj.Trans_status = "completed"
	}  else {
		transcObj.Trans_status = "pending"
	}
	transcObj.Last_approved = args[0] + "_approved"

	// Rewrite to the state.
	transcJSONasBytes, _ = json.Marshal(transcObj)
	putErr := APIstub.PutState(transcIndex, transcJSONasBytes)
	if putErr != nil {
		return shim.Error(err.Error())
	}
	// TODO : To add transactions table with new transaction.
	// Will need a couchdb database store.
	return shim.Success(nil)
}

func (s *crossPaymentContract) get_completed_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, Bank_name")
	}

	Bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"src_bank\":\"%s\",\"Trans_status\":\"%s\"}, \"fields\":[\"trans_id\"]}", Bank_name, "completed")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) get_pending_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, Bank_name")
	}

	Bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"transaction\",\"Assigned_to\":\"%s\",\"Trans_status\":\"%s\", \"fields\":[\"trans_id\"]}", Bank_name, "pending")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) get_supported_currencies(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, Bank_name")
	}

	Bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"Fbank_addnl_curr\",\"Bank_name\":\"%s\", \"fields\":[\"Currency\"]}", Bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) get_supported_non_member_banks(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, Bank_name")
	}

	Bank_name := strings.ToLower(args[0])
	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"Bank_name\":\"%s\", \"fields\":[\"Supp_non_member_banks\"]}", Bank_name)

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) list_fbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"Fbank\", \"fields\":[\"Bank_name\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) list_mbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"mbank\", \"fields\":[\"Bank_name\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) list_rbanks(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\",\"bank_type\":\"rbank\", \"fields\":[\"Bank_name\", \"Bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) show_bank_details(APIstub shim.ChaincodeStubInterface) peer.Response {

	queryString := fmt.Sprintf("{\"selector\":{\"docType\":\"banks\", \"fields\":[\"Bank_name\", \"Bank_id\"]}")

	queryResults, err := getQueryResultForQueryString(APIstub, queryString)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(queryResults)
}

func (s *crossPaymentContract) query_balance(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 2 {
		return shim.Error("Expecting 2 args, Bank_name, Currency.")
	}

	Bank_name := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])

	bankIndex := Bank_name + Currency + "_forex"
	bankData := &Fbank_addnl_curr{}

	// Get bank data to see if it already exists.
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch Fbank entry. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank not added. " + err.Error())
	}

	// Bank data already exists
	fmt.Println("Getting Balance for " + Bank_name)

	// fresh details
	bankDataJSONasBytes, err = APIstub.GetState(bankIndex)
	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	fmt.Println(bankData.Balance)
	return shim.Success(nil)
}

func (s *crossPaymentContract) set_exchange_rate(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 3 {
		return shim.Error("Expecting 3 args, Bank_name, Currency, Exchange_rate.")
	}

	Bank_name := strings.ToLower(args[0])
	Currency := strings.ToLower(args[1])
	Exchange_rate, parseErr := strconv.ParseFloat(args[2], 64)
	if parseErr != nil {
		return shim.Error("Parse Error Occured : " + parseErr.Error())
	}

	bankIndex := Bank_name + Currency + "_forex"
	bankData := &Fbank_addnl_curr{}

	// Get bank data to see if it already exists.
	bankDataJSONasBytes, err := APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error("Failed to fetch bank details. " + err.Error())
	} else if bankDataJSONasBytes == nil {
		return shim.Error("Bank not added. " + err.Error())
	}

	// Bank data already exists
	fmt.Println("Setting Exchange Rate. " + Bank_name + ", " + Currency)

	// Get the fresh bank data.
	bankDataJSONasBytes, err = APIstub.GetState(bankIndex)
	if err != nil {
		return shim.Error(err.Error())
	}

	bankErr := json.Unmarshal(bankDataJSONasBytes, bankData)
	if bankErr != nil {
		return shim.Error(err.Error())
	}

	// Modify Exchange_rate
	bankData.Exchange_rate = Exchange_rate
	bankDataJSONasBytes, _ = json.Marshal(bankData)

	// Add back (rewrite) the data to Fbank_addnl_curr table.
	err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

func (s *crossPaymentContract) transfer_money(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 5 {
		return shim.Error("Expecting atlest 5 args. src_bank, Dest_bank, Amount, Src_curr, dest_curr. ")
	}

	// Check needs to be added on what previous Balances were. Deduct the Amount and then continue transaction.
	Src_bank := strings.ToLower(args[0])
	Dest_bank := strings.ToLower(args[1])
	Src_curr := strings.ToLower(args[3])
	Dest_curr := strings.ToLower(args[4])
	Origin_timestamp := time.Now().String()
	Trans_id := getMD5Hash(Src_bank + Dest_bank + Src_curr + Dest_curr + Origin_timestamp)
	objectType := "transaction"
	Amount, parseErr := strconv.ParseFloat(args[2], 64)
	if parseErr != nil {
		return shim.Error("Parse Error Occured : " + parseErr.Error())
	}


	bankIndex := Src_bank + Dest_curr + "_forex"
	bankData := &Fbank_addnl_curr{}

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

	current_Balance := bankData.Balance
	new_Balance := current_Balance - Amount
	bankData.Balance = new_Balance

	if new_Balance > 0 {

		// Add back updated Balance entry.
		bankDataJSONasBytes, _ = json.Marshal(bankData)

		// Add back (rewrite) the data to Fbank_addnl_curr table.
		err = APIstub.PutState(bankIndex, bankDataJSONasBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
		// Add a new transactions. But need to check if transaction already exists. // TODO : Check if transaction id already exists or got completed.
		// ObjectType 			string 	`json:"docType"`
		// Origin_timestamp 	string 	`json:"origin_time"`
		// Trans_id  			string  `json:"trans_id"`
		// Src_bank  			string  `json:"src_bank"`
		// Dest_bank 			string  `json:"Dest_bank"`
		// Amount    			float64 `json:"Amount"`
		// Src_curr  			string  `json:"Src_curr"`
		// Dest_curr 			string  `json:"dest_curr"`
		transcObj := &Transaction{objectType, Origin_timestamp, Trans_id, Src_bank, Dest_bank, Amount, Src_curr, Dest_curr, "", "", "", "", "", ""}
		transcJSONasBytes, err := json.Marshal(transcObj)
		if err != nil {
			return shim.Error(err.Error())
		}

		err = APIstub.PutState(Trans_id, transcJSONasBytes)
		if err != nil {
			return shim.Error(err.Error())
		}
	} else {
		return shim.Error("Insufficient Balance Error.")
	}

	return shim.Success(nil)
=======
// ======================================================
// Read Bank Data - read a bank data from chaincode state
// ======================================================
func (s *crossPaymentContract) read_bank(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Incorrect number of arguments. Expecting only name of the bank to query")
	}

	name := strings.ToLower(args[0])
	valAsbytes, err := APIstub.GetState(name)
	if err != nil {
		jsonResp := "{\"Error\":\"Failed to get state for " + name + "\"}"
		return shim.Error(jsonResp)
	} else if valAsbytes == nil {
		jsonResp := "{\"Error\":\"Bank does not exist: " + name + "\"}"
		return shim.Error(jsonResp)
	}

	prettyPrintJSON(valAsbytes, 2)
	return shim.Success(valAsbytes)
>>>>>>> master:chaincode/cross-payment/crossborderpayment.go
}

func main() {
	err := shim.Start(new(crossPaymentContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
