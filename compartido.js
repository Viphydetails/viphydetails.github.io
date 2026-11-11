/* Datos que usan la tienda (index.html) y el panel de admin (admin.html). */

// Proyecto de Supabase. La clave es la «publishable» (pública): puede ir en la web.
const SUPABASE = {
  url: "https://bazgydoxmeqdhefsmvpi.supabase.co",
  key: "sb_publishable_I2S75RhydxAwSwyx4-dlyQ_rSTwhRF7",
  bucket: "productos"
};

// Secciones de respaldo. Las reales se editan en el panel (admin.html → Secciones) y se guardan en Supabase.
let CATS = [
  {id:"cajas",n:"Cajas",e:"🎁"},{id:"cuadros",n:"Cuadros grandes",e:"🎨"},{id:"portarretratos",n:"Portarretratos",e:"🖼️"},
  {id:"ramos",n:"Ramos de flores",e:"💐"},{id:"camisas",n:"Camisas",e:"👕"},{id:"polaroid",n:"Fotos Polaroid",e:"📸"},
  {id:"llaveros",n:"Llaveros",e:"🔑"},{id:"albumes",n:"Álbumes",e:"📔"}
];
