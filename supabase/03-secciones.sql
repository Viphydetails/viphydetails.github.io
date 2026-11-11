-- Secciones del catálogo administrables desde el panel. Se ejecuta después de 02-ofertas-y-galeria.sql.
-- Se puede volver a ejecutar sin dañar nada.

create table if not exists public.secciones (
  id     text primary key check (id ~ '^[a-z0-9-]+$' and id <> 'ofertas'),  -- «ofertas» la arma la tienda sola
  nombre text not null,
  emoji  text not null default '🎁',
  orden  integer not null default 0,
  creado timestamptz not null default now()
);

alter table public.secciones enable row level security;

drop policy if exists "ver secciones"    on public.secciones;
drop policy if exists "crear secciones"  on public.secciones;
drop policy if exists "editar secciones" on public.secciones;
drop policy if exists "borrar secciones" on public.secciones;

create policy "ver secciones" on public.secciones for select
  to anon, authenticated using (true);
create policy "crear secciones" on public.secciones for insert
  to authenticated with check (public.es_admin());
create policy "editar secciones" on public.secciones for update
  to authenticated using (public.es_admin()) with check (public.es_admin());
create policy "borrar secciones" on public.secciones for delete
  to authenticated using (public.es_admin());

grant select on public.secciones to anon, authenticated;
grant insert, update, delete on public.secciones to authenticated;

-- Las secciones que ya tenía la web
insert into public.secciones (id, nombre, emoji, orden) values
 ('cajas','Cajas','🎁',10),
 ('cuadros','Cuadros grandes','🎨',20),
 ('portarretratos','Portarretratos','🖼️',30),
 ('ramos','Ramos de flores','💐',40),
 ('camisas','Camisas','👕',50),
 ('polaroid','Fotos Polaroid','📸',60),
 ('llaveros','Llaveros','🔑',70),
 ('albumes','Álbumes','📔',80)
on conflict (id) do nothing;

-- Cada producto debe pertenecer a una sección existente; no se puede borrar una sección con productos.
alter table public.productos drop constraint if exists productos_categoria_fk;
alter table public.productos add constraint productos_categoria_fk
  foreign key (categoria) references public.secciones(id) on update cascade on delete restrict;

select * from public.secciones order by orden;
