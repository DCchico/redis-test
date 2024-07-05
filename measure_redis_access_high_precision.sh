#!/bin/bash

NODE1_IP="128.110.217.124"

# Insert data using cluster mode
echo "Inserting data..."
redis-cli -c -h $NODE1_IP -p 6379 set key1 value1
redis-cli -c -h $NODE1_IP -p 6379 set key2 value2
redis-cli -c -h $NODE1_IP -p 6379 set key3 value3

# Function to measure access time with higher precision
measure_access_time() {
    local key=$1
    local total_time=0
    local count=1000

    for i in $(seq 1 $count); do
        start=$(date +%s%N)
        redis-cli -c -h $NODE1_IP -p 6379 get $key > /dev/null
        end=$(date +%s%N)
        elapsed=$((end - start))
        total_time=$((total_time + elapsed))
    done

    avg_time=$((total_time / count))
    avg_time_ms=$(echo "scale=3; $avg_time / 1000000" | bc)
    echo "Average access time for $key from node1: ${avg_time_ms}ms"
}

# Measure access times using cluster mode
echo "Measuring access times:"
measure_access_time "key1"
measure_access_time "key2"
measure_access_time "key3"

