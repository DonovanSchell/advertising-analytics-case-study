select
	"year",
	round(sum("Revenue"))
from combined c
group by "year"
;

--YoY industry verticals
select
    "Industry Vertical",
    round("2024_revenue") as "2024_revenue",
    rank() over (order by "2025_revenue" desc) as "2025_rank",
    round("2025_revenue") as "2025_revenue",
    round("2025_revenue" - "2024_revenue") as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
        "Industry Vertical",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    group by 1
) sub
order by "Industry Vertical"
;
/* Opportunities:
	 * Retail is largest vertical by far, and grew 16% YoY (~$14M gain)
	 * Health grew 15.4%, although ranked 7 out of the 8 total industries
	 	* Although a lower ranked vertical, its high growth could signal an opportunity
 * Concerns:
 	* B2C Services is the 2nd largest vertical but is declining (-$737K, -3%)
 	* Technology also declining (-$770K, -2%) - notable given Acme's audience
 * B2B Services is essentially flat at 0.03% growth on $14M -- could present a risk
 */


--YoY ad type
select
    "Ad Type",
    round("2024_revenue") as "2024_revenue",
    rank() over (order by "2025_revenue" desc) as "2025_rank",
    round("2025_revenue") "2025_revenue",
    round("2025_revenue" - "2024_revenue") as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
        "Ad Type",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    group by 1
) sub
order by "Ad Type"
;
/* MSAN Audience: fastest growing rate (+9%) but smallest absolute gain — underleveraged, worth exploring why
 	* Concern: while this is the fastest growing, its continuing to show as being leveraged the least out of the ad types. Could be worth exploring among clients why programmatic place display, native, or video ads continue to receive the least investment.
 * MSAN Search: solid middle ground on both rate and absolute growth
 * Search: slowest rate (+5.4%) but by far the largest absolute gain (+$9.6M) — the reliable revenue engine
 */


--YoY industry & ad type
select
   "Industry Vertical",
	"Ad Type",
    round("2024_revenue") as "2024_revenue",
    round("2025_revenue") as "2025_revenue",
    round("2025_revenue" - "2024_revenue") as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
       "Industry Vertical",
    	"Ad Type",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    group by 1, 2
) sub
order by "Industry Vertical", "Ad Type"
;
/* Key Insights:
	 * Opportunity: Retail is your growth engine across all ad types — double down here
	 * Risk: B2C and Technology are declining, driven primarily by Search underperformance — sales teams need a retention play here
 * 
 * Additional Context:
 * Opportunities:
	* Retail's top ad type by YoY absolute gain is actually Search (+$9.45M)
 	* B2C Services only saw gains with MSAN Audience, while the other two types declined
 * Risks:
 	* Technology gained in MSAN Audience, but the other two ad types negates those gains into negative territory
 	* Health similarly saw gains across the board with Search as its top ad type
 	* Education is declining across all three ad types — small revenue base but consistent negative signal
 * 
 * Summary: Retail is the clear growth engine and deserves prioritized attention, while B2C and Technology represent meaningful revenue-at-risk that sales teams need a retention strategy for.
 	* Retail opportunity — broad-based growth across all ad types, prioritize here
 	* B2C/Tech risk — concentrated account pullback, especially in Search, needs retention focus
 */

--advertiser-level data
select
    "Industry Vertical",
    "Advertiser",
    round("2024_revenue") as "2024_revenue",
    round("2025_revenue") as "2025_revenue",
    round(("2025_revenue" - "2024_revenue")::numeric) as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change",
    rank() over (partition by "Industry Vertical" order by "2025_revenue" desc) as "rank"
from (
    select
        "Industry Vertical",
        "Advertiser",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    group by 1, 2
) sub
where "Industry Vertical" in ('Retail', 'B2C Services', 'Technology')
order by "Industry Vertical", "rank"
;
--key insight: For B2C specifically, look at the ones with actual YoY data near the bottom of your paste — DF-1412288 dropped -$1.3M (-26%) which is massive, and a few others show steep declines (-61%, -62%). That suggests B2C's revenue problem isn't broad-based churn — it's a handful of large accounts pulling back significantly.


