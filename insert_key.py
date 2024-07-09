import redis
import os

NODE2_IP = "128.110.217.197"

# Connect to Redis on Node 2
r = redis.Redis(host=NODE2_IP, port=6379, db=0)

# Function to generate random string of specified size in KB
def generate_random_string(size_kb):
    return os.urandom(size_kb * 1024)

# Generate values of different sizes
value_1b = b"a"
value_1kb = generate_random_string(1)
value_1mb = generate_random_string(1024)
value_10mb = generate_random_string(10240)

# Insert data into Redis with hash tags to ensure they go to the desired slots
print("Inserting data...")
r.set("{hash_tag1}key1", value_1b)
r.set("{hash_tag1}key2", value_1kb)
r.set("{hash_tag1}key3", value_1mb)
r.set("{hash_tag1}key4", value_10mb)

print("Data insertion complete.")
