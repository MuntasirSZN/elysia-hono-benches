#!/bin/bash

# Benchmark script for all four configurations
# Requires wrk or oha to be installed
# wrk: sudo apt install wrk (Ubuntu/Debian) or brew install wrk (macOS)
# oha: cargo install oha or download from https://github.com/hatoo/oha/releases

echo "🚀 Starting benchmark for all configurations..."
echo "================================================="

# Check which benchmark tool is available
BENCH_TOOL=""
if command -v oha &> /dev/null; then
    BENCH_TOOL="oha"
    echo "📊 Using oha for benchmarking"
elif command -v wrk &> /dev/null; then
    BENCH_TOOL="wrk"
    echo "📊 Using wrk for benchmarking"
else
    echo "❌ Neither oha nor wrk is installed. Please install one of them:"
    echo "   oha: cargo install oha"
    echo "   oha: Download from https://github.com/hatoo/oha/releases"
    echo "   wrk: sudo apt install wrk (Ubuntu/Debian)"
    echo "   wrk: brew install wrk (macOS)"
    exit 1
fi

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
        echo "Running benchmark for 30 seconds with 400 concurrent connections..."
        
        if [ "$BENCH_TOOL" = "oha" ]; then
            oha -c 400 -z 30s --latency-correction --disable-keepalive --no-tui http://localhost:$port/api/test
        else
            wrk -t12 -c400 -d30s http://localhost:$port/api/test
        fi
    else
        echo "❌ Server failed to start"
    fi
    
    # Kill server
    kill $pid 2>/dev/null
    wait $pid 2>/dev/null
    sleep 2
}

# Run benchmarks
run_benchmark "bun-hono" 3000 "bun run start" "bun"
run_benchmark "bun-elysia" 3001 "bun run start" "bun"
run_benchmark "node-hono" 3002 "node index.js" "node"
run_benchmark "node-elysia" 3003 "node index.js" "node"

echo ""
echo "🎉 All benchmarks completed!"
