echo '=====Generating temp/airline-genesis.json ======='
mkdir -p temp
configtxlator proto_decode --input airline-genesis.block --type common.Block > temp/airline-genesis.json

function usage {
    echo 'Policy Group NOT extracted.'
    echo 'To extract use:   ./gen-json.sh    channel_group | application | orderer | consortiums [sub-element]'
    exit 0;
}


if [ -z $1 ];
then
    usage
fi

case "$1" in 
    "channel_group")
                    JQPATH=".data.data[0].payload.data.config.channel_group"
                    ;;
    "application")
                    JQPATH=".data.data[0].payload.data.config.channel_group.groups.Application.groups"
                    ;;
    "acls")
                    JQPATH=".data.data[0].payload.data.config.channel_group.groups.Application.values.ACLs"
                    ;;
    "orderer")
                    JQPATH=".data.data[0].payload.data.config.channel_group.groups.Orderer"
                    ;;

    "consortiums")
                    JQPATH=".data.data[0].payload.data.config.channel_group.groups.Consortiums.groups"
                    ;;
    *)
        echo "Invalid group: $1"
        usage
        exit 1
esac

if [ -z $2 ];
then
    cat temp/airline-genesis.json | jq $JQPATH > ./temp/"$1.json"
    echo "===== Written  ./temp/$1.json========"
    exit
fi

JQPATH="$JQPATH.$2"

cat temp/airline-genesis.json | jq $JQPATH > ./temp/"$1.$2.json"
echo "===== Written  ./temp/$1.$2.json========"