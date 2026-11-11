# Tienda Viphy

Web de catálogo, carrito y pago, con pedido por WhatsApp y tasa euro del BCV que se actualiza sola.

## Publicar (gratis, con GitHub Pages)
1. Crea una cuenta en github.com y un repositorio público llamado `viphy`.
2. Sube todo el contenido de esta carpeta. La carpeta `.github` empieza con punto: si la web no te deja subirla, usa GitHub Desktop, o en el repositorio elige Add file → Create new file y escribe la ruta `.github/workflows/tasa.yml` pegando el contenido.
3. En Settings → Pages, elige Deploy from a branch, rama `main`, carpeta `/ (root)`. Tu web quedará en `https://TU-USUARIO.github.io/viphy/`.
4. En Settings → Actions → General → Workflow permissions, elige Read and write permissions.
5. En la pestaña Actions, abre «Actualizar tasa euro BCV» y presiona Run workflow. Así se llena la tasa por primera vez; después corre sola a las 7:00 a. m. y 6:00 p. m. (hora de Caracas).

## Datos que debes cambiar en `index.html` (arriba, bloque CONFIGURACIÓN)
- `whatsapp`: número con código de país, sin + ni espacios.
- `pagos`: datos de cobro de bolívares, Binance y el tercer método.
- Los productos ya no se editan aquí: se cargan desde el panel de admin (ver abajo).

## Panel de administración (productos y fotos)
- Está en `admin.html`. Ya publicada la web: `https://TU-USUARIO.github.io/viphy/admin.html`. No aparece en la tienda.
- Ahí se agregan, editan, ocultan y borran productos, y se suben sus fotos. Los cambios se ven al instante en la tienda.
- Los datos viven en Supabase (proyecto «Viphy»). La conexión está en `compartido.js`, junto con las secciones del catálogo.
- **Agregar un admin:** en Supabase → Authentication → Users → Add user → Create new user (correo y contraseña, marca Auto Confirm User). Luego en SQL Editor ejecuta:
  `insert into public.admins (email) values ('correo@ejemplo.com');`
- **Quitar un admin:** `delete from public.admins where email = 'correo@ejemplo.com';`
- **Ofertas:** en el producto escribe el «Precio en oferta». La tienda muestra «Antes» con el precio tachado, «Hoy» con el de oferta y la etiqueta OFERTA, y cobra el precio en oferta. Para quitarla, deja el campo vacío.
- **Varias fotos:** cada producto admite hasta 8. La primera es la principal; en la tienda se deslizan en carrusel y al tocarlas se ven en grande.
- `supabase/esquema.sql` y luego `supabase/02-ofertas-y-galeria.sql` crean toda la base de datos. Ya se ejecutaron; solo hace falta de nuevo si creas otro proyecto.
- Si Supabase no responde, la tienda muestra la última lista de productos que vio el visitante, o la lista de respaldo de `index.html`.

## Si la tasa falla
- GitHub te avisa por correo si la actualización falla. La web sigue mostrando la última tasa guardada.
- Puedes corregirla a mano: abre `tasa.json` en GitHub, presiona el lápiz y cambia `tasa` y `fecha`.
- Si el monto cambia más de 25 % de un día a otro, el proceso se detiene a propósito para que lo revises.
- GitHub pausa las tareas programadas si el repositorio pasa 60 días sin actividad; en ese caso actívalas de nuevo desde la pestaña Actions.

## Dominio propio (opcional)
Compra el dominio y en Settings → Pages escribe tu dominio en Custom domain.

## Marca y tipografías
- Colores: principal `#4f000b` y secundario `#ffd6e0` (variables al inicio del bloque de estilos).
- Lobster se carga sola desde Google Fonts. Agrandir no está en Google Fonts: copia sus archivos `.woff2` (regular y bold) en la carpeta `fuentes/` con los nombres indicados allí. Revisa la licencia de Agrandir para uso comercial.
- Los logos de la web están dentro de `index.html`; las versiones sueltas están en `imagenes/`.
