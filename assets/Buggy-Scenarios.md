1. Incorrect money transfer :

set_exchange_rate() gives some error or buggy implementation of
transfer_money() can lead to a scenario where the exact amount deducted at
the source bank is not credited to the next bank in line properly.
Eg : 1000 INR deducted at ICICI but only 800 INR worth USD transferred to
HSBC for Forex conversion.
Reason : Possible buggy implementation of updation of account balances.

2. Failure to choose correct fbank/rbank causing delays :

We get a list of possible forex banks or routing banks but only choose the
first bank or the last bank in the list. That bank peer may be
unresponsive, which can appear to be a DoS. We must check if peer bank is
active.
Reason : Peer Down and not DoS actually.

3. Failure of a transaction :

transfer_money() function deducts money at source bank but
approve_transaction() functions fails due to some reason where the
updation of balance doesn't occur at the destination bank.
Reason : Peer Unresponsive or approve_transaction() has a buggy
implementation.

We go for transaction roll back. One way can be to maintain transactions
as a doubly linked list. Each transaction stores the trans_id of the
previous transaction and the next transaction (updated when a new
transaction occurs). We maintain an invariant that amount is always
deducted at the source and credited at the destination bank. We traverse
this list and undo the related transactions. Complexity wont exceed order
of forex + routing banks.

4. Order of Approve Transaction :

A bug in the automated scenario of the approve_transaction() can be that a
bank tries to transfer money that has not yet been credited. Insufficient
balance error occurs in that case albeit the source bank has already
transferred the money.
Eg : 1000 INR transferred by ICICI to HSBC for Forex conversion. HSBC
tries to transfer 1000 INR woth USD to BOA bank but since it has not
approved the transaction yet, the deduction at HSBC fails because the
balance is negative after deduction.
Reason : Buggy approve_transaction() or not maintaining the invariant,
that a bank must approve pending transactions before invoking
transfer_money() to initiate transfer. Proper ordering of transactions
needed.

Also it might happen that approve_transaction() only takes the first
transaction for approval and not all.
Secondly if an approved transaction is not removed from the pending queue,
double spends are possible.

5. Non-Interference from other bank peers/ transactions :

This can happen if the ordering of the approve_transaction() and
transfer_money() is such that a dependency is created where a transaction
from ICICI bank is not approved due to a pending approve_transaction() for
a non related bank, which was not initially a part of the transaction.
We must check that approve_transaction(), get_pending_transactions() &
transfer_money() are implemented and invoked in a way that such
interference doesn't occur.

6. Error in Endorsement Policy :
   Deployment level issues where endorsement policy is not specified in a
   correct way or due to some misconfiguration the endorsement fails for a
   few peer banks.
