#!/bin/bash

#STUPID SHIT
CLEF_PWD='password'

# Initialize Truebit toolchain for generating C/C++ tasks
#source /emsdk/emsdk_env.sh #(run this first)
sed -i "s|EMSCRIPTEN_NATIVE_OPTIMIZER = emsdk_path + '/fastcomp-clang/e1.37.36_64bit/optimizer'|EMSCRIPTEN_NATIVE_OPTIMIZER = ''|" /emsdk/.emscripten
sed -i "s|LLVM_ROOT = emsdk_path + '/fastcomp-clang/e1.37.36_64bit'|LLVM_ROOT = '/usr/bin'|" /emsdk/.emscripten

# Variables
CLEF_IPC='/root/.clef/clef.ipc'
GETH_IPC='/root/.ethereum/geth.ipc'

# Refresh Clef and Geth IPC sockets
rm $CLEF_IPC &>/dev/null
rm $GETH_IPC &>/dev/null

# Start IPFS
ipfs init &>/dev/null
tmux new -d 'ipfs daemon'

# Start Clef and Geth
GETH=$(echo 'geth --rpc --nousb --syncmode light --signer' $CLEF_IPC)
cat <<< $(jq '.geth.providerURL="/root/.ethereum/geth.ipc"' /truebit-eth/wasm-client/config.json) > /truebit-eth/wasm-client/config.json
CLEF_CMD='clef --advanced --nousb --chainid 5 --keystore ~/.ethereum/keystore --rules /truebit-eth/wasm-client/ruleset.js'
screen -d -m -S ClefSession bash -c "stty -echo; $CLEF_CMD"
sleep 10s
screen -S ClefSession -p 0 -X stuff "ok"
screen -S ClefSession -p 0 -X stuff "^M$CLEF_PWD^M"
until [ -S $CLEF_IPC ]; do sleep 1; done;
nohup $GETH 2>> ~/logs/geth_session.log &

