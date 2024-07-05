#!/bin/bash

NODE1_IP="128.110.217.124"
NODE2_IP="128.110.217.94"
NODE3_IP="128.110.217.229"

# Function to generate random string of specified size in KB and save to a file
generate_random_string_to_file() {
    local size_kb=$1
    local file_name=$2
    head -c ${size_kb}K </dev/urandom > $file_name
}

# Temporary files for storing large values
TEMP_FILE_1KB=$(mktemp)
TEMP_FILE_1MB=$(mktemp)
TEMP_FILE_10MB=$(mktemp)

# Generate random strings and save to temporary files
generate_random_string_to_file 102400 $TEMP_FILE_1KB
generate_random_string_to_file 102400 $TEMP_FILE_1MB
generate_random_string_to_file 102400 $TEMP_FILE_10MB

# Insert data using cluster mode with temporary files
echo "Inserting data..."
redis-cli -c -h $NODE1_IP -p 6379 -x set key1 < $TEMP_FILE_1KB
redis-cli -c -h $NODE1_IP -p 6379 -x set key2 < $TEMP_FILE_1MB
redis-cli -c -h $NODE1_IP -p 6379 -x set key3 < $TEMP_FILE_10MB

# Function to measure access time with higher precision
measure_access_time() {
    local key=$1
    local total_time=0
    local count=10

    for i in $(seq 1 $count); do
	generate_random_string_to_file 102400 $TEMP_FILE_1KB
	redis-cli -c -h $NODE2_IP -p 6379 -x set $key < $TEMP_FILE_1KB
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

# Measure access times
echo "Measuring access times:"
measure_access_time "key1"
measure_access_time "key2"
measure_access_time "key3"

# Clean up temporary files
rm $TEMP_FILE_1KB $TEMP_FILE_1MB $TEMP_FILE_10MB

