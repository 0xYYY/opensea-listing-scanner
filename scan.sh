#!/usr/bin/env bash

RARIBLE_API="https://ethereum-api.rarible.org/v0.1/order/orders/sell/byMakerAndByStatus"

# Put your RPC node endpoint here
RPC="RPC_URL"

# Set parameters of the NFT collection you want to scan
# Using "Forgotten Runes Wizards Cult" as an example
COLLECTION_NAME="frogotten_runes"
CONTRACT_ADDRESS="0x521f9C7505005CFA19A8E5786a9c3c9c9F5e6f42"
MAX_SUPPLY=10000

echo "[RPC] $RPC"
echo
echo "[Collection] $COLLECTION_NAME"
echo "[Contract Address] $CONTRACT_ADDRESS"
echo "[Max Supply] $MAX_SUPPLY"
echo

# Get owner list
echo "[-] Collecting owner list"
OWNER_LIST=${COLLECTION_NAME}_owners.txt
for i in $(seq $MAX_SUPPLY); do
    owner=$(cast call $CONTRACT_ADDRESS "ownerOf(uint256)(address)" $i --rpc-url $RPC 2>/dev/null)
    if [ $? -eq 0 ]; then
        echo "[-] Token #${i} owner: $owner"
        echo $owner >>$OWNER_LIST
    else
        echo "[!] Token #${i} doesn't exist"
    fi
done
echo
# Remove duplicate
sort $OWNER_LIST --uniq --output $OWNER_LIST

# Scan listings
echo "[-] Scanning listings"
OUTPUT_PATH=${COLLECTION_NAME}_listings.csv
echo "tokenId,owner,price" >$OUTPUT_PATH
for owner in $(cat $OWNER_LIST); do
    # Scan for the owner's listings on OpenSea using Rarible API
    # and filter the result with CONTRACT_ADDRESS
    echo "[-] Scanning listings from $owner"
    base_url="${RARIBLE_API}?maker=${owner}&platform=OPEN_SEA&status=ACTIVE"
    url=$base_url
    while
        response=$(curl -s $url)
        echo $response | jq '.orders[] | [.make.assetType.tokenId, .maker, .take.valueDecimal, .make.assetType.contract] | @csv' |
            rg -i $CONTRACT_ADDRESS |
            xsv select 1-3 2>/dev/null |
            sd '["\\]' '' |
            tee -a $OUTPUT_PATH

        # If there is a continuation string, continue scanning, else break
        continue=$(echo $response | jq 'has("continuation")')
        continuation_string=$(echo $response | jq '.continuation')
        url="${base_url}&continuation=${continuation_string}"
        [ "$cointinue" = "true" ]
    do :; done
done

# Sort by price
xsv sort --select price --numeric $OUTPUT_PATH --output $OUTPUT_PATH
