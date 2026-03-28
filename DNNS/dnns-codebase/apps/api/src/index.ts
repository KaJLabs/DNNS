import "dotenv/config";
import Fastify from "fastify";
import { z } from "zod";
import { DNNSService } from "./service.js";

const app = Fastify({ logger: true });
const service = new DNNSService(process.env);

app.get("/health", async () => ({ ok: true, service: "dnns-api", network: "makalu" }));

app.get("/v1/names/:name/resolve", async (request) => {
  const params = z.object({ name: z.string().min(1) }).parse(request.params);
  return service.resolveName(params.name);
});

app.get("/v1/labels/:label/availability", async (request) => {
  const params = z.object({ label: z.string().regex(/^[a-z0-9-]+$/) }).parse(request.params);
  return service.checkAvailability(params.label);
});

app.listen({
  host: process.env.HOST ?? "0.0.0.0",
  port: Number(process.env.PORT ?? 8080)
}).catch((error) => {
  app.log.error(error);
  process.exit(1);
});
