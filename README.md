## <a name='init'>Fabric Verify</a>

Formal Verification of Hyperledger Fabric Chaincode.

### [[⬆]](#init) <a name='setup'>Testing Setup</a>

We deployed the whole setup in a single VM Host. Modified & Adapted from [Build Your First Network](https://hyperledger-fabric.readthedocs.io/en/release-2.0/build_network.html). 
It runs the ```cross-payment``` chaincode. 

### [[⬆]](#init) <a name='explorer'>Hyperledger Explorer</a>

Run ```docker-compose-explorer.yaml``` in ```test-net``` folder after the e2e fabric netowrk is setup. Open [Hyperledger Explorer Local](http://localhost:8090/#/). 
Refer to ```commands.sh``` file in ```test-net``` folder for starting network. 

```
$ cd test-net
$ sudo docker-compose -f docker-compose-explorer.yaml up -d
```

### [[⬆]](#init) <a name='preview'>Explorer Preview</a>

![Hyperledger-base](https://github.com/codersguild/fabric-verify/blob/master/assets/sample.png)

![Hyperledger-txn](https://github.com/codersguild/fabric-verify/blob/master/assets/txn.png) 

### [[⬆]](#init) <a name='setup_all'>Set Up Details</a>

```
Working Dir : test-net
```

Install the hyperledger pre-requisites.

* [Getting Started](https://hyperledger-fabric.readthedocs.io/en/release-2.0/getting_started.html)

First Install these dependencies. This includes ```git```, ```curl```, ```wget```, ```golang```,```docker``` & ```docker-compose```.
We assume that you will be using ```golang``` as the primary language for developing the chaincode.

* [Pre-requisite Installs](https://hyperledger-fabric.readthedocs.io/en/release-2.0/prereqs.html)

Next we install the hyperledger binaries and the docker images.

* [Install Samples, Binaries and Docker Images](https://hyperledger-fabric.readthedocs.io/en/release-2.0/install.html)

Check if the dependcies have been met. Shown below is an output for the versions installed in the setup. Setup the ```GOPATH``` appropriately.

* [Setting GOPATH](https://github.com/golang/go/wiki/SettingGOPATH)

* [USING GO11MODULE](https://dev.to/maelvls/why-is-go111module-everywhere-and-everything-about-go-modules-24k)

```bash
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
### [[⬆]](#init) <a name='dockerimages'>Check Docker Images</a>

The following docker images are needed to test out the whole setup. The images tagged ```latest``` were used in the testing setup.

```bash
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

### [[⬆]](#init) <a name='scenario'>Setup Scenario</a>

* 3 Organizations (Org1, Org2, Org3) : ICICI, HDFC, BOA.
* 2 Peers per Organization (peer0, peer1) : 1 Anchor Peer, 1 Admin Peer, 1 Leader Peer.
* 1 Payment Blockchain channel : payzchannel.
* 1 CA per Organization.
* 5 Orderers using RAFT Consensus Protocol.
* 6 CouchDB DBs one for each peer in the blockchain.
* 2 Fabric CLI Containers for invoke and query commands. 

### [[⬆]](#init) <a name='commands'>Commands</a>

Run from the ```test-net``` directory on a separete ```terminal```. This will setup and deploy the containers needed to deploy the above architecture.

```bash
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker volume prune
docker network prune
docker rmi $(docker images | grep dev-peer0 | awk '{print $3}')

./byfn.sh generate -c payzchannel -s couchdb -a
sudo ./byfn.sh up -c payzchannel -s couchdb -a
./eyfn.sh generate -c payzchannel -s couchdb 
sudo ./eyfn.sh up -c payzchannel -s couchdb

sudo docker-compose -f docker-compose-explorer.yaml up -d
docker exec -it cli bash 
```
* Quick Start : 

```
$ cd ./test-net
$ yes | ./start.sh
```

* Test Run : 

```
$ cd ./chaincode/cross-payment/
$ sudo GO11MODULE=on go mod vendor
$ sudo go test
```

* To Run the invoke and query commands, use the ```invoke_commands.sh``` file in the ```test-net``` folder. 

```
$ docker exec -it cli bash 
```

* To add commands, add new commands in dump.in and then run the following. 

```
$ ./assemble.sh > invoke_commands.sh
$ cp ./invoke_commands.sh ../
```

* Quick Deploy : 

```
$ yes | sudo ./dev.sh deploy -q <seq_number_next_build>
```

Now issue the commands in ```commands.sh``` file in the bash terminal of ```cli``` container.

### [[⬆]](#init) <a name='couchdbexplore'>CouchDB Explorer</a>

Open [Project Fauxon](http://localhost:5984/_utils/#/_all_dbs)

CouchDB Queries and rich statement queries are working as intended. 

![CouchDB-1](https://github.com/codersguild/fabric-verify/blob/master/assets/couchdb1.png)

![CouchDB-2](https://github.com/codersguild/fabric-verify/blob/master/assets/couchdb2.png)

### [[⬆]](#init) <a name='services'>Services Running</a>

```bash 
➜  test-net docker ps -a

CONTAINER ID        IMAGE                                                                                                                                                                     COMMAND                  CREATED             STATUS              PORTS                                         NAMES
bb4eafb59271        hyperledger/explorer:latest                                                                                                                                               "sh -c 'sleep 25 && …"   33 minutes ago      Up 33 minutes       0.0.0.0:8090->8080/tcp                        explorer.payznet.com
cd4193ca46f2        hyperledger/explorer-db:latest                                                                                                                                            "docker-entrypoint.s…"   33 minutes ago      Up 33 minutes       5432/tcp                                      explorerdb.payznet.com
fb209e531380        prom/prometheus:latest                                                                                                                                                    "/bin/prometheus --c…"   33 minutes ago      Up 33 minutes       0.0.0.0:9090->9090/tcp                        proms
b5aa220cedf8        grafana/grafana:latest                                                                                                                                                    "/run.sh"                33 minutes ago      Up 33 minutes       0.0.0.0:3000->3000/tcp                        grafana
1230a02726de        dev-peer0.org3.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-290a0739d4828aaaeb664e99cea1c8193e0d2d959f4baffc651b21e79f8614ca   "chaincode -peer.add…"   35 minutes ago      Up 35 minutes                                                     dev-peer0.org3.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
e9b58eab525d        dev-peer1.org3.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-338090bcac57ffb8bed5b580e23dcc491dc753682240bc665a9e08e74d862853   "chaincode -peer.add…"   35 minutes ago      Up 35 minutes                                                     dev-peer1.org3.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
3d6035d26d9e        hyperledger/fabric-tools:latest                                                                                                                                           "/bin/bash"              35 minutes ago      Up 35 minutes                                                     Org3cli
ce81661a9495        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        35 minutes ago      Up 35 minutes       7051/tcp, 0.0.0.0:11051->11051/tcp            peer0.org3.payzchain.com
f3cd763ee532        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        35 minutes ago      Up 35 minutes       7051/tcp, 0.0.0.0:12051->12051/tcp            peer1.org3.payzchain.com
727480f99a50        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   35 minutes ago      Up 35 minutes       4369/tcp, 9100/tcp, 0.0.0.0:9984->5984/tcp    couchdb4
cf3dc18a52d2        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   35 minutes ago      Up 35 minutes       4369/tcp, 9100/tcp, 0.0.0.0:10984->5984/tcp   couchdb5
d83826891c21        dev-peer1.org2.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-39f1b0f6801df64fe3025f821e913a0175268b35d616c2c8dd21a314d9090cb6   "chaincode -peer.add…"   35 minutes ago      Up 35 minutes                                                     dev-peer1.org2.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
01dbdc8d19de        dev-peer1.org1.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-b63ce4f50559282ea84aecae49c73f0f20f1079770305254cebd8241b4c8afb5   "chaincode -peer.add…"   35 minutes ago      Up 35 minutes                                                     dev-peer1.org1.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
9a19cc7e278e        dev-peer0.org2.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-630a071eeb837503c4024eb8bc9423d892e9d53417a48e3cdbed0fd0b1b0c2c5   "chaincode -peer.add…"   36 minutes ago      Up 36 minutes                                                     dev-peer0.org2.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
5bce2a61c539        dev-peer0.org1.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491-92ee2c563937c911a1d1407a5865851e3b8cc9e547c50b8184d4fd8b856e04ba   "chaincode -peer.add…"   36 minutes ago      Up 36 minutes                                                     dev-peer0.org1.payzchain.com-payzcc_1-7e01a7571430e4b424a491de465516f19df87eaa085a59155b3c5857a1c3a491
557cb13c71aa        hyperledger/fabric-tools:latest                                                                                                                                           "/bin/bash"              37 minutes ago      Up 37 minutes                                                     cli
113d765e4f1d        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        37 minutes ago      Up 37 minutes       7051/tcp, 0.0.0.0:9051->9051/tcp              peer0.org2.payzchain.com
717c6df53302        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        37 minutes ago      Up 37 minutes       7051/tcp, 0.0.0.0:8051->8051/tcp              peer1.org1.payzchain.com
b7be763c0b7b        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        37 minutes ago      Up 37 minutes       0.0.0.0:7051->7051/tcp                        peer0.org1.payzchain.com
031b76965866        hyperledger/fabric-peer:latest                                                                                                                                            "peer node start"        37 minutes ago      Up 37 minutes       7051/tcp, 0.0.0.0:10051->10051/tcp            peer1.org2.payzchain.com
7d7581302012        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   37 minutes ago      Up 37 minutes       4369/tcp, 9100/tcp, 0.0.0.0:5984->5984/tcp    couchdb0
afdb296caff9        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   37 minutes ago      Up 37 minutes       4369/tcp, 9100/tcp, 0.0.0.0:8984->5984/tcp    couchdb3
a47eed3a3253        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   37 minutes ago      Up 37 minutes       4369/tcp, 9100/tcp, 0.0.0.0:7984->5984/tcp    couchdb2
d853601e1307        hyperledger/fabric-orderer:latest                                                                                                                                         "orderer"                37 minutes ago      Up 37 minutes       7050/tcp, 0.0.0.0:9050->9050/tcp              orderer3.payzchain.com
ffca3ef20b2d        hyperledger/fabric-orderer:latest                                                                                                                                         "orderer"                37 minutes ago      Up 37 minutes       0.0.0.0:7050->7050/tcp                        orderer.payzchain.com
b364d1b5ccc9        hyperledger/fabric-orderer:latest                                                                                                                                         "orderer"                37 minutes ago      Up 37 minutes       7050/tcp, 0.0.0.0:11050->11050/tcp            orderer5.payzchain.com
1bce747ee323        hyperledger/fabric-ca:latest                                                                                                                                              "sh -c 'fabric-ca-se…"   37 minutes ago      Up 37 minutes       0.0.0.0:7054->7054/tcp                        ca_peerOrg1
c5766837f3e2        hyperledger/fabric-orderer:latest                                                                                                                                         "orderer"                37 minutes ago      Up 37 minutes       7050/tcp, 0.0.0.0:10050->10050/tcp            orderer4.payzchain.com
7db1956901bc        hyperledger/fabric-orderer:latest                                                                                                                                         "orderer"                37 minutes ago      Up 37 minutes       7050/tcp, 0.0.0.0:8050->8050/tcp              orderer2.payzchain.com
9cf1fbf2bb38        hyperledger/fabric-ca:latest                                                                                                                                              "sh -c 'fabric-ca-se…"   37 minutes ago      Up 37 minutes       7054/tcp, 0.0.0.0:8054->8054/tcp              ca_peerOrg2
58388d845762        couchdb:2.3                                                                                                                                                               "tini -- /docker-ent…"   37 minutes ago      Up 37 minutes       4369/tcp, 9100/tcp, 0.0.0.0:6984->5984/tcp    couchdb1


```
