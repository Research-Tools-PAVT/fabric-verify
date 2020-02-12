# Cleans the setup
killall fabric-ca-server 2> /dev/null

rm -rf ./server/* 2> /dev/null

rm -rf ./client/* 2> /dev/null

echo "Removed all files under the ./client & ./server folder !!"