
drop table if exists public.shipping_agreement;

create table public.shipping_agreement (
	agreement_id bigint primary key,
	agreement_number text null,
	agreement_rate numeric(14,3) null,
	agreement_commission numeric(14,3) null
);

insert into public.shipping_agreement(agreement_id, agreement_number, agreement_rate, agreement_commission)
select 
	cast(vendor_agreement_description[1] as integer) as agreement_id,
	vendor_agreement_description[2] as agreement_number,
	cast(vendor_agreement_description[3] as numeric(14,3)) as agreement_rate,
	cast(vendor_agreement_description[4] as numeric(14,3)) as agreement_commission
from
    (select distinct regexp_split_to_array(vendor_agreement_description, ':') as vendor_agreement_description
	 from shipping) as t1
order by agreement_id;

select * from public.shipping_agreement;
