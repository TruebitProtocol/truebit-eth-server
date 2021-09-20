#!/bin/bash
echo "solver mode."

if [[ "$TBNETWORK" == "goerli"]]; then
    bash ./goerli_setup.sh &
    GETH_IPC='/root/.ethereum/goerli/geth.ipc'
else
    bash ./main_setup.sh &
    GETH_IPC='/root/.ethereum/geth.ipc'
fi
WALLET=${SOLVER_WALLET_ID:=0}

echo "Waiting for GETH IPC to Exist..."
until [ -S $GETH_IPC ]; do sleep 1; done
cd /truebit-eth
echo "Starting TrueBit-OS In Solver mode"
./truebit-os -c 'start solve -a $WALLET' --batch 2>> ~/logs/truebit-solver.log &
