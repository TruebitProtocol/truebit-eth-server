#!/bin/bash
echo "verifier mode."

bash ./goerli_setup.sh &

WALLET=${SOLVER_WALLET_ID:=0}

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 0.1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Verifier Mode..."
./truebit-os -c 'start solve -a $WALLET' --batch 2>> ~/logs/truebit-solver.log &
