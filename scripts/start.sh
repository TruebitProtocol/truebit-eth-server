#!/bin/bash
echo "Starting truebit-eth-server using $TBMODE mode on $TBNETWORK."

# examine env vars and run the proper start-up script
case "$TBMODE" in
    init)
        bash /tbscripts/init.sh
        ;;

    solver)
        bash /tbscripts/solver.sh "$TBPASS" "$TBNETWORK"
        ;;
    
    verifier)
        bash /tbscripts/verifier.sh "$TBPASS" "$TBNETWORK"
        ;;

    *)
        echo "No valid TBMODE environment variable found. Running interactive init mode."
        bash /tbscripts/init.sh
esac