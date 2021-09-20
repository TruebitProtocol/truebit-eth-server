# docker build -t truebit-eth-server .
#
# YYY=$HOME'/truebit-docker'
# docker run --network host -v $YYY/docker-clef:/root/.clef \
#	-v $YYY/docker-geth:/root/.ethereum \
#	-v $YYY/docker-ipfs:/root/.ipfs \
#	-v $YYY/wasm-bin:/root/wasm-bin \
#   -e TBMODE=solver \
#   -e TBNETWORK=goerli \
#	--name truebit --rm -it truebit-eth-server:latest
#
# valid values for TBMODE are init, solver, or verifier. Bad or missing arg defaults to init.
# valid values for TBNETWORK are mainnet or goerli

FROM truebitprotocol/truebit-eth:latest
MAINTAINER truebit

# Get missing parts
RUN apt-get update && apt-get install -y dialog screen

# Move prebuilt WASM binaries into proper location.
ADD ./scripts /tbscripts

# Open IPFS and blockchain ports
EXPOSE 4001 8080 8545 8546 30303

CMD bash /tbscripts/start.sh