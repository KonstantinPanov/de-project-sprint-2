
drop table if exists public.shipping_status;

create table public.shipping_status (
	shipping_id bigint NOT NULL,
	status text null,
	state text null,
	shipping_start_fact_datetime timestamp NULL,
	shipping_end_fact_datetime timestamp NULL
);

insert into public.shipping_status(shipping_id, status, state, shipping_start_fact_datetime, shipping_end_fact_datetime)
select shippingid as shipping_id,	   
	   array_[1] as status,
	   array_[2] as state,
	   state_datetime as shipping_start_fact_datetime,
       TO_TIMESTAMP(array_[3], 'YYYY-MM-DD HH24:MI:ss') as shipping_end_fact_datetime	   
	   
from
(select shippingid, min(s.state_datetime) as state_datetime,
	regexp_split_to_array((select CONCAT_WS(';', status, state, state_datetime) from shipping s1 where s.shippingid=s1.shippingid order by s1.state_datetime desc limit 1), ';') as array_
from shipping s
group by s.shippingid) t;

select * from public.shipping_status;