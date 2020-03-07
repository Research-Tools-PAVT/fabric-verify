killall orderer  2> /dev/null

rm -rf $HOME/ledgers/orderer/multi-bank/ledger
rm ./trace/*  2> /dev/null
rm -rf ./temp  2> /dev/null
rm -rf ./crypto-config 2> /dev/null

if [ -z $1 ];
then
    echo 'Deleted the ledger data and crypto-config'
    exit 0;
fi