#!/bin/bash

# Benchmark script for all four configurations
# Requires wrk to be installed: sudo apt install wrk

echo "🚀 Starting benchmark for all configurations..."
echo "================================================="

# Function to run benchmark
run_benchmark() {
    local name=$1
    local port=$2
    local command=$3
    local runtime=$4
    
    echo ""
    echo "🔥 Testing $name on port $port"
    echo "Starting server..."
    
    # Start server in background
    if [ "$runtime" = "bun" ]; then
        (cd $name && bun run start) &
    else
        (cd $name && node index.js) &
    fi
    
    local pid=$!
    sleep 3
    
    # Test if server is running
    if curl -s http://localhost:$port/ > /dev/null; then
        echo "✅ Server is running"
        echo "Running benchmark for 30 seconds with 12 threads and 400 connections..."
        wrk -t12 -c400 -d30s http://localhost:$port/api/test
    else
        echo "❌ Server failed to start"
    fi
    
    # Kill server
    kill $pid 2>/dev/null
    wait $pid 2>/dev/null
    sleep 2
}

# Check if wrk is installed
if ! command -v wrk &> /dev/null; then
    echo "❌ wrk is not installed. Please install it with:"
    echo "   Ubuntu/Debian: sudo apt install wrk"
    echo "   macOS: brew install wrk"
    exit 1
fi

# Run benchmarks
run_benchmark "bun-hono" 3000 "bun run start" "bun"
run_benchmark "bun-elysia" 3001 "bun run start" "bun"
run_benchmark "node-hono" 3002 "node index.js" "node"
run_benchmark "node-elysia" 3003 "node index.js" "node"

echo ""
echo "🎉 All benchmarks completed!"