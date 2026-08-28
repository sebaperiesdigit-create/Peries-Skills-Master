# Strategy Output Template Reference

The full report template, in the fixed order required by SKILL.md's Output format. Fill every bracket from actual supplied/researched evidence; never invent a value. Label every material line **Confirmed fact**, **Research finding**, **Calculation**, **Recommendation**, **Assumption ⚠️**, or **Not assessed** per Domain rules in SKILL.md.

```markdown
# E-commerce Marketing Strategy — [business/product name]

## 1. Business Snapshot and Scope
Product: [name] | Price/AOV: $XX | Margin: XX%
Stage: [new/early/growing/scaling] | Budget: $X,XXX/mo
Goal: [awareness / sales / both]
Sales channels: [where they sell]
Priority product-market combination: [if multiple were in scope, state which one this full strategy covers]
Target market/language/currency: [context]

## 2. Evidence, Assumptions, Conflicts, and Unassessed Areas
- Sources inspected: [URLs/files/exports, and inspection date]
- Assumptions made ⚠️: [list, with what real data would replace each]
- Conflicting data found: [value A (source) vs. value B (source) — resolution or labelled scenario used]
- Not assessed: [areas with no usable evidence]

## 3. Target Audience Persona

🎯 TARGET AUDIENCE PERSONA

Demographics:
  Age: [range] | Gender: [split %] | Location: [markets] | Income: [range]
  Source: [Confirmed fact from user data / Assumption ⚠️ inferred from product-price-platform / Research finding from competitor analysis]

Psychographics:
  Interests: [relevant interests]
  Values: [what they care about]
  Pain points: [problems the product solves]
  Buying motivation: [price/value, quality/premium, uniqueness, convenience]

Online behavior:
  Where they discover products: [Instagram, Google, TikTok, Amazon, etc.]
  Where they research: [reviews, YouTube, Reddit, blogs]
  What influences purchase: [price, reviews, brand, influencer recommendation]

Language they use:
  [Real phrases from reviews/social media, if available — how they describe the problem and solution in their own words]
  Source: [extracted from competitor reviews / user-provided / Assumption ⚠️]

Buyer journey: [awareness → consideration → purchase → retention, with the channel/touchpoint most relevant at each stage for this specific audience]

## 4. Competitive Landscape and Differentiation Opportunities

📊 COMPETITIVE LANDSCAPE

Market price range: [$low — $high] (source: [Research finding / user-supplied])
Your position: [where they sit and why]

Top competitors:
  [Competitor 1]:
    Price: $XX | Positioning: [how they position] | Source: [Research finding, date]
    Strengths: [from reviews/research]
    Weaknesses: [from reviews/research]
    Marketing channels: [where they're active]

  [Competitor 2]: [same structure]

Market gaps: [underserved segments, unmet needs, positioning opportunities]
Your differentiation: [what makes this business different, and how to communicate it]

## 5. Pricing Position or Pricing-Validation Plan
[Evidence-supported price position relative to the competitive landscape above, OR — if evidence doesn't support a specific position yet — a validation plan: what to test, how, and what result would confirm a position. Never an invented exact selling price.]

## 6. Channel Assessment and Prioritized Channels
[All relevant channels assessed briefly; then the 2-4 prioritized channels for the next 90 days, each using `channel-guidance.md`'s structure for that channel, with budget % from `marketing-benchmarks.md` adjusted to this business's actual budget.]

Deferred channels: [channel — why deferred — condition that would justify revisiting]

## 7. Budget and Profitability Scenarios
[If economics are confirmed: budget split across prioritized channels with expected CAC/profit-per-order math shown as a Calculation.
If economics are incomplete: 2-3 clearly labelled scenarios (e.g. "if margin is X%..." / "if repeat purchase rate is Y%..."), naming the specific unknowns driving each scenario — returns, fulfilment, shipping, discounts, tax, payment/platform fees, repeat purchase rate.]

## 8. Action Plan: Days 0-30, 31-60, 61-90

📅 90-DAY ACTION PLAN

DAYS 0-30: Foundation
  [Setup actions, first channel launch, tracking in place]

DAYS 31-60: Optimize & Expand
  [Optimize what's working, cut what isn't, launch second-wave channels]

DAYS 61-90: Scale
  [Scale proven channels, launch referral/loyalty if the customer base supports it, full review]

KEY MILESTONES:
  Day 30: [target, tied to a KPI in section 10]
  Day 60: [target]
  Day 90: [target]

(Adjust the 0-30/31-60/61-90 horizon only if a stated launch date, seasonal event, cash runway, or goal materially requires it — state the reason if adjusted.)

## 9. Owners, Weekly Capacity, Required Assets, and Deferred Work
Owners: [who's actually doing this work — names/roles as given, never assumed]
Weekly capacity: [hours/week available, per owner if known]
Required assets not yet in place: [what needs to be created/set up before a channel can launch]
Do now / Defer / Optional outsource: [split the action plan's items into these three buckets]

## 10. Baseline, KPIs, Review Cadence, and Thresholds
| Metric | Baseline (if known) | Target | Review cadence | Continue / Fix / Pause / Test threshold |
|---|---|---|---|---|
| [metric per prioritized channel] | [Confirmed fact or Not assessed] | [Calculation from marketing-benchmarks.md, adjusted to this business] | [weekly/monthly] | [what result triggers which action] |

## 11. Optional Specialist Handoffs and Next Evidence to Collect
- For page-level SEO diagnosis on a specific product page → `ecommerce-seo-auditor` (optional, not required).
- For AI-shopping/AI-search visibility readiness → `ecommerce-geo-auditor` (optional, not required).
- For ongoing KPI tracking once this strategy is live → `ecommerce-sales-tracker` (optional, not required).
- Next evidence that would most improve this strategy: [specific gaps from section 2]
```
