**<h1> STANDARD: SPRINT PLANNING TEMPLATE </h1>**
![standard-wiki.png](/src/standard-wiki.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
Below you will find supporting references, sprint timelines, and resources used in the STANDARD: DevProjects <i>Sprint Planning Cycle</i>.
- <span style="color:#A6A6A6"> **CURRENT SPRINT:** </span> **[58]**



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
Please contact the associated personnel for general information or support.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **GOALS** </u></span>
1. P010
   - Finish UAT, fix any new bugs
   - User Activity Report (PowerBI) prod prep
   - Prod Prep (release notes, procedures, etc.).  Taryn creating PBI

Note: remind testers not to touch customer settings

2. API v2 and v3 21 x 5
   - updates to end of day job
   - send customer notice by 3/2

Needs further discussions on updates (there are some changes that Dina introduced; may need to be discussed with Simon)

3. WLS Improvements
   - Stage and prod publish (testing, communication, change ctl, etc.)

4. P026
   - HA. Blocked for Horizon-related networking.
   - AKS. Finish ISTIO
   - Service Bus Removal. Testing is in progress
   - Partner API and Scheduled Jobs need to be added for Service Bus Removal
   - AKS Logging and Monitoring

5. Backlog Crushing
   - Unit testing on controllers
   - Security Findings (ongoing) ARE THERE ANY > "low"?
   - Documentation to tie to YAML; Dave will take a look at PBIs (Dave)
   - Portal Regression QA and Stage Reporting Results; use nightly report. Add to baseline QA and Stage if possible (Keith)
   - API v3 Postman Collection build out
   - Pipeline and Gitflow research (Cam)

**Pre-GROOMING (These need requirements)**

----------------

1. Internal Transfers via FX (EUR to USD and USD to EUR between owned SI accounts) in Partner API
   - presenting to Simon
   - finish it out for pre-grooming

2. Mass Payments Enablement (Wire Upload) via Portal

3. Viewing Statements from within Portal
   - needs re-engagement with FIS

4. GBP ClearBank Flows
   - we can get a head-start on this; think about spikes for this effort




## <span style="color:#555555"><u> **TIMELINE** </u></span>
<span style="color:#A6A6A6"> **Q1: SPRINT 55 (12.27.21 - 1.14.22) > SPRINT 58 (2.28.22 - 03.18.22)** </span>
::: mermaid
gantt
title Silvergate Sprint Breakdown Q1
dateFormat YYYY-MM-DD

section Sprint 55
APIM - GET Updates (v3) :a1, 2021-12-27, 21d
CDDC - Date/Time Fix :a1, 2021-12-27, 21d
P006 - New APIv3 Endpoints :a1, 2021-12-27, 21d
P006 - Documentation :a1, 2021-12-27, 21d
PORTAL - Automation | Regression Suite :a1, 2021-12-27, 21d

section Sprint 56
APIM - SEN Updates (v2/v3) :a1, 2022-01-17, 21d
APIM - 21x5 Wire Update (v2) :a1, 2022-01-17, 21d
P010 - Idempotency & PowerBI :a1, 2022-01-17, 21d
P010 - Sierra Settlement Dates :a1, 2022-01-17, 21d
PORTAL - Automation | SEN Suite :a1, 2022-01-17, 21d
WLS - Improvements :a1, 2022-01-17, 21d

section Sprint 57
APIM - BCP Additions (v3) :a1, 2022-02-07, 21d
P010 - UAT & PROD Prep :a1, 2022-02-07, 21d
P026 - Updates & Improvements :a1, 2022-02-07, 21d
PORTAL - Automation | STG Config :a1, 2022-02-07, 21d
WLS - Improvements Cont. :a1, 2022-02-07, 21d


section Sprint 58
APIM - 21x5 Wire Update (v3) :a1, 2022-02-28, 21d
P010 - UAT & PROD Push :a1, 2022-02-28, 21d
P026 - HA & AKS :a1, 2022-02-28, 21d
PORTAL - QA/STG Regression Automation :a1, 2022-02-28, 21d
WLS - STG & PROD Push :a1, 2022-02-28, 21d
:::



## <span style="color:#555555"><u> **PLANNING** </u></span>
::: query-table 81bdf9b8-180d-4679-86b3-c95286ae71df
:::




## <span style="color:#555555"><u> **GROOMING** </u></span>
- ### [STORY SIZER](https://scrum.reedtaylor.org/)
PRE-GROOMING
1. Internal Transfers via FX (EUR to USD and USD to EUR between owned SI accounts) in Partner API
2. Mass Payments Enablement (Wire Upload)
3. Viewing Statements from within Portal
::: query-table abb5ade2-9daa-46f8-b7f7-b85e0b21505e
:::



## <span style="color:#555555"><u> **RETROSPECTIVE** </u></span>
- ### [ICE BREAKERS](https://www.mentimeter.com/app)
- ### [DEVOPS RETRO](https://silvergate.visualstudio.com/DevProjects/_apps/hub/ms-devlabs.team-retrospectives.home)