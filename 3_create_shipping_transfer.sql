
drop table if exists public.shipping_transfer;

create table public.shipping_transfer (
	id serial primary key,
	transfer_type text null,
	transfer_model text null,
	shipping_transfer_rate numeric(14,3) null
);

insert into public.shipping_transfer(transfer_type, transfer_model, shipping_transfer_rate)
select 
	shipping_transfer_description[1] as transfer_type,
	shipping_transfer_description[2] as transfer_model,
	shipping_transfer_rate
from
    (select distinct regexp_split_to_array(shipping_transfer_description, ':') as shipping_transfer_description, shipping_transfer_rate
	 from shipping) as t1
order by transfer_type, transfer_model;

select * from public.shipping_transfer;