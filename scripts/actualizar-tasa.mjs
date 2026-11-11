// Lee la tasa del euro en la página del BCV y la guarda en tasa.json
import https from "node:https";
import { readFileSync, writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";

const ARCHIVO = new URL("../tasa.json", import.meta.url);

function descargar(url) {
  return new Promise((ok, fail) => {
    // El sitio del BCV suele tener problemas con su certificado SSL; son datos públicos de solo lectura.
    const req = https.get(url, { rejectUnauthorized: false, timeout: 30000, headers: { "User-Agent": "Mozilla/5.0" } }, res => {
      let d = "";
      res.setEncoding("utf8");
      res.on("data", c => (d += c));
      res.on("end", () => (res.statusCode === 200 ? ok(d) : fail(new Error("HTTP " + res.statusCode))));
    });
    req.on("error", fail);
    req.on("timeout", () => req.destroy(new Error("timeout")));
  });
}

export function extraerEuro(html) {
  const m = html.match(/id="euro"[\s\S]*?<strong[^>]*>\s*([\d.,]+)\s*<\/strong>/);
  if (!m) throw new Error("No encontré la tasa del euro: el BCV pudo haber cambiado su página.");
  let t = m[1].trim();
  if (t.includes(",")) t = t.replace(/\./g, "").replace(",", ".");
  const n = parseFloat(t);
  if (!(n > 0)) throw new Error("Valor inválido: " + m[1]);
  return n;
}

async function main() {
  const html = await descargar("https://www.bcv.org.ve/");
  const nueva = extraerEuro(html);
  let previa = 0;
  try { previa = JSON.parse(readFileSync(ARCHIVO, "utf8")).tasa || 0; } catch {}
  if (previa > 0 && Math.abs(nueva - previa) / previa > 0.25) {
    throw new Error(`La tasa cambió demasiado (${previa} → ${nueva}). Revisa a mano antes de publicarla.`);
  }
  const fecha = new Date().toLocaleDateString("en-CA", { timeZone: "America/Caracas" });
  writeFileSync(ARCHIVO, JSON.stringify({ tasa: nueva, fecha, fuente: "BCV", actualizado: new Date().toISOString() }, null, 2) + "\n");
  console.log("Tasa euro BCV:", nueva, fecha);
}

if (process.argv[1] === fileURLToPath(import.meta.url)) main().catch(e => { console.error(e.message); process.exit(1); });
