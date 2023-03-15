
drop view shipping_datamart;

create view shipping_datamart as
select si.shipping_id, 
       si.vendor_id, 
       st.transfer_type, 
       extract(day from (ss.shipping_end_fact_datetime - ss.shipping_start_fact_datetime)) as full_day_at_shipping,
       case
	       when ss.shipping_end_fact_datetime > si.shipping_plan_datetime then 1
       	   else 0
       end as is_delay,  
       case
	       when ss.status = 'finished' then 1
       	   else 0
       end as is_shipping_finish,
       case
	       when ss.shipping_end_fact_datetime > si.shipping_plan_datetime then date_part('day', age(ss.shipping_end_fact_datetime, si.shipping_plan_datetime))
       	   else 0
       end as delay_day_at_shipping,
       si.payment_amount,  
       (si.payment_amount * (scr.shipping_country_base_rate + sa.agreement_rate + st.shipping_transfer_rate)) as vat,
       si.payment_amount * sa.agreement_commission as profit

       
from shipping_info si
inner join shipping_transfer st on st.id = si.shipping_transfer_id 
inner join shipping_status ss on ss.shipping_id = si.shipping_id 
inner join shipping_country_rates scr on scr.id = si.shipping_country_rate_id 
inner join shipping_agreement sa on sa.agreement_id = si.shipping_agreement_id;

select count(*) from shipping_datamart;