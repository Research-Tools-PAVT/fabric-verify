#1 Pre-Requisites checklist
- Have a cloud account (AWS, Azure, IBM, Google .....)
- On host machine have the SCP & SSH tools
- Comfortable with cloud VM & Network setup

#2 Create the VPC
- For simplicity my network will allow all inbound/outbound traffic
- Setup security such that access is allowed to appropriate ports on each EC2
- Use Private IP address if you do not have fixed IP (elastic IP)

#3 Setup crypto material
This would ideally be managed by way of the Certification Authority *but* since
our focus is on setting the cloud infrastructure we will use cryptogen. You are welcome to use the Fabric CA server.
> gen-crypto.sh all

#4 Setup the Cloud VMs
Set up the VM
Consideration - VM for peers may be added at a later stage by way of updates
Set the configtx.yaml - update the IP address of Orderer & Peers (you may use private IP)

Update the cloud/peer/set-env.sh with orderer IP addres

Update the cloud/set-env.sh with Public IP address of peers for Acme/Budger/Expo -  we will use it for testing from local VM

#4 Setup Orderer & Network Artefacts (Genesis, Create channel tx)
1. Setup the VM (EC2, t2.micro)
2. Setup the Genesis & Channel tx (local machine)
    - Copy the IP address of the orderer VM to configtx.yaml
      Orderer.Addresses
         - IP Address of Orderer
    > gen-genesis-channeltx.sh
2. Copy the files to the VM
    - fabric-tools/bin/orderer
    - cloud/artefacts/orderer-msp.tar
    - cloud/artefacts/airline-genesis.block
    - cloud/bins/orderer/*
3. Move the orderer binary to /usr/local/bin
> chmod 755 orderer
> sudo mv orderer /usr/local/bin
> orderer version
4. Untar the ./orderer-msp.tar
> tar xvf orderer-msp.tar
5. Launch the orderer
    - Log into the EC2 instance
    - chmod 755 *.sh
    - Execute the script launch script
    > ./launch.sh &
    > ps -e | grep orderer
    - Validate the log messages
6. Update "cloud/peer/set-env.sh"
    - Copy the Orderer VM's  IP Address and paste it in ./set-env.sh

#6 Setup Peer for Acme
1. Setup the VM (EC2, t2.micro)
2. Copy the files to the VM
    - fabric-tools/bin/peer
    - cloud/bins/peer/*
    - cloud/artefacts/acme-msp.tar
    - cloud/artefacts/airline-channel.tx    [Needed only for ACME]

   
3. Setup the ACME peer
    - Move the peer binary to /usr/local/bin
    > chmod 755 peer
    > sudo mv peer /usr/local/bin

    - Setup docker
    > chmod 755 *.sh
    > sudo ./docker.sh

    - Logout & Log back into VM
    > docker version
4. Update MSP ID in "set-env.sh" on VM for Peer
    > nano set-env.sh
5. Setup the crypto
    > tar xvf acme-msp.tar
6. As admin Create the channel  (Need to be done only once on any peer)
    - Submit the channel create tx
    > chmod 755 set-env.sh 
    > . set-env.sh  acme
    > ./create-airline-channel.sh
7. Launch the Peer
    - Set the environment
    > . set-env.sh
    > ./launch.sh &
    > peer channel list
8. Join the channel
    - Set the environment
    > ./join-airlinechannel.sh

9. Testing with Chaincode
    - Local VM will be used for connecting with different peers
    - 



Quick Cleanup e.g., due to new Public IP Address
================================================
1. Generate the network artefacts
    - Reset the configtx.yaml IP address
    - Update the cloud/peer/set-env.sh
    - Update the cloud/set-env.sh
    - Generate the genesis | create channel tx
2. Orderer cleanup
    - Copy the genesis block
    - Kill the orderer
    - Clean up the ledger
    - Launch the orderer
3. Peer clean up - do this for all peers
    - Kill the peer
    - Clean up the ledger
    - Creating the channel - needed only on 1 of the peers
        - Copy overt the Channel Create Tx file
        - Create the airline channel
    - Launch the peer
    - Join the peer to the channel
