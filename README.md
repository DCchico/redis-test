# CloudLab Redis Experiment

## Overview

This project involves setting up a Redis cluster on CloudLab, performing data insertion and retrieval operations, and measuring access times for different key sizes to understand the performance overhead of local versus remote access in a Redis cluster.

## Steps Performed

### 1. CloudLab Setup
- Reserved CloudLab nodes for the experiment.
- Accessed the nodes via SSH.

### 2. Redis Installation
- Installed Redis on all nodes:
  ```sh
  sudo apt update
  sudo apt install redis-server

### 3. Redis Config
port 6379
bind 0.0.0.0
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip <node-ip>
cluster-announce-port 6379

### 4. Redis Cluster Creation
redis-cli --cluster create 128.110.217.124:6379 128.110.217.94:6379 128.110.217.229:6379 --cluster-replicas 0

### 5. Disable Tracking
redis-cli -h $NODE1_IP -p 6379 CLIENT TRACKING OFF

