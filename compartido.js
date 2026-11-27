/* Datos que usan la tienda (index.html) y el panel de admin (admin.html). */

// Proyecto de Supabase. La clave es la «publishable» (pública): puede ir en la web.
const SUPABASE = {
  url: "https://bazgydoxmeqdhefsmvpi.supabase.co",
  key: "sb_publishable_I2S75RhydxAwSwyx4-dlyQ_rSTwhRF7",
  bucket: "productos"
};

// Secciones de respaldo. Las reales se editan en el panel (admin.html → Secciones) y se guardan en Supabase.
let CATS = [
  {id:"cajas",n:"Cajas"},{id:"cuadros",n:"Cuadros grandes"},{id:"portarretratos",n:"Portarretratos"},
  {id:"ramos",n:"Ramos de flores"},{id:"camisas",n:"Camisas"},{id:"polaroid",n:"Fotos Polaroid"},
  {id:"llaveros",n:"Llaveros"},{id:"albumes",n:"Álbumes"}
];
