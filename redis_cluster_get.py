from redis.cluster import RedisCluster as Redis
import time
import os

# Connection to Redis server
NODE2_IP = "128.110.217.203"
r = Redis(host=NODE2_IP, port=6379)

# Function to generate random string of specified size in KB
def generate_random_string(size_kb):
    return os.urandom(size_kb * 1024)

# Generate values of different sizes
# value_1b = b"a"
# value_1kb = generate_random_string(1)
# value_1mb = generate_random_string(1024)
# value_10mb = generate_random_string(10240)

# # Insert data into Redis
# print("Inserting data...")
# r.set("key1", value_1b)
# r.set("key2", value_1kb)
# r.set("key3", value_1mb)
# r.set("key4", value_10mb)

# Function to measure GET access time with higher precision
def measure_access_time(key):
    total_time = 0
    count = 1000

    for _ in range(count):
        start = time.perf_counter()
        r.get(key)
        end = time.perf_counter()
        elapsed = (end - start) * 1000  # Convert to milliseconds
        total_time += elapsed

    avg_time = total_time / count
    print(f"Average access time for {key}: {avg_time:.3f} ms")

# Measure GET access times for different key sizes
print("Measuring access times:")
measure_access_time("{hash_tag1}key1")
measure_access_time("{hash_tag1}key2")
measure_access_time("{hash_tag1}key3")
measure_access_time("{hash_tag1}key4")
