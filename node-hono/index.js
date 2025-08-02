import { Hono } from "hono";
import { serve } from "@hono/node-server";

const app = new Hono();

app.get("/", (c) => {
  return c.json({ message: "Hello Hono with Node.js!" });
});

app.get("/api/test", (c) => {
  return c.json({
    timestamp: Date.now(),
    runtime: "node",
    framework: "hono",
  });
});

app.post("/api/echo", async (c) => {
  const body = await c.req.json();
  return c.json(body);
});

const port = 3002;
console.log(`Server is running on http://localhost:${port}`);

serve({
  fetch: app.fetch,
  port,
});
