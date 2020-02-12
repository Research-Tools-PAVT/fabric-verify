# Generates the genesis & airline channel

./clean.sh
echo "====>Cleaned"

./generate-genesis.sh
echo "====>Generated Genesis"

./generate-channel-tx.sh
echo "====>Generated Channel Transacton"

./launch.sh
