#!/bin/bash

NODE1_IP="128.110.217.124"
NODE2_IP="128.110.217.94"
NODE3_IP="128.110.217.229"

# Insert data using cluster mode
echo "Inserting data..."
redis-cli -c -h $NODE1_IP -p 6379 set key1 value1
redis-cli -c -h $NODE1_IP -p 6379 set key2 value2
redis-cli -c -h $NODE1_IP -p 6379 set key3 value3

# Function to measure access time
measure_access_time() {
    local node_ip=$1
    local key=$2
    local total_time=0
    local count=5

    for i in $(seq 1 $count); do
        local time=$( (time redis-cli -c -h $node_ip -p 6379 get $key) 2>&1 | grep real | awk '{print $2}' | cut -dm -f2 | cut -ds -f1 )
        total_time=$(echo $total_time + $time | bc)
    done

    local avg_time=$(echo "scale=3; $total_time / $count" | bc)
    echo "Average access time for $key from node with IP $node_ip: ${avg_time}s"
}

# Measure local access times
echo "Measuring local access times:"
measure_access_time $NODE1_IP "key2"
measure_access_time $NODE1_IP "key3"

# Measure remote access times
echo "Measuring remote access times:"
measure_access_time $NODE2_IP "key1"
measure_access_time $NODE3_IP "key1"

