**<h1> STANDARD: RELEASE PLAN TEMPLATE </h1>**
![standard-wiki.png](/src/standard-wiki.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
Below you will find supporting references, project timelines, and formal descriptions for all current projects and work items included in the STANDARD: Q1 Release Plan.



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
Please contact the associated personnel for general information or support.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **TIMELINE** </u></span>
<span style="color:#A6A6A6"> **Q1.2022 [JAN - MAR]** </span>

``` mermaid
gantt
title STANDARD: Release Plan Q1
dateFormat YYYY-MM-DD

section example A
FCAs - Phase 1 :a1, 2021-12-27, 21d
Go Live :a1, 2022-01-14, 7d

section example B
Wires - Phase 1 :a1, 2022-01-21, 21d
Go Live :a1, 2022-03-01, 7d

section example C
HA & Health Checks :a1, 2022-02-07, 21d

section APIM
21x5 Wires (v2) :a1, 2022-01-17, 21d
21x5 Wires (v3) :a1, 2022-02-17, 21d
SEN Updates (v2/v3) :a1, 2022-01-17, 21d

section PORTAL
Sierra Settlement Dates :a1, 2022-01-14, 19d

```



## <span style="color:#555555"><u> **BREAKDOWN** </u></span>

### <span style="color:#A6A6A6">JANUARY</span>
- **<span style="color:gold">COMPLETE</span>** - API v3
   - Add GET loan balance and cash mgr
   - P006
- **<span style="color:gold">COMPLETE</span>** - Portal
   - P006
- **<span style="color:gold">COMPLETE</span>** - CDDC (v2 and v3)
   - edge case fix

### <span style="color:#A6A6A6">FEBRUARY</span>
- **<span style="color:gold">COMPLETE</span>** - Portal nights/weekends Sierra settlement date fix (2/3/22)
- **<span style="color:gold">COMPLETE</span>** API v2 10.7.3 (2/8/22 target)
   - Euro vs USD SEN protection add 
   - API v2 SEN "locking" 
   - SEN logging
   - SEN locking and idempotency 
   - GET payment parsing edge case

### <span style="color:#A6A6A6">MARCH</span>
- WLS (3/9/22)
   - Error handling improvement critical for ongoing BCP stance
   - .NET upgrade
   - Email notices upon error
- Portal P010 – mid March
- API v2 and API v3 21 x 5 wire update (3/31/22)

### <span style="color:#A6A6A6">APRIL</span>
- API v3 BCP additions (mid April)