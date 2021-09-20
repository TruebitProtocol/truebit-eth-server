#!/bin/bash
echo "verifier mode."

if [[ "$TBNETWORK" == "goerli"]]; then
    bash ./goerli_setup.sh &
    GETH_IPC='/root/.ethereum/goerli/geth.ipc'
else
    bash ./main_setup.sh &
    GETH_IPC='/root/.ethereum/geth.ipc'
fi
WALLET=${VERIFY_WALLET_ID:=0}

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Verifier Mode..."
./truebit-os -c 'start verify -a $WALLET' --batch 2>> ~/logs/truebit-verify.log &
