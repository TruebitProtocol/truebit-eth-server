FROM truebitprotocol/truebit-eth:latest
MAINTAINER truebit

# Get missing parts
RUN apt-get update && apt-get install -y dialog screen

# Move prebuilt WASM binaries into proper location.
ADD ./scripts /tbscripts

# Open IPFS and blockchain ports
EXPOSE 4001 8080 8545 8546 30303

CMD bash /tbscripts/start.sh