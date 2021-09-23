#!/bin/bash
echo "verifier mode."
CLEF_PWD=$1
TBNETWORK=$2
VERIFY_WALLET_ID=$3

if [ "$TBNETWORK" == "mainnet" ]
then
    bash /tbscripts/mainnet_setup.sh $CLEF_PWD &
    GETH_IPC='/root/.ethereum/geth.ipc'
else
    bash /tbscripts/goerli_setup.sh $CLEF_PWD &
    GETH_IPC='/root/.ethereum/goerli/geth.ipc'
fi
WALLET="${VERIFY_WALLET_ID:=0}"

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Verifier Mode on Wallet [$WALLET]"
sleep 10s ; ./truebit-os -c "start verify -a $WALLET"
