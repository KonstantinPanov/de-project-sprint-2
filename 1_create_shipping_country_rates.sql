
drop table if exists public.shipping_country_rates;

create table public.shipping_country_rates (
	id serial primary key,
	shipping_country text null,
	shipping_country_base_rate numeric(14,3) null
);

insert into public.shipping_country_rates(shipping_country, shipping_country_base_rate)
select distinct shipping_country, shipping_country_base_rate from shipping;

select * from public.shipping_country_rates;