### Testing Setup : 

We deployed the whole setup in a single VM Host. Modified & Adapted from [Build Your First Network](https://hyperledger-fabric.readthedocs.io/en/release-2.0/build_network.html)

Install the hyperledger pre-requisites.

* [Getting Started](https://hyperledger-fabric.readthedocs.io/en/release-2.0/getting_started.html)

First Install these dependencies. This includes ```git```, ```curl```, ```wget```, ```golang```,```docker``` & ```docker-compose```. 
We assume that you will be using ```golang``` as the primary language for developing the chaincode. 

* [Pre-requisite Installs](https://hyperledger-fabric.readthedocs.io/en/release-2.0/prereqs.html)

Next we install the hyperledger binaries and the docker images. 

* [Install Samples, Binaries and Docker Images](https://hyperledger-fabric.readthedocs.io/en/release-2.0/install.html)

Check if the dependcies have been met. Shown below is an output for the versions installed in the setup. Setup the ```GOPATH``` appropriately. 

* [Setting GOPATH](https://github.com/golang/go/wiki/SettingGOPATH)

```
➜  ~ git --version
git version 2.20.1

➜  ~ go version
go version go1.12.10 linux/amd64

➜  ~ node -v
v12.13.1

➜  ~ npm -v
6.12.1

➜  ~ python --version
Python 2.7.17

➜  ~ python3 --version
Python 3.7.5

➜  ~ pip --version
pip 19.2.3 from /usr/local/lib/python2.7/dist-packages/pip (python 2.7)

➜  ~ pip3 --version
pip 18.1 from /usr/lib/python3/dist-packages/pip (python 3.7)

➜  ~ curl --version
curl 7.65.3 (x86_64-pc-linux-gnu) libcurl/7.65.3 OpenSSL/1.1.1c zlib/1.2.11 libidn2/2.2.0 libpsl/0.20.2 (+libidn2/2.0.5) libssh/0.9.0/openssl/zlib nghttp2/1.39.2 librtmp/2.3
Release-Date: 2019-07-19
Protocols: dict file ftp ftps gopher http https imap imaps ldap ldaps pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps telnet tftp 
Features: AsynchDNS GSS-API HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM NTLM_WB PSL SPNEGO SSL TLS-SRP UnixSockets


➜  ~ wget --version
GNU Wget 1.20.3 built on linux-gnu.

-cares +digest -gpgme +https +ipv6 +iri +large-file -metalink +nls 
+ntlm +opie +psl +ssl/openssl 

Wgetrc: 
    /etc/wgetrc (system)
Locale: 
    /usr/share/locale 
Compile: 
    gcc -DHAVE_CONFIG_H -DSYSTEM_WGETRC="/etc/wgetrc" 
    -DLOCALEDIR="/usr/share/locale" -I. -I../../src -I../lib 
    -I../../lib -Wdate-time -D_FORTIFY_SOURCE=2 -DHAVE_LIBSSL -DNDEBUG 
    -g -O2 -fdebug-prefix-map=/build/wget-OYIfr9/wget-1.20.3=. 
    -fstack-protector-strong -Wformat -Werror=format-security 
    -DNO_SSLv2 -D_FILE_OFFSET_BITS=64 -g -Wall 
Link: 
    gcc -DHAVE_LIBSSL -DNDEBUG -g -O2 
    -fdebug-prefix-map=/build/wget-OYIfr9/wget-1.20.3=. 
    -fstack-protector-strong -Wformat -Werror=format-security 
    -DNO_SSLv2 -D_FILE_OFFSET_BITS=64 -g -Wall -Wl,-Bsymbolic-functions 
    -Wl,-z,relro -Wl,-z,now -lpcre2-8 -luuid -lidn2 -lssl -lcrypto -lz 
    -lpsl ftp-opie.o openssl.o http-ntlm.o ../lib/libgnu.a 

Copyright (C) 2015 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later
<http://www.gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Originally written by Hrvoje Niksic <hniksic@xemacs.org>.
Please send bug reports and questions to <bug-wget@gnu.org>.


➜  ~ gcc --version
gcc (Ubuntu 9.2.1-9ubuntu2) 9.2.1 20191008
Copyright (C) 2019 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

➜  ~ docker --version
Docker version 19.03.3, build a872fc2f86

➜  ~ docker-compose --version
docker-compose version 1.25.3, build d4d1b42b

```
### Check Docker Images : 

The following docker images are needed to test out the whole setup. The images tagged ```latest``` were used in the testing setup. 

```
couchdb                         2.3                 23350347cb48        3 weeks ago         201MB
hyperledger/fabric-ca           1.4                 3b96a893c1e4        3 weeks ago         150MB
hyperledger/fabric-ca           1.4.6               3b96a893c1e4        3 weeks ago         150MB
hyperledger/fabric-ca           latest              3b96a893c1e4        3 weeks ago         150MB
hyperledger/fabric-tools        2.0                 639ab50feac9        7 weeks ago         514MB
hyperledger/fabric-tools        2.0.0               639ab50feac9        7 weeks ago         514MB
hyperledger/fabric-tools        latest              639ab50feac9        7 weeks ago         514MB
hyperledger/fabric-peer         2.0                 5f8a6b13db9f        7 weeks ago         57.2MB
hyperledger/fabric-peer         2.0.0               5f8a6b13db9f        7 weeks ago         57.2MB
hyperledger/fabric-peer         latest              5f8a6b13db9f        7 weeks ago         57.2MB
hyperledger/fabric-orderer      2.0                 161632cc3c59        7 weeks ago         39.7MB
hyperledger/fabric-orderer      2.0.0               161632cc3c59        7 weeks ago         39.7MB
hyperledger/fabric-orderer      latest              161632cc3c59        7 weeks ago         39.7MB
hyperledger/fabric-ccenv        2.0                 6514ca872b68        7 weeks ago         529MB
hyperledger/fabric-ccenv        2.0.0               6514ca872b68        7 weeks ago         529MB
hyperledger/fabric-ccenv        latest              6514ca872b68        7 weeks ago         529MB
hyperledger/fabric-baseos       2.0                 50075bc26291        7 weeks ago         6.9MB
hyperledger/fabric-baseos       2.0.0               50075bc26291        7 weeks ago         6.9MB
hyperledger/fabric-baseos       latest              50075bc26291        7 weeks ago         6.9MB
hyperledger/fabric-javaenv      2.0                 ac433f4353e4        8 weeks ago         507MB
hyperledger/fabric-javaenv      2.0.0               ac433f4353e4        8 weeks ago         507MB
hyperledger/fabric-javaenv      latest              ac433f4353e4        8 weeks ago         507MB
hyperledger/fabric-nodeenv      2.0                 c7fe428889ec        2 months ago        274MB
hyperledger/fabric-nodeenv      2.0.0               c7fe428889ec        2 months ago        274MB
hyperledger/fabric-nodeenv      latest              c7fe428889ec        2 months ago        274MB
hyperledger/fabric-zookeeper    0.4                 ede9389347db        4 months ago        276MB
hyperledger/fabric-zookeeper    0.4.18              ede9389347db        4 months ago        276MB
hyperledger/fabric-zookeeper    latest              ede9389347db        4 months ago        276MB
hyperledger/fabric-kafka        0.4                 caaae0474ef2        4 months ago        270MB
hyperledger/fabric-kafka        0.4.18              caaae0474ef2        4 months ago        270MB
hyperledger/fabric-kafka        latest              caaae0474ef2        4 months ago        270MB
hyperledger/fabric-couchdb      0.4                 d369d4eaa0fd        4 months ago        261MB
hyperledger/fabric-couchdb      0.4.18              d369d4eaa0fd        4 months ago        261MB
hyperledger/fabric-couchdb      latest              d369d4eaa0fd        4 months ago        261MB
hyperledger/fabric-orderer      1.4.2               362021998003        8 months ago        173MB
hyperledger/fabric-peer         1.4.2               d79f2f4f3257        8 months ago        178MB
couchdb                         2.2.0               269ffb1d6de0        17 months ago       252MB
```

### Setup Scenario

* 3 Organizations (Org1, Org2, Org3) : ICICI, HDFC, BOA
* 2 Peers per Organization (peer0, peer1) : 1 Anchor Peer, 1 Admin Peer, 1 Leader Peer. 
* 1 Payment Blockchain channel : payzchain
* 1 CA per Organization. 
* 5 Orderers using RAFT Consensus Protocol 
* 6 CouchDB DBs one for each peer in the blockchain.


### Commands : 

```
$ docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
$ docker volume prune
$ ./byfn.sh generate
$ ./byfn.sh up -s couchdb -l golang -c payzchannel
```

### Network-Only Deployment : 

```
$ cryptogen generate --config=./crypto-config.yaml
$ export FABRIC_CFG_PATH=$PWD
$ configtxgen -profile SampleMultiNodeEtcdRaft -channelID byfn-sys-channel -outputBlock ./channel-artifacts/genesis.block
```

```
$ export CHANNEL_NAME=mychannel 
$ configtxgen -profile TwoOrgsChannel -outputCreateChannelTx ./channel-artifacts/channel.tx -channelID $CHANNEL_NAME
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org1MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org1MSP
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org2MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org2MSP
$ configtxgen -profile TwoOrgsChannel -outputAnchorPeersUpdate ./channel-artifacts/Org3MSPanchors.tx -channelID $CHANNEL_NAME -asOrg Org3MSP
```

```
$ docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
$ docker volume prune
```

```
$ export BYFN_CA1_PRIVATE_KEY=priv_sk
$ export BYFN_CA2_PRIVATE_KEY=priv_sk
$ export BYFN_CA3_PRIVATE_KEY=priv_sk
docker-compose -f docker-compose-cli.yaml -f docker-compose-etcdraft2.yaml -f docker-compose-couch.yaml -f docker-compose-ca.yaml up -d
```

### Endorsement Policy : 

```
2020-03-24 16:57:04.867 UTC [msp.identity] Sign -> DEBU 02c Sign: digest: C25F45E1B1AEDBAD1A9759B2E34522F0D20059738588A148E04DCB6AA49EE5DC 
{
	"approvals": {
		"Org1MSP": true,
		"Org2MSP": true,
		"Org3MSP": true
	}
}

```

### Chaincode Commit Issue : 

* [Chaincode is not installed(consistent) in lifecycle feature](https://jira.hyperledger.org/browse/FAB-15501) 