import { Client, LocalAuth } from "whatsapp-web.js";

let client, ready=false;

export default async function handler(req, res) {
  res.setHeader("Access-Control-Allow-Origin", "*");

  if (!client) {
    client = new Client({
      authStrategy: new LocalAuth({ dataPath: "/tmp" }),
      puppeteer: { headless: true, args: ["--no-sandbox", "--disable-setuid-sandbox"] }
    });
    client.on("ready", () => ready = true);
    client.on("disconnected", () => { client = null; ready = false; });
    client.initialize();
  }

  const { action, phone, message } = req.query;

  if (action === "pair") {
    if (ready) return res.json({ status: "ready" });
    const code = await client.requestPairingCode(phone);
    return res.json({ status: "code", code });
  }

  if (action === "send" && ready) {
    await client.sendMessage(`${phone}@c.us`, message);
    return res.json({ status: "sent" });
  }

  res.json({ status: "unknown" });
}
