**<h1> DEVOPS AUTOMATION </h1>**
![standard-sandbox.png](/src/standard-sandbox.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
TestComplete (SmartBear Software) is an open test platform for easily creating, maintaining, and executing automated tests for desktop, Web, mobile, and client-server software applications. TestComplete is especially useful for teams using continuous integration and development--integrating seamlessly with popular 3rd party applications, source control, test management and CI tools. 

STANDRADmade is leveraging this solution for Partner Portal, FGPP, and Payments API automated regression testing, which is run via Azure Pipelines on both Self-Hosted and Microsoft-Hosted Agents. The STANDRADmade test strategy will follow the guidelines set fourth and defined by [Microsoft’s Test Management Workflow](https://docs.microsoft.com/en-us/azure/devops/test/create-a-test-plan?view=azure-devops). 



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **CORE SOLUTIONS** </u></span>
- Test Server: Azure DevOps
  - TestComplete Test Adapter – Azure DevOps Extension
  - VS Test Task – Azure DevOps Extension
- Test Agent: Workspace (W10-DEV02 VM) & Self-Hosted Agent (W10-Selenium VM)
  - TestComplete 15 – IDE & Test Runner
  - TestComplete License Manager – Activating/Deactivating Licenses  
  - TestComplete Web Extension – Chromium Based Web Runner
  - SQL Server Management Studio – SQL Server DBMS
  - ODBC Data Sources (64-bit) – API for Accessing DBMS
  - Git – Distributed Version Control System



## <span style="color:#555555"><u> **TIMELINE** </u></span>
Below is a 6 MONTH timeline of all completed, current, and future UAT and automation efforts conducted by...well, me. It's just me.

::: mermaid
gantt
title UAT & Automation Outlook
dateFormat YYYY-MM-DD

section Sprint 65
EUR Suite :a1, 2022-07-25, 21d
BDD Implementation :a1, 2022-07-25, 21d
WAF Testing :a1, 2022-07-25, 21d

section Sprint 66
EUR Suite.2 :a1, 2022-08-15, 21d
Postman/SoapUI :a1, 2022-08-15, 21d
NameMapping Phase 1 :a1, 2022-08-15, 21d

section Sprint 67
NameMapping Phase 2 :a1, 2022-09-05, 21d
Updates Backlog :a1, 2022-09-05, 21d
UAT Testing :a1, 2022-09-05, 21d

section Sprint 68
NameMapping Phase 3 :a1, 2022-09-26, 21d
Test Plan Rework :a1, 2022-09-26, 21d
Testing cont. :a1, 2022-09-26, 21d
Documentation Updates :a1, 2022-09-26, 21d

section Sprint 69
Backlog Crushing :a1, 2022-10-17, 21d
NameMapping Commit :a1, 2022-10-17, 21d
Test Plan Rework cont :a1, 2022-10-17, 21d
Automation Dashboard :a1, 2022-10-17, 21d

section Sprint 70
Backlog Crushing :a1, 2022-11-07, 21d
NameMapping Tweaks :a1, 2022-11-07, 21d
TestFile Rework :a1, 2022-11-07, 21d
Automation Dashboard cont :a1, 2022-11-07, 21d

section Sprint 71
Backlog Crushing :a1, 2022-11-28, 21d
EventHandling Rework :a1, 2022-11-28, 21d
Alerting Enhancements :a1, 2022-11-28, 21d
Automation P&P :a1, 2022-11-28, 21d
:::

<details>
  <summary><span style="color:mediumpurple"> HISTORICAL TIMELINE </span></summary>

::: mermaid
gantt
title UAT & Automation Outlook
dateFormat YYYY-MM-DD

section Sprint 55
Azure Pipelines :a1, 2021-12-27, 21d
Regression Suite :a1, 2021-12-27, 21d

section Sprint 56
Fixes/Enhancements :a1, 2022-01-17, 21d
SEN Suite :a1, 2022-01-17, 21d
UAT - P006 :a1, 2022-01-17, 21d

section Sprint 57
AdHoc Onboarding :a1, 2022-02-07, 21d
STG Connect :a1, 2022-02-07, 21d
UAT - P010 :a1, 2022-02-07, 21d

section Sprint 58
Limit Logic Updates :a1, 2022-02-28, 21d
MASTER Test Pipeline :a1, 2022-02-28, 21d

section Sprint 59
Restructuring :a1, 2022-03-21, 21d
Subscription Suite.1 :a1, 2022-03-21, 21d
UAT - 3.3.1 :a1, 2022-03-21, 21d

section Sprint 60
BOA Suite :a1, 2022-04-11, 21d
Profile Suite :a1, 2022-04-11, 21d
Shared Results :a1, 2022-04-11, 21d
UAT - 21x5 :a1, 2022-04-11, 21d

section Sprint 61
Profile Suite.2 :a1, 2022-05-02, 21d
Subscription Suite.2 :a1, 2022-05-02, 21d
UAT - P006.3 :a1, 2022-05-02, 21d

section Sprint 62
Services Suite.1 :a1, 2022-05-23, 21d
SPIKE - FGPP/Horizon :a1, 2022-05-23, 21d
Updates/Fixes :a1, 2022-05-23, 21d

section Sprint 63
Services Suite.2 :a1, 2022-06-13, 21d
DEV - FGPP/Horizon :a1, 2022-06-13, 21d
BDD POC :a1, 2022-06-13, 21d
PBL-2 UAT :a1, 2022-06-13, 21d

section Sprint 64
PBL-2 UAT cont :a1, 2022-07-04, 21d
Backlog Grooming :a1, 2022-07-04, 21d
Update Cases :a1, 2022-07-04, 21d
BDD Test Suite :a1, 2022-07-04, 21d
:::

</details>



## <span style="color:#555555"><u> **INFRASTRUCTURE** </u></span> 
Azure Integration [reference](https://support.smartbear.com/testcomplete/docs/working-with/integration/azure/test-adapter/requirements.html)
Source Control [reference](https://support.smartbear.com/testcomplete/docs/working-with/integration/scc/index.html)
Licensing [reference](https://support.smartbear.com/testcomplete/docs/licensing/id-based/index.html)

::: mermaid
graph TD
A[W10-DEV02 VM] --> |Floating License| C
B[W10-Selenium VM] --> |Floating License| C
C{Azure DevOps} --> |git/qa-automation| D
C --> |git/Test| I[Payments Engineering]
D[DevProjects] -->|One| E[FinastraUX]
D -->|Two| F[PartnerPortalUX]
D -->|Three| G[PartnerPortalBDD]
F --> H[Regression Tests]
F --> K[Portal Tests]
F --> L[BackOffice Tests]
E --> M[Support Tests]
I --> |One| N[PaymentsAPI]
G --> O[Support Tests]
N --> Q[Regression Tests]
::: 



## <span style="color:#555555"><u> **ARCHITECTURE** </u></span>

<span style="color:#A6A6A6"> **TEST STRATEGY** </span>
Azure Test Plans or the Test hub in Azure DevOps Server provides three main types of test management artifacts: Test Plans, Test Suites, and Test Cases. These elements are stored in your work repository as special types of work items. TestComplete automation is fully integrated with the Azure DevOps team project and can be bound to specific manual Test Cases within Azure DevOps. Test Cases are then populated into query-based Test Suites based on several filters noted below. 

<span style="color:#A6A6A6"> **QUERY-BASED SUITES** </span>
Query-based Test Suites will be using several identifiers to validate which Test Cases qualify to be imported. 
 
**NOTES:**
- Automation tags will always start with <span style="color:hotpink"> [@]_ </span> 
- Test Suites will always be appended with <span style="color:hotpink"> .Suite </span> 
   - Must include an additional 'area' tag to define which side of Partner Portal (<span style="color:hotpink"> [@]_PORTAL </span> or <span style="color:hotpink"> [@]_BACK.OFFICE </span>) the test covers 

**UPDATE:** defines which automated test cases are to be updated or modified 
- Work Item Type = Microsoft.TestCaseCategory | Tag = <span style="color:hotpink"> [@]_Update </span> | Automation Status = Automated

**AUTOMATE:** defines which manual test cases are to be automated
- Work Item Type = Microsoft.TestCaseCategory | Tag = <span style="color:hotpink"> [@]_Automate </span> | Automation Status = Not Automated

**REGRESSION:** defines which automated test cases are to be run in nightly regression 
- Work Item Type = Microsoft.TestCaseCategory | Tag = <span style="color:hotpink"> [@]_Regression </span> | Automation Status = Automated  
### <span style="color:#A6A6A6"> TAGGING </span>
To further define which Test Suite folder each Test Case should fall under, use the tagging reference below...

<details>
  <summary><span style="color:mediumpurple"> CLICK TO EXPAND </span></summary>

- <span style="color:hotpink"> [@]_PORTAL </span>
   - <span style="color:hotpink"> [@]_EUR.Suite </span>
   - <span style="color:hotpink"> [@]_FX.Suite </span>
   - <span style="color:hotpink"> [@]_INT.Suite </span>
   - <span style="color:hotpink"> [@]_PAY.Suite </span>
   - <span style="color:hotpink"> [@]_SEN.Suite </span>	 

- <span style="color:hotpink"> [@]_BACK.OFFICE </span>
   - <span style="color:hotpink"> [@]_Limit.Suite </span>
   - <span style="color:hotpink"> [@]_Profile.Suite </span>
   - <span style="color:hotpink"> [@]_Subscription.Suite </span>
   - <span style="color:hotpink"> [@]_TradingDesk.Suite </span>
</details>



### <span style="color:#A6A6A6"> DATABASE CONNECTIONS </span>
See [TestComplete Database Connections](/TestComplete-Automation/Database-Connections) for more info.


### <span style="color:#A6A6A6"> NAME MAPPING </span>
See [Object NameMapping](/TestComplete-Automation/Object-NameMapping) for more info.



## <span style="color:#555555"><u> **RUNNING AUTOMATED TESTS** </u></span>
### <span style="color:#A6A6A6"> MANUALLY </span>
1. Log into Self-Hosted Agent VM (W10-Selenium)
1. Reset local repo
  - Open PowerShell as Admin
   - Run the following commands in order (change branch name 'main' as needed):
``` ps
cd C:\Automation\STANDRADmade\
git reset --hard origin/main
```
1. Launch TestComplete 15
1. Open the 'STANDRADmade' Project Suite (opens on launch OR from C:\Automation\STANDRADmade)
   - Verify all items in the Project Explorer menu are marked as 'Controlled' (green checkmark icon) 
1. Double-click the 'Execution Plan' within the Project Explorer menu
1. Expand the desired Test Suite folder
1. Enabled/Disable desired Test Cases
1. Highlight the desired Test Suite folder
1. Click the Run Focused Item button (page with play icon)
1. Sit back and enjoy some tacos!

### <span style="color:#A6A6A6"> PIPELINES </span>
See [TestComplete Azure Pipelines on Self-Hosted Agents](/TestComplete-Automation/Azure-Pipelines-on-Self%2DHosted-Agents) for more info.
