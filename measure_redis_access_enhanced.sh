#!/bin/bash

NODE1_IP="128.110.217.124"

# Insert data using cluster mode
echo "Inserting data..."
redis-cli -c -h $NODE1_IP -p 6379 set key1 value1
redis-cli -c -h $NODE1_IP -p 6379 set key2 value2
redis-cli -c -h $NODE1_IP -p 6379 set key3 value3

# Function to measure access time
measure_access_time() {
    local key=$1
    local total_time=0
    local count=5

    for i in $(seq 1 $count); do
        local time=$( (time redis-cli -c -h $NODE1_IP -p 6379 get $key) 2>&1 | grep real | awk '{print $2}' | cut -dm -f2 | cut -ds -f1 )
        total_time=$(echo $total_time + $time | bc)
    done

    local avg_time=$(echo "scale=3; $total_time / $count" | bc)
    echo "Average access time for $key from node1: ${avg_time}s"
}

# Measure access times using cluster mode
measure_access_time "key1"
measure_access_time "key2"
measure_access_time "key3"

