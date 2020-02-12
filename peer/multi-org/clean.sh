# Cleans up the files generated during runs
killall peer  2> /dev/null

rm *.block   2> /dev/null
rm ./acme/*.block   2> /dev/null
rm ./budget/*.block  2> /dev/null

rm ./acme/*.log  2> /dev/null
rm ./budget/*.log  2> /dev/null

rm -rf /home/vagrant/ledgers/peer/multi-org/acme/*   2> /dev/null
rm -rf /home/vagrant/ledgers/peer/multi-org/budget/*  2> /dev/null