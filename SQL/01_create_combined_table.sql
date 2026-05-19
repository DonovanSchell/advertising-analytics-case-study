create table combined as
with cte_summary as (
    select
        "Advertiser",
        "Month Year",
        extract(year from "Month Year"::date) as year,
        extract(month from "Month Year"::date) as month,
        "Advertiser Location",
        "Industry Vertical",
        "Segment",
        sum(replace(replace("Revenue", '$', ''), ',', '')::numeric) as summary_revenue
    from monthly_summary
    group by 1, 2, 3, 4, 5, 6, 7
),

cte_breakdown as (
    select
        "Advertiser",
        "Month Year",
        "Ad Type",
        "Ad Location",
        sum("Revenue"::numeric) as breakdown_revenue
    from monthly_breakdown
    group by 1, 2, 3, 4
)

select
    s."Advertiser",
    s."Month Year",
    s.year,
    s.month,
    s."Advertiser Location",
    s."Industry Vertical",
    s."Segment",
    b."Ad Type",
    b."Ad Location",
    b.breakdown_revenue as "Revenue"
from cte_summary s
left join cte_breakdown b
    on s."Advertiser" = b."Advertiser"
    and s."Month Year" = b."Month Year"
order by s."Advertiser", s."Month Year"
;

drop table msft_combined;
