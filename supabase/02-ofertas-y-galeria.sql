-- Ofertas y varias fotos por producto. Se ejecuta después de esquema.sql.
-- Se puede volver a ejecutar sin dañar nada.

-- Precio en oferta: vacío = sin oferta. Debe ser menor que el precio normal.
alter table public.productos add column if not exists precio_oferta numeric(10,2);
alter table public.productos drop constraint if exists productos_oferta_valida;
alter table public.productos add constraint productos_oferta_valida check (
  precio_oferta is null or (precio is not null and precio_oferta >= 0 and precio_oferta < precio)
);

-- Fotos: lista ordenada; la primera es la principal.
alter table public.productos add column if not exists imagenes text[] not null default '{}';

-- Pasa la foto única anterior a la lista y elimina la columna vieja.
do $$
begin
  if exists (select 1 from information_schema.columns
             where table_schema = 'public' and table_name = 'productos' and column_name = 'imagen') then
    update public.productos set imagenes = array[imagen]
      where imagen is not null and imagen <> '' and cardinality(imagenes) = 0;
    alter table public.productos drop column imagen;
  end if;
end $$;

select id, nombre, precio, precio_oferta, imagenes from public.productos order by orden, id;
