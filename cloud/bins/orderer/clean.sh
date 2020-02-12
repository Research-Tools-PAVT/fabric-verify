# To be added to the VM on the cloud
# Copy it to /usr/local/bin

rm ~/*.block        2> /dev/null
rm ~/*.tx           2> /dev/null
rm ~/*.tar          2> /dev/null

rm -rf ~/ledger     2> /dev/null

rm -rf orgs-msp     2> /dev/null
rm -rf orderer-msp  2> /dev/null

echo "Done."