--YoY advertiser location (Country D)
select
    "Industry Vertical",
    round("2024_revenue") as "2024_revenue",
    round("2025_revenue") as "2025_revenue",
    round(("2025_revenue" - "2024_revenue")::numeric) as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
        "Industry Vertical",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    where "Advertiser Location" = 'Country D'
    group by 1
) sub
order by "2025_revenue" desc
;
/* Retail + Country D is a compounding story: Retail is already your #1 growth vertical globally (+16% YoY), and in Country D specifically it's growing at +67.7% — the largest vertical in that market by a wide margin. That's not a coincidence, that's a signal.
 * Health in Country D is extraordinary: +472% YoY is stunning. Yes it's coming off a small base, but going from $333K to $1.9M in one year warrants attention. Worth flagging as an emerging opportunity even if you caveat the small base.
 * B2B Services +285% is similarly striking for the same reason.
 * The clean narrative this gives you: Country D isn't just growing — it's growing across nearly every vertical, led by your globally strongest vertical (Retail). That makes it a much more compelling investment case than just a percentage anomaly.
 * 
 * For your presentation I'd frame it as two linked insights:
 	* Retail is your global growth engine — prioritize across all markets
 	* Country D represents your highest-growth emerging market — Retail is already leading there, and early signals in Health and B2B suggest broad-based expansion potential
 */



/*
 * Recommendation 1 — Double down on Retail globally: Retail is growing in every country and every ad type. This isn't a targeted bet, it's your most reliable growth signal. Sales teams should prioritize Retail account expansion and prospecting across all markets.
 * Recommendation 2 — Accelerate investment in Country D: Broad-based growth across nearly all verticals — not just Retail. Suggests an emerging market hitting an inflection point. Recommend dedicating focused sales resources here before competitors do.
 * Recommendation 3 — Watch Health and B2B as emerging verticals: Particularly in Country D where growth rates are extraordinary (+472% and +285% respectively). Small base today but trajectory warrants early attention.
 * Recommendation 4 — Retention play for B2C and Technology: Especially in Countries A and B where these verticals are declining. The Search ad type appears to be where the pullback is concentrated — sales teams should be having proactive conversations with these accounts about Search strategy before the revenue erodes further.
 * 
 * One framing tip for the presentation: Structure it as offense/defense — recommendations 1 and 2 are your offensive plays (where to grow), recommendations 3 and 4 are your defensive plays (what to protect and watch). Sales managers think in those terms naturally. It'll resonate immediately.
 */


--YoY advertiser location (all)
select
    "Advertiser Location",
    round("2024_revenue") as "2024_revenue",
    round("2025_revenue") as "2025_revenue",
    round(("2025_revenue" - "2024_revenue")::numeric) as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
        "Advertiser Location",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
--    where "Advertiser Location" = 'Country D'
    group by 1
) sub
order by "2025_revenue" desc


--YoY Advertiser Location & Industry Vertical
select
    "Advertiser Location",
	"Industry Vertical",
    round("2024_revenue"),
    rank() over (order by "2025_revenue" desc) as "2025_rank",
    round("2025_revenue"),
    round("2025_revenue" - "2024_revenue") as "yoy_change",
    round((("2025_revenue" - "2024_revenue") / nullif("2024_revenue", 0) * 100)::numeric, 2) as "yoy_pct_change"
from (
    select
        "Advertiser Location",
    	"Industry Vertical",
        sum(case when "year" = 2024 then "Revenue" end) as "2024_revenue",
        sum(case when "year" = 2025 then "Revenue" end) as "2025_revenue"
    from combined c
    group by 1, 2
) sub
order by "Advertiser Location", "Industry Vertical"
;
/*Validation that retail is the top vertical across all countries. 2025 revenue:
 	* Country A: $27.8M
 	* Country B: $37.1M
 	* Country C: $20.4M
 	* Country D: $15/1M
 */



/*Justification Advertiser Location vs Ad Location
 * 
 	* Advertiser Location = where the money comes from: This is the sales lens — which markets are your clients based in, where should sales teams focus their account management and prospecting efforts. If Country D advertisers are spending more, that's a sales territory story.
	* Ad Location = where the audience is: This is more of a market/product lens — which geographies are seeing ad consumption grow. Useful for understanding where Acme's ad inventory is being utilized, but less directly actionable for a sales team.
 	* For this specific audience — 2nd and 3rd level sales managers — Advertiser Location is probably more relevant. Their teams sell to advertisers, not to audiences. When a sales manager asks "where should my reps focus?", the answer is about where advertisers are, not where ads are shown.
 */




select
	c."Industry Vertical",
	count(*),
	round(sum("Revenue")) as total_revenue
from combined c 
where
	year = 2025
group by
--	c."Ad Location",
	c."Industry Vertical" 
order by
--	c."Ad Location",
	total_revenue desc
--	c."Industry Vertical" 
;

select * from combined c ;

select 
    "Industry Vertical",
    sum(replace(replace("Revenue", '$', ''), ',', '')::numeric) as summary_revenue
from monthly_summary
where "Industry Vertical" = 'Financial Services'
group by 1;

select "Revenue"
from monthly_summary
where "Revenue" like '$%'
limit 10;







