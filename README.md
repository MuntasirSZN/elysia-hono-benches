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
    Latency     5.63ms    3.88ms  62.01ms   83.32%
    Req/Sec     6.34k     3.42k   13.25k    54.20%
  2273786 requests in 30.10s, 368.64MB read
Requests/sec:  75546.73
Transfer/sec:     12.25MB
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
    Latency     3.99ms    2.82ms  40.32ms   82.10%
    Req/Sec     8.98k     5.17k   19.28k    58.96%
  3220210 requests in 30.10s, 528.22MB read
Requests/sec: 106993.21
Transfer/sec:     17.55MB
error: script "start" was terminated by signal SIGTERM (Polite quit request)

🔥 Testing node-hono on port 3002
Starting server...
Server is running on http://localhost:3002
✅ Server is running
Running benchmark for 30 seconds with 12 threads and 400 connections...
Running 30s test @ http://localhost:3002/api/test
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    13.04ms   66.15ms   1.28s    98.40%
    Req/Sec     5.74k     1.34k   33.20k    86.18%
  2032269 requests in 30.10s, 422.51MB read
Requests/sec:  67519.85
Transfer/sec:     14.04MB

🔥 Testing node-elysia on port 3003
Starting server...
🦊 Elysia is running at http://localhost:3003
✅ Server is running
Running benchmark for 30 seconds with 12 threads and 400 connections...
Running 30s test @ http://localhost:3003/api/test
  12 threads and 400 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    23.95ms  111.11ms   2.00s    98.11%
    Req/Sec     3.06k   587.94    13.88k    90.54%
  1076017 requests in 30.10s, 225.76MB read
  Socket errors: connect 0, read 0, write 0, timeout 49
Requests/sec:  35747.86
Transfer/sec:      7.50MB

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
