#!/bin/bash

NODE1_IP="128.110.217.124"
NODE2_IP="128.110.217.94"
NODE3_IP="128.110.217.229"

KEYS=("key1" "key2" "key3")

for KEY in "${KEYS[@]}"; do
    SLOT=$(redis-cli -c -h $NODE1_IP -p 6379 cluster keyslot $KEY)
    echo "Key: $KEY is in slot: $SLOT"
    
    if [ $SLOT -le 5460 ]; then
        NODE=$NODE1_IP
    elif [ $SLOT -le 10922 ]; then
        NODE=$NODE2_IP
    else
        NODE=$NODE3_IP
    fi
    
    echo "Key: $KEY is stored on node: $NODE"
done

