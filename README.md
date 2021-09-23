# What is truebit-eth-server?
This is a Dockerfile and associated scripts to add some quality of life functionality to the standard truebit-eth Docker image. Where truebit-eth is designed to be an interactive tool for learning about and using the Truebit protocol, truebit-eth-server is designed to provide 100% of the functionality of truebit-eth, plus additional functions that make it much easier to run Truebit in a server or headless environment.

truebit-eth-server provides a better way to participate in the Truebit network as a solver or verifier, using a turnkey, appliance-like set-up. This repository is primarily intended to disclose the internals of the truebit-eth-server Docker image. However, it may be useful for those who have specific server applications that need to adjust Truebit behavior to integrate better with those applications.

## IMPORTANT NOTE
**truebit-eth-server and the associated documentation here are not a substitute for using information in the Truebitprotocol/truebit-eth project
to configure a new Truebit instance. Information here is for power users who understand Docker, microservices, Truebit, and server operations. If you are just getting started with Truebit, please start with the information contained in the truebit-eth repository first.**

# Getting Started with truebit-eth-server
As mentioned, truebit-eth-server is a wrapper of services around the existing truebit-eth Docker image. As such, it must be configured and made ready to run in server mode. In order to do that, you should follow the existing truebit-eth "getting started" instructions, which will provide step-by-step guidance to configure Truebit, tokens, wallets, and tasks in preparation for participating in the Truebit network of task givers, solvers, and verifiers. If you have set up and run truebit-eth already, you may skip directly to the "Building the truebit-eth-server Docker image".

## Building the truebit-eth-server Docker image
Start by pulling this repository from Github. From inside the truebit-eth-server directory, use Docker to build the new image:
```
docker build -t truebit-eth-server .
```
This process will automatically pull the latest truebit-eth image from Docker and add appropiate support for server operations to it, resulting in a new image called truebit-eth-server.

# Running truebit-eth-server as a Server

The default truebit-eth and truebit-eth-server Docker images are designed to be run interactively. However, this is unsuitable for unattended operations, such as running a Truebit solver or verifier in a cloud deployment, or on dedicated server hardware. The truebit-eth-server Docker image includes command line flags and associated scripts that allow it to be run as a dedicated Truebit solver or verifier without human intervention.

By providing an "appliance-like" behavior for Truebit developers, truebit-eth-server makes it possible to integrate the Truebit protocol into services that cooperate with on-chain resources to provide robust, up all the time Truebit nodes that can be restarted automatically and run without the need for human intervention.

To run truebit-eth-server as a dedicated solver or verifier, you need to have run through the "quickstart" guide above and have a configured wallet and other settings necessary to run the stack interactively. But instead of launching truebit-eth-server as above, you will specify different arguments for the TBMODE environment variable, and also provide the password necessary to unlock the clef key store in the TBPASS environment variable.

## Launching as a Stand-Alone Solver or Verifier Server

After having configured a truebit-eth-server installation using the Quickstart instructions from truebit-eth, stop the container by exiting from the shell prompt (control-D or exit) and restart the container using the commands below. Be sure to provide appropriate values for the environment variables TBMODE, TBNETWORK, TBWALLET, and TBPASS.

  * Legal values for TBMODE are init, solver, or verifier. Default is init.
  * Legal values for TBNETWORK are mainnet or goerli. Default is goerli.
  * Legal values for TBWALLET are numbers 0-n, which correspond to the wallet/account ID in clef and truebit-os. Defaults to 0
  * The value of TBPASS should be set by an appropriate method to maintain privacy/security of that value (e.g., stty -echo, etc.)

The following example demonstrates launching truebit-eth-server as a solver on the goerli test network. Modify environment variable values accordingly for mainnet operations or to function as a verifier.

```bash
YYY=$HOME'/truebit-docker'
docker run --network host -v $YYY/docker-clef:/root/.clef -v $YYY/docker-geth:/root/.ethereum -v $YYY/docker-ipfs:/root/.ipfs \
-e TBMODE=solver \
-e TBNETWORK=goerli \
-e TBPASS=clefpasswd \
-e TBWALLET=0 \
--name truebit --rm -d -it truebitprotocol/truebit-eth-server:latest
```

Once launched, the -d option will detach the running Truebit Docker container from your interactive terminal session, where it will continue to run in the background. See Docker documentation for additional command line arguments, such as --restart, to allow for automated restart on power failure or reboot, or to mount external volumes for hosting binary tasks and metadata.

# truebit-eth-server FAQ
## When should I use truebit-eth vs. truebit-eth-server?
truebit-eth is designed as an interactive environment for configuring, managing, and learning about the Truebit protocol and its runtime environment. truebit-eth-server is 100% compatible with truebit-eth, plus it adds extra script support for running as a server process. So if you have a need to run Truebit solvers or verifiers in a production environment, as an unattended server, or as a platform that may need to restart and resume unattended operations, you should use truebit-eth-server

## Why do I have to build it myself?
While truebit-eth-server is appropriate for a wide variety of use cases, there may be applications that require customization of the various scripts and parameters, or need specific integrations with other non-Truebit software. Because we cannot anticipate the wide variety of use cases, it's easiest to provide full access to all of the truebit-eth-server internals so that power users can build or enhance it as needed for their projects.

## How can I hide my clef password?
In order to start in unattended server mode, truebit-eth-server needs to start clef internally and give it authorization to sign Truebit transactions. That means providing clef with the password to its internal key store. There are several ways to pass this password information on the Docker command like that will avoid having it show as clear text in logs, command buffers, etc. The simplest is to manually set an environment variable that will hold the password while disabling terminal echo. Something like:
```
stty -echo
mypass=secretclefpassword
stty echo
docker run.... -e TBPASS=$mypass
```
In this example, the stty command turns off the echoing of keystrokes to the display, allowing you to assign the password to an intermediate variable which can then be used with the Docker command. You are encouraged to reset or delete the local environment variable (mypass in this example) after starting the Docker process. (e.g., mypass="")

## Why is truebit-eth-server being made available?
This version of the truebit-eth stack is the first of several developer community-focused tools and resources being provided by Truebit. Providing a widely available, appliance like version of the Truebit protocol will help grow the number of nodes on the network, increase transaction volume, and give software developers a more robust way to integrate Truebit into their DeFi, Dapp, and cloud applications. This is the first of many community-focused tools, tutorials, and sample tasks aimed at helping developers understand how to build on the Truebit protocol and integrate it into a wide variety of applications.

## Can I make changes to truebit-eth-server?
If you've downloaded a copy of truebit-eth-server from this repository, you are free to make changes to the contents of this repository according to the terms of its license agreement. Please note that this license only covers the contents of the truebit-eth-server Github repository. If you have changes you would like to contribute to this project, please make an appropriate pull request. If it is an enhancement of sufficiently general usefulness and helps improve truebit-eth-server, we look forward to incorporating your contributions.