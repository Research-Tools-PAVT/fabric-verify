# FIRST TIME MUST call with 'all' as argument
# If 'all' not passed then crypto not regenrated

rm -rf temp
rm  -rf ./artefacts/*

#1 Check if all was passed
if [ ! -z $1 ]; then
    if [ $1 == "all" ]; then
        #1. Generate the crypto
        echo "====> Generating the crypto-config"
        rm -rf crypto-config
        cryptogen generate --config=./crypto-config.yaml
    fi
else
    echo 'Use ./gen-crypto.sh   all      to regenerate the crypto'
fi

echo    "====> Generating : Organization MSPs : orgs-msp.tar"
#2 Generate the orgs-msp.tar
rm -rf temp/orgs-msp
mkdir -p ./temp/orgs-msp/orderer
cp -R crypto-config/ordererOrganizations/acme.com/msp    temp/orgs-msp/orderer/msp
mkdir -p temp/orgs-msp/acme
cp -R crypto-config/peerOrganizations/acme.com/msp    temp/orgs-msp/acme/msp
mkdir -p temp/orgs-msp/budget
cp -R crypto-config/peerOrganizations/budget.com/msp    temp/orgs-msp/budget/msp 
# Create the orgs-msp tar file
cd temp
tar -c orgs-msp -f ../artefacts/orgs-msp.tar
cd ../

#3 Generate the orderer-msp.tar
echo   "====> Generating : Orderer MSP : orderer-msp.tar"
mkdir -p temp/orderer-msp
cp -R crypto-config/ordererOrganizations/acme.com/orderers/orderer.acme.com/msp  temp/orderer-msp
cd temp
tar -c orderer-msp -f ../artefacts/orderer-msp.tar
cd ../

#4 Generate the acme-msp.tar
echo   "====> Generating : Acme MSP : acme-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/acme.com/peers/devpeer/msp                     temp/msps/peer
cp -R crypto-config/peerOrganizations/acme.com/users/Admin@acme.com/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/acme.com/users/User1@acme.com/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/acme-msp.tar
cd ../
rm -rf temp/msps/**

#5 Generate the budget-msp.tar
echo   "====> Generating : Budget MSP : budget-msp.tar"
mkdir -p temp/msps
cp -R crypto-config/peerOrganizations/budget.com/peers/devpeer/msp                       temp/msps/peer
cp -R crypto-config/peerOrganizations/budget.com/users/Admin@budget.com/msp              temp/msps/admin
cp -R crypto-config/peerOrganizations/budget.com/users/User1@budget.com/msp              temp/msps/user1
cd temp
tar -c msps -f ../artefacts/budget-msp.tar
cd ../
rm -rf temp/msps/*



