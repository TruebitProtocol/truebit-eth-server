# Running truebit-eth-server in the AWS Cloud
This how-to document describes provisioning a new Amazon Web Services (AWS) virtual machine, installing, configuring, and running the truebit-eth-server platform as a Solver or Verifier. This documentation assumes you are running on the Goerli test network, but the instructions are the same for mainnet use, with the exception of the TBNETWORK parameter passed to truebit-eth-server. This guide assumes the reader has an existing Amazon Web Services account and is experienced in provisioning and running EC2 server instances using Ubuntu Linux. 

If you are unfamiliar with AWS or the EC2 service, please review [Amazon's EC2 Getting Started Guide](https://aws.amazon.com/ec2/getting-started/).

## Overview
The process involves the following high level operations:
  * Provision a new EC2 server instance running Ubuntu 20.04
  * Update existing software and install missing tools like Docker
  * For small EC2 instances, enable swap space
  * Download and build the truebit-eth-server Docker image
  * Run and configure truebit-eth-server interactively
  * Re-launch truebit-eth server as a service 

## Provision an EC2 Instance
truebit-eth-server will run in a properly configured "free tier" AWS EC2 instance, such as a t2.micro instance. Since this instance type has as little as one gigabyte of RAM and only a single processor core, performance will be limited and you will need to perform additional configuration steps to operate truebit-eth-server with such restricted resources.

*Minimum Configuration*
  * 1 processor core
  * 1 gigabyte of RAM
  * 16 gigabytes of SSD storage

*Preferred Configuration*
  * 2+ processor cores
  * 2+ gigabytes of RAM
  * 24+ gigabytes of SSD storage

When configuring the new EC2 instance, start by selecting the standard Ubuntu 20.04 AMI (Amazon Machine Image) and configure according to the specifications above. Take care to use an existing key pair that you already have generated, or create a new one and save and download the key pair, as you will be configuring the new running instance via multiple SSH terminal sessions from your local computer.

Once the new EC2 instance is created and running, connect to the instance using the "Connect" menu reached by right-clicking the instance in the EC2 dashboard and following the instructions.

## Update Existing Software and Install Docker
Execute the following commands after connecting to the running EC2 instance:

Update existing Ubuntu software:
```
sudo apt update
sudo apt upgrade
```
Install Docker software and add ubuntu user as a Docker user:
```
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ${USER}
```
*NOTE:* If you are using a smaller EC2 instance (e.g., t2.micro), enable swap space on the new instance with the following commands:
```
sudo fallocate -l 2G /swapfile
sudo dd if=/dev/zero of=/swapfile bs=1024 count=2097152
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```
If you created a swapfile using the commands above, you must modify the /etc/fstab config file to utilize swap on reboot:
```
sudo vi /etc/fstab
```
and add the following line to the end of /etc/fstab:
```
/swapfile swap swap defaults 0 0
```
Confirm that swap is enabled with the following:
```
sudo swapon --show
```
Download the truebit-eth-server distribution from Github and build the Docker image:
```
git clone https://github.com/TruebitProtocol/truebit-eth-server.git
cd truebit-eth-server/
docker build -t truebit-eth-server .
```
Now you can launch the truebit-eth-server Docker image *interactively* to begin the configuration process:
```
YYY=$HOME'/truebit-docker'
docker run --network host -v $YYY/docker-clef:/root/.clef -v $YYY/docker-geth:/root/.ethereum -v $YYY/docker-ipfs:/root/.ipfs \
    --name truebit --rm -it truebit-eth-server:latest /bin/bash
```
You should follow the "Quick Start" instructions for configuring a new Truebit installation using the [truebit-eth documentation](https://github.com/TruebitProtocol/truebit-eth#initializing-accounts) and starting with the "Initializing Accounts" section.

## Restarting and Running truebit-eth-server as a Solver or Verifier
Once the initial configuration of geth and clef are complete and you've purchased or transfered ETH and TRU tokens to your wallet, you are ready to restart truebit-eth server as a solver or verifier. Exit from the running truebit-eth-server (control-C twice to quit truebit-os and log out of the container with exit or control-D). Once at the Ubuntu command prompt, stop the running Docker image with:
```
docker stop truebit
```
Now you want to relaunch the Docker image with the necessary command line to run truebit-eth-server as either a solver or verifier. Refer to the [truebit-eth-server documentation](https://github.com/TruebitProtocol/truebit-eth-server) and use a command like:
```
YYY=$HOME'/truebit-docker'
docker run --network host -v $YYY/docker-clef:/root/.clef -v $YYY/docker-geth:/root/.ethereum -v $YYY/docker-ipfs:/root/.ipfs \
-e TBMODE=solver \
-e TBNETWORK=goerli \
-e TBPASS=clefpasswd \
-e TBWALLET=0 \
--name truebit --restart -d -it truebit-eth-server:latest
```
Note that you will need to supply the appropriate TBMODE, TBNETWORK, and TBPASS arguments. Also note that this image is launched with the "--restart" flag. That means that if you reboot your EC2 instance, truebit-eth-server will automatically restart and resume solving or verifying. Note that if you delete the EC2 instance, you will need to repeat this entire guide to re-configure a new EC2 instance.

To confirm truebit-eth-server is operating as expected, you can issue the following command from the Ubuntu command line to examine the truebit-os logs:
```
docker logs truebit
```
## Help or Problems?
If you encounter issues specific to running truebit-eth-server, please post questions on the Truebit Discord channel. If there are errors or corrections needed for this document or other truebit-eth-server components, please log them as issues on this project's Github repository.
