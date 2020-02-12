# Sets up the initail set of identities

# 1. Start the CA Server
./server.sh start
echo "====> 1. Starting server "
# 2. Sleep for 3 seconds - give time for server to start up
#    Increase this if needed
SLEEP_TIME=3s
echo "====> 2. Sleeping for $SLEEP_TIME "
sleep $SLEEP_TIME

# 3. Enroll the 
./server.sh enroll
echo "====> 3. Enrolled Bootstrap Identity"

# 4. Enroll Org admin
./register-enroll-admins.sh
echo "====> 4. Enrolled Admin Identities  (Orderer, Acme, Budget)"

# 5. Setup MSP for Orgs
./setup-org-msp.sh acme
./setup-org-msp.sh orderer
./setup-org-msp.sh budget

echo "====> 5. Completed MSP setup for orgs (Orderer, Acme, Budget)"

echo "$0 PLEASE - Go through the logs above to ensure there are NO errors!!!"

