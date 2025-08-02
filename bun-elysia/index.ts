import { Elysia } from "elysia";

const _app = new Elysia()
  .get("/", () => ({ message: "Hello Elysia with Bun!" }))
  .get("/api/test", () => ({
    timestamp: Date.now(),
    runtime: "bun",
    framework: "elysia",
  }))
  .post("/api/echo", ({ body }) => body)
  .listen(3001);

console.log(`🦊 Elysia is running at http://localhost:3001`);
