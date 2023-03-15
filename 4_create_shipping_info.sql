
drop table if exists public.shipping_info cascade;

create table public.shipping_info (
	shipping_id bigint primary key,
        vendor_id bigint NULL,
	payment_amount numeric(14, 2) NULL,
	shipping_plan_datetime timestamp NULL,
	shipping_transfer_id bigint NULL,
	shipping_agreement_id bigint NULL,
	shipping_country_rate_id bigint NULL,
	FOREIGN KEY (shipping_transfer_id) REFERENCES shipping_transfer(id) ON UPDATE cascade,
	FOREIGN KEY (shipping_agreement_id) REFERENCES shipping_agreement(agreement_id) ON UPDATE cascade,
	FOREIGN KEY (shipping_country_rate_id) REFERENCES shipping_country_rates(id) ON UPDATE cascade

);

with shipping_transfer AS
	(select id as shipping_transfer_id, concat_ws(':', transfer_type, transfer_model) as shipping_transfer_description from shipping_transfer),

	shipping_country_rates AS
	(select id as shipping_country_rate_id, shipping_country from shipping_country_rates)

insert into public.shipping_info(shipping_id, vendor_id, payment_amount, shipping_plan_datetime, shipping_transfer_id, shipping_agreement_id, shipping_country_rate_id)
select s.shippingid as shipping_id, s.vendorid as vendor_id, s.payment_amount, s.shipping_plan_datetime, st.shipping_transfer_id, cast(split_part(vendor_agreement_description, ':', 1) as bigint) as shipping_agreement_id, scr.shipping_country_rate_id
from shipping s
left join shipping_transfer st using (shipping_transfer_description)
left join shipping_country_rates scr using (shipping_country)
group by s.shippingid, s.vendorid, s.payment_amount, s.shipping_plan_datetime, s.vendor_agreement_description, st.shipping_transfer_id, shipping_agreement_id, scr.shipping_country_rate_id;