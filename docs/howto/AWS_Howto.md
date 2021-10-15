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

# Installing truebit-eth-server
 Follow the guide on using [Ubuntu Linux](./ubuntu_howto.md) for truebit-eth-server