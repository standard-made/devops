**<h1> STANDARD: ADHOC PIPELINES </h1>**
![standard-automation.png](/src/standard-automation.png)


## <span style="color:#555555"><u> **OVERVIEW** </u></span>
Running adhoc automated regression tests via Azure Pipelines using STANDARD's Self-Hosted Agent (VM: W10-Selenium). The following guide will show you how to perform adhoc regression and automated tests.



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **REQUIREMENTS** </u></span>
- **Azure DevOps Project Pipeline Permissions:** Read, Write, & Execute (R/W/X)



## <span style="color:#555555"><u> **ADHOC TEST RUNS** </u></span>
Permissioned users can edit the 'AdHoc' task groups and pipelines to run different automated Azure Test Plans and Test Suites. Pipelines are appropriately named to reflect the Portal environment the tests will run against (ex: tc-automation-**QA**-adhoc VS tc-automation-**STG**-adhoc).

### <span style="color:#A6A6A6"> **RUNNING ADHOC PIPELINES** </span>

- **<span style="color:gold">ADHOC</span> PIPELINES ONLY:** Do not run or edit other pipelines or task groups without notifying the points of contact above. 
- **<span style="color:red">DO NOT</span>** copy automated test cases into other Project Test Plans. Runs should only be configured to use the [STANDARD: Test Plan](/qa-engineering/wiki/wiki-test-plan.md). Copying into other Test Plans creates duplicate test case items in Azure DevOps and duplicate bindings within TestComplete. 

![new_adhoc.png](/src/assets/new_adhoc.png)

### <span style="color:#A6A6A6"> **CONFIGURING ADHOC PIPELINES** </span>
- **BRANCH:** Specifies which TestComplete branch to use during runtime. Use <development> or <main> branches only. 
- **SCHEDULE:** Specifies date and time of automated run. Click on the Triggers tab and Add a new Scheduled runtime.

![new_adhoc_schedule.png](/src/assets/new_adhoc_schedule.png)

### <span style="color:#A6A6A6"> **CONFIGURING ADHOC TASK GROUPS** </span>
- **TASK GROUPS:** Specifies what tasks to execute during runtime.
   - [QA]()
   - [STG]()

![new_adhoc_taskgroup.png](/src/assets/new_adhoc_taskgroup.png)

### <span style="color:#A6A6A6"> **CONFIGURING ADHOC TASKS** </span>
- **TASKS:** Specifies the desired Azure Test Plan and Test Suite/s from the dropdown. Only edit the middle Visual Studio Test task by selecting the desired Test Suites from the dropdown. **<span style="color:red">DO NOT</span>** edit or uncheck the test items within the 'START' and 'FINISH' folders shown below (these tasks set up, refresh the clean up, environment).

![tc_wiki_adhoc.png](/src/assets/tc_wiki_adhoc.png)
NOTE: You can select multiple Suites within a Test Plan, but you cannot run individual test cases. Rename the AdHoc Run as needed to track project specific testing results and to reference during UAT testing phases. Result Charts can be posted to various project Dashboards for additional tracking.



## <span style="color:#555555"><u> **ADHOC TEST RESULTS** </u></span>
You can view test results from the  or directly from the Test Plan and Test Suite itself by using the Execute tab & create/export test result charts to an Azure Dashboard by using the Charts tab (ex: ).
- **Pipeline Results:** [HERE]() - filter on 'AdHoc'
- **Test Run Results:** [HERE]() - filter on title = 'AdHoc'
- **Test Suite Results:** [HERE]() - change to desired Test Plan as needed
   - **Test Case History:** Double-click any test case within the Execution tab of the Test Suite to see a History of previous runs.
      - **Test Case Results:** Double-click on the test result from the test case's History to view attached log, create a bug, and update the test analysis.
         - **Log Artifact:** Click on the attachment from the individual test case result to open the .MHT log file. This contains the full TestComplete log with events, messages, and screenshots (on errors only).

