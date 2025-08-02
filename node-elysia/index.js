import { Elysia } from "elysia";
import { node } from "@elysiajs/node";

const _app = new Elysia({ adapter: node() })
  .get("/", () => ({ message: "Hello Elysia with Node.js!" }))
  .get("/api/test", () => ({
    timestamp: Date.now(),
    runtime: "node",
    framework: "elysia",
  }))
  .post("/api/echo", ({ body }) => body)
  .listen(3003);

console.log(`🦊 Elysia is running at http://localhost:3003`);
