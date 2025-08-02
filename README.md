# Web Framework Benchmarks

This repository contains benchmark tests comparing Bun + Hono vs Bun + Elysia and Node.js + Hono vs Node.js + Elysia.

## Project Structure

```
benches/
├── bun-hono/          # Bun runtime + Hono framework (port 3000)
├── bun-elysia/        # Bun runtime + Elysia framework (port 3001)
├── node-hono/         # Node.js runtime + Hono framework (port 3002)
├── node-elysia/       # Node.js runtime + Elysia framework with @elysiajs/node adapter (port 3003)
├── benchmark.sh       # Automated benchmark script
└── README.md          # This file
```

## Setup

All dependencies are managed using Bun package manager and use the latest versions:

- **Hono**: v4.8.12
- **Elysia**: v1.3.8
- **@hono/node-server**: v1.18.1
- **@elysiajs/node**: v1.3.0

## Running Individual Servers

### Bun + Hono (port 3000)
```bash
cd bun-hono
bun run start
```

### Bun + Elysia (port 3001)
```bash
cd bun-elysia
bun run start
```

### Node.js + Hono (port 3002)
```bash
cd node-hono
bun run start  # or node index.js
```

### Node.js + Elysia (port 3003)
```bash
cd node-elysia
bun run start  # or node index.js
```

## API Endpoints

Each server provides the same endpoints:

- `GET /` - Hello message
- `GET /api/test` - Returns timestamp and runtime info (used for benchmarking)
- `POST /api/echo` - Echoes back the request body

## Running Benchmarks

### Prerequisites

Install `wrk` for load testing:

```bash
# Ubuntu/Debian
sudo apt install wrk

# macOS
brew install wrk
```

### Automated Benchmark

Run all benchmarks sequentially:

```bash
./benchmark.sh
```

This will test each configuration for 30 seconds with 12 threads and 400 connections.

### Manual Benchmark

Start a server manually and run:

```bash
# Example for bun-hono
cd bun-hono && bun run start &
wrk -t12 -c400 -d30s http://localhost:3000/api/test
kill %1
```

## Expected Results

The benchmarks will show:
- Requests/sec
- Latency statistics (avg, stdev, max)
- Transfer rate

Generally expected performance order (fastest to slowest):
1. Bun + Elysia
2. Bun + Hono  
3. Node.js + Elysia (with @elysiajs/node adapter)
4. Node.js + Hono

*Note: Actual results may vary based on hardware, system load, and network conditions.*