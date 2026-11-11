# Notas del proyecto: tienda web Viphy Details

Resumen para retomar el trabajo en otra conversación. Sube esta carpeta (el .zip) y di: «Continúa el proyecto de la web de Viphy».

## Qué es
Tienda virtual de regalos personalizados. Web de una sola página (`index.html`): portada con reseña, catálogo por secciones, preguntas frecuentes, contacto, carrito, pago y envío del pedido por WhatsApp.

## Enlaces
- Tienda: https://viphydetails.github.io/
- Panel de admin: https://viphydetails.github.io/admin.html
- Repositorio: https://github.com/Viphydetails/viphydetails.github.io

## Estructura
- `index.html`: toda la tienda. Arriba del script están los datos editables: `CONFIG` (nombre, reseña, WhatsApp, Instagram, correo, dirección, datos de pago) y `FAQ`. `PRODUCTOS` quedó solo como respaldo.
- `admin.html`: panel de administración (inicio de sesión, agregar/editar/ocultar/borrar productos, subir fotos).
- `compartido.js`: conexión a Supabase y secciones del catálogo (`CATS`), usado por la tienda y el panel.
- `supabase/esquema.sql`: tablas `productos` y `admins`, reglas de seguridad y almacenamiento de fotos (bucket `productos`).
- `supabase/02-ofertas-y-galeria.sql`: agrega `precio_oferta` y `imagenes` (lista de fotos) y elimina la columna vieja `imagen`.
- `tasa.json`: tasa euro del día, la escribe sola el flujo de GitHub.
- `scripts/actualizar-tasa.mjs` y `.github/workflows/tasa.yml`: leen la tasa euro en bcv.org.ve dos veces al día (7:00 a. m. y 6:00 p. m., hora de Caracas).
- `imagenes/`: logotipo e isotipo en el color principal; `imagenes/productos/`: fotos de productos (360 px, recortadas en cuadrado).
- `fuentes/`: aquí van los archivos de Agrandir (.woff2). Todavía no están.
- `LEEME.md`: pasos para publicar en GitHub Pages.

## Decisiones tomadas
- Marca: color principal #4f000b, secundario #ffd6e0. Títulos en Lobster; texto en Agrandir, con Bricolage Grotesque de respaldo mientras no estén los archivos.
- El catálogo muestra solo precios en USD. El monto en bolívares aparece solo al elegir pagar en bolívares, a tasa euro.
- Pago: abono del 50 % (sin él no se agenda el pedido) o de contado. Métodos en la web: bolívares (pago móvil), Binance y Zinli. El efectivo se aceptó en las preguntas frecuentes pero no está como opción en el pago.
- Los productos con `p:null` muestran «Precio por confirmar» y un botón «Consultar precio» por WhatsApp. Al poner el precio en USD pasan a tener botón «Agregar».
- Se creó la sección Llaveros. Los tres marcos con foto quedaron en Portarretratos.
- Animaciones sutiles al aparecer, al pasar el mouse y al agregar al carrito; se desactivan si el dispositivo pide menos movimiento.
- Redacción: el dueño prefiere textos naturales, con pocos puntos seguidos, que no suenen a IA.

- Productos en Supabase (proyecto «Viphy», región Frankfurt, plan gratis). Cualquiera puede leer los productos visibles; solo los correos de la tabla `admins` pueden modificar productos o fotos. Las fotos subidas se recortan en cuadrado y se reducen a 800 px en el navegador.

- Ofertas: `precio_oferta` debe ser menor que `precio`. En la tienda se muestra «Antes: precio tachado» y «Hoy: precio en oferta», con etiqueta OFERTA; el carrito cobra el precio en oferta.
- Fotos: hasta 8 por producto, la primera es la principal. En la tarjeta se deslizan dentro del círculo con puntos debajo; al tocar una se abre un visor grande con flechas.

## Pendiente
- Crear las cuentas de los admins y agregarlas a la tabla `admins`.
- Desactivar el registro público en Supabase (Authentication → Sign In / Providers → Allow new users to sign up).
- Precios en USD de los 10 productos con foto.
- Fotos, nombres, descripciones y precios de cuadros grandes, ramos de flores y camisas (hoy son ejemplos).
- Foto general de la tienda (`CONFIG.fotoPortada`).
- Archivos de la tipografía Agrandir.
- Confirmar que el correo es viphy.details@gmail.com.
- Decidir si se agrega la opción de efectivo en el pago y una línea de «no hay devoluciones» junto al aviso del 50 %.
- Confirmar que los clientes de las fotos dieron permiso para mostrarlas.
- Probar un pedido real desde el teléfono.

## Cómo agregar un producto
Desde `admin.html` → «+ Nuevo producto». Precio vacío = «Precio por confirmar». Para una sección nueva, agrégala en `CATS` dentro de `compartido.js`.
