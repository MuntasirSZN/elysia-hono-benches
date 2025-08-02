import { Hono } from "hono";

const app = new Hono();

app.get("/", (c) => {
  return c.json({ message: "Hello Hono with Bun!" });
});

app.get("/api/test", (c) => {
  return c.json({
    timestamp: Date.now(),
    runtime: "bun",
    framework: "hono",
  });
});

app.post("/api/echo", async (c) => {
  const body = await c.req.json();
  return c.json(body);
});

export default {
  port: 3000,
  fetch: app.fetch,
};
