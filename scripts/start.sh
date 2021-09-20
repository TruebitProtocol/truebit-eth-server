#!/bin/bash
echo "Starting truebit-eth-server using $TBMODE mode."

# copy binaries from external volume to internal storage
bash /tbscripts/copy-binaries.sh

# examine env vars and run the proper start-up script
case "$TBMODE" in
    init)
        bash /tbscripts/init.sh
        ;;

    solver)
        bash /tbscripts/solver.sh
        ;;
    
    verifier)
        bash //tbscripts/verifier.sh
        ;;

    *)
        echo "No TBMODE environment variable found. Running interactive init mode."
        bash /tbscripts/init.sh
esac