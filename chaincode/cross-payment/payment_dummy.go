package main

import (
	"fmt"
	"encoding/json"
	"strconv"
	"strings"
	"time"
	"github.com/hyperledger/fabric-chaincode-go/shim"
	peer "github.com/hyperledger/fabric-protos-go/peer"
)

func (s *paymentContract) automate_approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

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

	// Approve each valid transaction
	for trans_index := range params {
		if(params[trans_index] != "null") {
			s.approve_transaction(APIstub, []string{bank_name, params[trans_index]})
			params[trans_index] = "null"
		}
	}
	
	return shim.Success(nil)
}

func (s *paymentContract) dummy_approve_transaction(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) != 1 {
		return shim.Error("Expecting 1 args, bank_name")
	}

	bank_name := strings.ToLower(args[0])

	// Approve each valid transaction
	for trans_index := range dummy_transactions[bank_name] {
		if (dummy_transactions[bank_name][trans_index] != "null") {
			new_args := []string{bank_name, dummy_transactions[bank_name][trans_index]}
			s.approve_transaction(APIstub, new_args)
			dummy_transactions[bank_name][trans_index] = "null"
		}
	}
	
	return shim.Success(nil)
}

func (s *paymentContract) dummy_transfer_money(APIstub shim.ChaincodeStubInterface, args []string) peer.Response {

	if len(args) < 5 {
		return shim.Error("Expecting atlest 5 args. src_bank, dest_bank, amount, src_curr, dest_curr")
	}

	timestamp, _ := APIstub.GetTxTimestamp()

	Src_bank := strings.ToLower(args[0])
	Dest_bank := strings.ToLower(args[1])
	Src_curr := strings.ToLower(args[3])
	Dest_curr := strings.ToLower(args[4])
	
	Fbank := "hsbc" // dummy values
	Rbank := "boa" // dummy values

	Origin_timestamp := time.Unix(timestamp.GetSeconds(), 0).String()
	Trans_id := getMD5Hash(Src_bank + Dest_bank + Src_curr + Dest_curr + Origin_timestamp)
	ObjectType := "transaction"
	Amount, err := strconv.ParseFloat(args[2], 64)
	if err != nil {
		return shim.Error("Parse Error Occured : " + err.Error())
	}

	bankData := &fbank_addnl_curr{}
	bankIndex := "null"
	var transcJSONasBytes []byte
	new_balance := 0.00

	if Src_curr == Dest_curr {
		bankIndex = Src_bank + Src_curr + "_forex"
	} else {
		bankIndex = Src_bank + Dest_curr + "_forex"
	}

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

	new_balance = bankData.Balance - (Amount * bankData.Exchange_rate)
	bankData.Balance = new_balance

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