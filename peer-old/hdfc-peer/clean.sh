# clean.sh                   Cleans up the storage folder only
# clean.sh  all              Cleans up storage, generated files + copies over default YAML

source ./env.sh

# Clears the peer folder
rm -rf ledger 2> /dev/null
rm -rf $CORE_PEER_FILESYSTEMPATH 2> /dev/null

# Remove any package files
rm *.out 2> /dev/null

if [ -z $1 ];
then
    echo 'Deleted the ledger data only.'
    echo 'To delete all artifacts use:  ./clean.sh  all'
    exit 0;
fi

# Location of the default core.yaml
CORE_YAML_DEFAULT=$PWD/../../setup/config/simple-two-org/core.0/core.yaml

if [ $1 = 'all' ] 
then
    rm *.block 2> /dev/null
    rm *.tx 2> /dev/null
    rm -rf crypto-config 2> /dev/null

    echo 'Deleted all artifacts.'

    cp  $CORE_YAML_DEFAULT  .

    echo '====Copied default core.yaml '
else
    echo 'Deleted the ledger data only.'
    echo 'To delete all artifacts use:  ./clean.sh  all'
fi

# At this time the script does not CLEAN the CouchDB if it is in use
# User should manually delete the database _acmechannel