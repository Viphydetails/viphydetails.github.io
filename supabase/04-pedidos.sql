-- Pedidos numerados e historial con estados. Se ejecuta después de 03-secciones.sql.
-- Se puede volver a ejecutar sin dañar nada.

create table if not exists public.pedidos (
  numero      bigint generated always as identity primary key,   -- N° de pedido: 1, 2, 3…
  creado      timestamptz not null default now(),
  estado      text not null default 'pendiente'
              check (estado in ('pendiente','en_espera','por_hacer','en_proceso','listo','entregado','cancelado')),
  cliente     text not null,
  telefono    text not null,
  entrega     text not null check (entrega in ('delivery','pickup')),
  direccion   text,
  fecha       date,
  hora        text,
  metodo      text not null,
  modo        text not null check (modo in ('mitad','contado')),
  items       jsonb not null,             -- [{id, nombre, precio, q}]
  total       numeric(10,2) not null,
  abonado     numeric(10,2) not null,
  tasa        numeric,                    -- tasa euro usada si paga en bolívares
  referencia  text,
  nota        text,
  notas_admin text,
  actualizado timestamptz not null default now()
);

drop trigger if exists pedidos_actualizado on public.pedidos;
create trigger pedidos_actualizado before update on public.pedidos
for each row execute function public.tocar_actualizado();

-- Solo los admins ven y modifican pedidos. Los clientes los crean únicamente con crear_pedido().
alter table public.pedidos enable row level security;
drop policy if exists "admins ven pedidos"    on public.pedidos;
drop policy if exists "admins editan pedidos" on public.pedidos;
drop policy if exists "admins borran pedidos" on public.pedidos;
create policy "admins ven pedidos" on public.pedidos for select
  to authenticated using (public.es_admin());
create policy "admins editan pedidos" on public.pedidos for update
  to authenticated using (public.es_admin()) with check (public.es_admin());
create policy "admins borran pedidos" on public.pedidos for delete
  to authenticated using (public.es_admin());
revoke all on public.pedidos from anon;
grant select, update, delete on public.pedidos to authenticated;

-- La tienda llama a esta función al enviar un pedido. Los precios y el total
-- se toman de la tabla de productos (no de lo que mande el navegador). Devuelve el N° de pedido.
create or replace function public.crear_pedido(p jsonb) returns bigint
language plpgsql security definer set search_path = '' as $$
declare
  v_items jsonb := '[]'::jsonb;
  v_total numeric := 0;
  v_num   bigint;
  it      jsonb;
  pr      record;
  q       integer;
begin
  if jsonb_typeof(p->'items') is distinct from 'array'
     or jsonb_array_length(p->'items') = 0 or jsonb_array_length(p->'items') > 50 then
    raise exception 'El pedido no tiene productos';
  end if;
  if coalesce(trim(p->>'cliente'), '') = '' or coalesce(trim(p->>'telefono'), '') = '' then
    raise exception 'Faltan el nombre o el teléfono';
  end if;
  for it in select * from jsonb_array_elements(p->'items') loop
    q := (it->>'q')::integer;
    if q is null or q < 1 or q > 99 then raise exception 'Cantidad inválida'; end if;
    select x.id, x.nombre, coalesce(x.precio_oferta, x.precio) as precio into pr
      from public.productos x
      where x.id = (it->>'id')::bigint and x.visible and x.precio is not null;
    if not found then raise exception 'Un producto ya no está disponible'; end if;
    v_items := v_items || jsonb_build_object('id', pr.id, 'nombre', pr.nombre, 'precio', pr.precio, 'q', q);
    v_total := v_total + pr.precio * q;
  end loop;

  insert into public.pedidos (cliente, telefono, entrega, direccion, fecha, hora, metodo, modo,
                              items, total, abonado, tasa, referencia, nota)
  values (
    left(trim(p->>'cliente'), 120),
    left(trim(p->>'telefono'), 40),
    case when p->>'entrega' = 'pickup' then 'pickup' else 'delivery' end,
    left(p->>'direccion', 300),
    nullif(p->>'fecha', '')::date,
    left(p->>'hora', 10),
    left(coalesce(p->>'metodo', ''), 40),
    case when p->>'modo' = 'contado' then 'contado' else 'mitad' end,
    v_items,
    v_total,
    case when p->>'modo' = 'contado' then v_total else round(v_total / 2, 2) end,
    nullif(p->>'tasa', '')::numeric,
    left(p->>'referencia', 120),
    left(p->>'nota', 1000)
  )
  returning numero into v_num;
  return v_num;
end $$;

revoke all on function public.crear_pedido(jsonb) from public;
grant execute on function public.crear_pedido(jsonb) to anon, authenticated;

select count(*) as pedidos from public.pedidos;
