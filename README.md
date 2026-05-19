Readme · MD
Copy

# Advertising Analytics: H2 2026 Sales Planning
### Risks & Opportunities | End-to-End Analytical Case Study
 
---
 
## Project Overview
 
This project presents an end-to-end analytical case study simulating a real-world sales planning scenario for a fictional advertising division ("Acme Advertising"). Given a dataset of advertiser revenue across two fiscal halves, the goal was to identify key risks and opportunities to guide sales team priorities for H2 2026.
 
The project demonstrates:
- **SQL data engineering** — joining disparate data sources, handling data quality issues, and building a reusable analytical table
- **Exploratory data analysis** — iterative querying to surface meaningful YoY trends
- **Business insight synthesis** — translating raw findings into actionable recommendations for a sales leadership audience
- **Data storytelling** — communicating insights through an executive-ready presentation
---
 
## Business Context
 
The advertising sales organization works with advertisers across multiple countries, industry verticals, and ad types. Sales leaders needed clarity on where to focus their teams' efforts for the upcoming half.
 
**Key questions driving the analysis:**
- Which industry verticals are growing or declining?
- Which ad types are being underleveraged?
- Which advertiser markets represent the greatest opportunity or risk?
---
 
## Key Insights & Recommendations
 
*The executive summary below captures the two primary findings and four recommendations from this analysis. See the [full presentation](https://docs.google.com/presentation/d/1idoZZNweP3j8wKal7NhYzhr9BK8cpKCOgabo8i3MhjE/edit?usp=sharing) for the complete slide deck.*
 
![Executive Summary](images/slide_02_executive_summary.png)
 
---
 
### Insight 1 — Retail is the Global Growth Engine (Offense)
 
Retail is the largest vertical by revenue ($87.4M → $101.3M, **+16% YoY**) and is growing across every country and every ad type — a remarkably consistent signal.
 
**Recommendation:** Prioritize Retail account expansion and prospecting across all markets.
 
---
 
### Insight 2 — Country D is an Emerging Market Hitting an Inflection Point (Offense)
 
Country D is the fastest growing advertiser market at **+59% YoY**, with broad-based growth across nearly all verticals — not just one driver:
 
- Retail: +68% YoY
- Health: +472% YoY ($333K → $1.9M)
- B2B Services: +285% YoY
**Recommendation:** Dedicate focused sales resources to Country D before competitors do.
 
![Advertiser Location](images/slide_05_advertiser_location.png)
 
---
 
### Insight 3 — B2C and Technology Show Search Pullback (Defense)
 
B2C Services (-3%) and Technology (-2%) are declining, with Search ad spend as the primary driver of pullback. Advertiser-level analysis suggests this is concentrated in a handful of large accounts rather than broad-based churn.
 
**Recommendation:** Sales teams should proactively engage B2C and Technology accounts about Search strategy before further revenue erosion.
 
![Industry Verticals](images/slide_03_industry_verticals.png)
 
---
 
### Insight 4 — MSAN Audience is Underleveraged (Watch)
 
MSAN Audience is the fastest growing ad type by rate (+9%) but has the smallest absolute gain — suggesting clients are not fully utilizing programmatic display, native, and video ad formats.
 
**Recommendation:** Explore with clients why MSAN Audience receives less investment relative to its growth trajectory.
 
---
 
## Dataset
 
Two source tables were provided:
 
| Table | Description |
|-------|-------------|
| `monthly_summary` | Aggregated monthly billed revenue by advertiser, location, industry vertical, and segment |
| `monthly_breakdown` | Monthly billed revenue by advertiser, ad type, and ad location |
 
**Analysis period:** H1 (July–December) 2024 and H1 (July–December) 2025, used as a YoY proxy for H2 2026 planning.
 
**Note on geography:** Advertiser Location refers to the advertiser's billing country, while Ad Location refers to where ads were shown. Advertiser Location was selected as the primary geographic lens since it maps directly to sales territory decisions.
 
---
 
## Tools & Environment
 
- **PostgreSQL** via DBeaver — data storage, cleaning, joining, and analysis
- **Microsoft Excel** — source data validation and cross-referencing
- **PowerPoint** — executive presentation
---
 
## Methodology
 
### Step 1 — Data Infrastructure
 
The two source tables had complementary but non-overlapping dimensions:
 
- `monthly_summary` contained: Advertiser Location, Industry Vertical, Segment
- `monthly_breakdown` contained: Ad Type, Ad Location, Revenue
Neither table alone enabled cross-dimensional analysis (e.g. revenue by vertical AND ad type simultaneously). To solve this, both tables were joined on shared keys (`Advertiser` + `Month Year`) using a CTE-based approach, creating a single unified analytical table.
 
**Key data quality issues resolved:**
- Revenue column in `monthly_summary` contained dollar-formatted strings (e.g. `$2,588`) requiring string replacement before numeric casting
- Minor revenue discrepancies between source tables were identified and reconciled back to source data for final reported figures
- Year and month were extracted from the date field to enable cleaner time-based filtering and grouping
### Step 2 — Exploratory Analysis
 
Iterative SQL queries were used to analyze YoY revenue trends across four dimensions:
 
1. Industry Vertical
2. Ad Type
3. Industry Vertical × Ad Type (cross-dimensional)
4. Advertiser Location
Window functions (`RANK()`) were used to rank performance within groups. Conditional aggregation (`CASE WHEN`) enabled side-by-side YoY comparisons in a single query pass.
 
### Step 3 — Insight Synthesis
 
Findings were synthesized into two primary insights structured as offense and defense:
 
1. **Growth opportunity** — Retail vertical and Country D emerging market
2. **Retention risk** — B2C and Technology declining in Search ad spend
### Step 4 — Presentation
 
Insights and recommendations were packaged into a 7-minute executive presentation targeting 2nd and 3rd level sales managers.
 
---
 
## Analytical Decisions & Assumptions
 
- **Advertiser Location over Ad Location** — selected as the primary geographic lens because it reflects where sales teams prospect and manage accounts, making it more actionable for a sales manager audience
- **H1 2024 vs H1 2025 as YoY proxy** — used to control for seasonality when projecting H2 2026 trends
- **Advertiser-level analysis excluded from presentation** — too granular and noisy for a 7-minute executive presentation; used internally to validate vertical-level findings
- **Revenue reconciled to source data** — minor discrepancies between joined table and source Excel were identified and corrected to ensure accuracy of reported figures
---
 
## SQL Files
 
| File | Description |
|------|-------------|
| `01_create_combined_table.sql` | CTE-based join of summary and breakdown tables into unified analytical table |
| `02_analysis_queries.sql` | All YoY analysis queries with inline commentary |
 
---
 
## Reflections
 
**What I would do with more time:**
- Analyze monthly trends within each half to determine whether declines are accelerating or stabilizing
- Segment analysis — exploring whether B2C and Technology pullback is concentrated in specific account tiers
- Projection modeling using rolling averages or YoY growth extrapolation to quantify expected H2 2026 revenue
**What I learned:**
- Joining tables with different grains requires careful validation — revenue totals should always be cross-referenced against source data
- Dollar-formatted string values in numeric columns are a common data quality issue worth checking early in any analysis
- The most actionable insights often come from cross-dimensional analysis that no single source table can answer alone
---
 
## Repository Structure
 
```
├── README.md
├── sql/
│   ├── 01_create_combined_table.sql
│   └── 02_analysis_queries.sql
├── images/
│   ├── slide_02_executive_summary.png
│   ├── slide_03_industry_verticals.png
│   └── slide_05_advertiser_location.png
└── presentation/
    └── acme_advertising_h2_2026.pdf
```
 
---
 
*This project was completed as an independent analytical exercise. All company names, advertiser IDs, and geographic references are anonymized or fictional.*
