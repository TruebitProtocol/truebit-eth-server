# Deploying truebit-eth-server on Ubuntu Linux
The following should work on:
* Ubuntu 20.04 and higher

Prerequisites:
* sudo access (Administrator privileges)

## Update Existing Software and Install Docker
Execute the following commands in the terminal of your machine.

Update existing Ubuntu software:
```sh
# Update existing Ubuntu software
sudo sh -c 'apt-get update && apt-get dist-upgrade -y'

# Install Docker software and add ubuntu user as a Docker user:
sudo sh -c 'curl -fsSL https://get.docker.com | sh && usermod -aG docker ${USER}'
```

**NOTE:** For servers with **1GB** memory (or less), enable swap space on the new instance with the following commands:
```sh
# Create new swapfile and activate it
sudo fallocate -l 2G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile


# Insert swapfile entry in fstab if not exists
sed -i '$! s/^\/swapfile[\t ]//; $s/\(^\/swapfile.*\)\?$/\n\/swapfile swap swap defaults 0 0/' /etc/fstab

# Confirm that swap is created successfully. Should looks similar to following:
# NAME      TYPE SIZE USED PRIO
# /swapfile file   2G 268K   -2
sudo swapon --show
```

## Setting up truebit-eth-server
```sh
# Building truebit-eth-server
docker build -t truebitprotocol/eth-server https://github.com/TruebitProtocol/truebit-eth-server.git#main

# Running truebit-eth-server
TP_MOUNTPOINT=$HOME'/truebit-docker'
docker run \
--network host \
--name truebit-eth-server \
-v $TP_MOUNTPOINT/docker-clef:/root/.clef \
-v $TP_MOUNTPOINT/docker-geth:/root/.ethereum \
-v $TP_MOUNTPOINT/docker-ipfs:/root/.ipfs \
--rm \
-it \
truebitprotocol/eth-server:latest /bin/bash
```
You should follow the "Quick Start" instructions for configuring a new Truebit installation using the [truebit-eth documentation](https://github.com/TruebitProtocol/truebit-eth#initializing-accounts) and starting with the "Initializing Accounts" section.

## Restarting and Running truebit-eth-server as a Solver or Verifier
Once the initial configuration of geth and clef are complete and you've purchased or transfered ETH and TRU tokens to your wallet, you are ready to restart truebit-eth server as a solver or verifier. Exit from the running truebit-eth-server (control-C twice to quit truebit-os and log out of the container with exit or control-D). Once at the Ubuntu command prompt, stop the running Docker image with:
```sh
docker stop truebit-eth-server
```
Now you want to relaunch the Docker image with the necessary command line to run truebit-eth-server as either a solver or verifier. Refer to the [truebit-eth-server documentation](https://github.com/TruebitProtocol/truebit-eth-server) and use a command like:
```sh
TP_MOUNTPOINT=$HOME'/truebit-docker'
docker run \
--network host \
-v $TP_MOUNTPOINT/docker-clef:/root/.clef \
-v $TP_MOUNTPOINT/docker-geth:/root/.ethereum \
-v $TP_MOUNTPOINT/docker-ipfs:/root/.ipfs \
-e TBMODE=solver \
-e TBNETWORK=goerli \
-e TBPASS=clefpasswd \
-e TBWALLET=0 \
--name truebit \
--restart \
-d \
-it \
truebitprotocol/eth-server:latest
```
Note that you will need to supply the appropriate TBMODE, TBNETWORK, and TBPASS arguments. Also note that this image is launched with the "--restart" flag. That means that if you reboot your machine, truebit-eth-server will automatically restart and resume solving or verifying.

To confirm truebit-eth-server is operating as expected, you can issue the following command from the Ubuntu command line to examine the truebit-os logs:
```
docker logs truebit-eth-server
```
## Help or Problems?
If you encounter issues specific to running truebit-eth-server, please post questions on the Truebit Discord channel. If there are errors or corrections needed for this document or other truebit-eth-server components, please log them as issues on this project's Github repository.
