package main

import (
	// "bytes"
	"encoding/json"
	"encoding/hex"
	// "strconv"
	"time"
	"strings"
	"fmt"
	"crypto/md5"
	"crypto/x509"
	"crypto/x509/pkix"
	"math/big"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	"github.com/TylerBrock/colorjson"
	// "github.com/hyperledger/fabric-chaincode-go/pkg/cid"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

type crossPaymentContract struct {

}

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
	} else if function == "say_hello" {
		return s.say_hello(APIstub, args)
	}

	return shim.Error("Invalid Smart Contract function name : " + function)
}

func (s *crossPaymentContract) initChaincodePayment (APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

 	return shim.Success(nil)
}

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
	if err != nil {
		return shim.Error(err.Error())
	}

	err = APIstub.PutState(bankName, bankJSONasBytes)
	if err != nil {
		return shim.Error(err.Error())
	}

	return shim.Success(nil)
}

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
}

func main() {
	err := shim.Start(new(crossPaymentContract))
	if err != nil {
		fmt.Printf("Error creating new Smart Contract: %s", err)
	}
}
