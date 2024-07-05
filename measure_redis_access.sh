#!/bin/bash

NODE1_IP="128.110.217.124"

# Insert data using cluster mode
echo "Inserting data..."
redis-cli -c -h $NODE1_IP -p 6379 set key1 value1
redis-cli -c -h $NODE1_IP -p 6379 set key2 value2
redis-cli -c -h $NODE1_IP -p 6379 set key3 value3

# Measure access times using cluster mode
echo "Accessing key1 from node1:"
(time redis-cli -c -h $NODE1_IP -p 6379 get key1) 2>&1 | grep real

echo "Accessing key2 from node1:"
(time redis-cli -c -h $NODE1_IP -p 6379 get key2) 2>&1 | grep real

echo "Accessing key3 from node1:"
(time redis-cli -c -h $NODE1_IP -p 6379 get key3) 2>&1 | grep real

