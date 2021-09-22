#!/bin/bash
echo "verifier mode."
CLEF_PWD=$1
TBNETWORK=$2
VERIFY_WALLET_ID=$3

if [ "$TBNETWORK" == "goerli" ]
then
    bash ./goerli_setup.sh $CLEF_PWD &
    GETH_IPC='/root/.ethereum/goerli/geth.ipc'
else
    bash ./main_setup.sh $CLEF_PWD &
    GETH_IPC='/root/.ethereum/geth.ipc'
fi
WALLET="${VERIFY_WALLET_ID:=0}"

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Verifier Mode on Wallet [$WALLET]"
./truebit-os -c "start verify -a $WALLET" --batch 2>> ~/logs/truebit-verify.log &
