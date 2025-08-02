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

## Results

Ran on a Intel i3 12100, iGPU.

```sh
🚀 Starting benchmark for all configurations...
=================================================

🔥 Testing bun-hono on port 3000
Starting server...
$ bun run index.ts
Started development server: http://localhost:3000
✅ Server is running
Running benchmark for 30 seconds with 12 threads and 400 connections...
Running 30s test @ http://localhost:3000/api/test
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     5.44ms    3.17ms  42.44ms   85.65%
    Req/Sec     6.40k     2.57k   20.47k    63.99%
  2295151 requests in 30.10s, 372.10MB read
Requests/sec:  76249.61
Transfer/sec:     12.36MB
error: script "start" was terminated by signal SIGTERM (Polite quit request)

🔥 Testing bun-elysia on port 3001
Starting server...
$ bun run index.ts
🦊 Elysia is running at http://localhost:3001
✅ Server is running
Running benchmark for 30 seconds with 12 threads and 400 connections...
Running 30s test @ http://localhost:3001/api/test
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.02ms    2.52ms  46.98ms   85.53%
    Req/Sec     8.71k     4.71k  190.62k    77.90%
  3121254 requests in 30.10s, 511.99MB read
Requests/sec: 103700.17
Transfer/sec:     17.01MB
error: script "start" was terminated by signal SIGTERM (Polite quit request)

🔥 Testing node-hono on port 3002
Starting server...
Server is running on http://localhost:3002
✅ Server is running
Running benchmark for 30 seconds with 12 threads and 400 connections...
Running 30s test @ http://localhost:3002/api/test
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    15.57ms   81.45ms   1.65s    98.35%
    Req/Sec     4.96k     1.78k   73.69k    84.65%
  1758437 requests in 30.10s, 365.58MB read
Requests/sec:  58423.87
Transfer/sec:     12.15MB

🔥 Testing node-elysia on port 3003
Starting server...
❌ Server failed to start

🎉 All benchmarks completed!
```

```mermaid
%% Benchmark comparison of bun-hono, bun-elysia, node-hono, node-elysia
%% Requests/sec and Latency (ms)
%% Data from latest benchmark posted by user

graph TD
  A[bun-elysia<br>Requests/sec: 106,993<br>Latency: 3.99ms]
  B[bun-hono<br>Requests/sec: 75,547<br>Latency: 5.63ms]
  C[node-hono<br>Requests/sec: 67,520<br>Latency: 13.04ms]
  D[node-elysia<br>Requests/sec: 35,748<br>Latency: 23.95ms]

  A --> B --> C --> D
````
