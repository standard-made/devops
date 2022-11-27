**<h1> STANDARD: PIPELINES w/SELF-HOSTED-AGENTS </h1>**
![standard-automation.png](/src/standard-automation.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
STANDARD's Partner Portal automated regression testing is run via Azure Pipelines using STANDARD's Self-Hosted Agent (VM: W10-Selenium), but can be also configured to run on Microsoft-Hosted Agents. See [STANDARD: Azure Pipelines on Microsoft-Hosted Agents](/qa-engineering/wiki/tc-mshosted-pipelines.md) for more info. 

Currently there are 8 TestComplete Automation Pipelines configured to run within the STANDARD: DevOps Project. 4 are set to run against the QA environment, with the other 4 running against STG.

High level results from any pipeline run can be viewed from the Azure testManagement page and filtering the results by using 'Title' [Contains] 'tc-automation' **OR** by clicking on the Execute tab from within a selected Test Plan Suite (EX: **FX Suite**) - Azure displays the latest results by default.

1. <u>Regression</u> - runs the [Portal Regression Suite]() Azure Test Plan Suite every morning except Friday) at 3AM & 5AM PST.
   - QA
      - Name: [tc-automation-qa-regression]() 
      - Schedule: **<span style="color:green">Monday - Friday @ 1:30AM PST</span>**
   - STG
      - Name: [tc-automation-stg-regression]() 
      - Schedule: **<span style="color:green">Monday - Friday @ 3:30AM PST</span>**
2. <u>All</u> - runs all [Portal Regression Automation]() completed Azure Test Plan Suites.
   - QA
      - Name: [tc-automation-qa-all]() 
      - Schedule: **<span style="color:green">Tuesday & Thursday @ 7:00PM PST</span>**
   - STG
      - Name: [tc-automation-stg-all]() 
      - Schedule: **<span style="color:green">Tuesday & Thursday @ 9:00PM PST</span>**
3. <u>AdHoc</u> - runs one off tests and can be used by permissioned team members to initiate adHoc automated testing. See more info below in **Task Groups**.
4. <u>Release</u> - all 'Release' task groups are meant to run in Release Pipelines only (EX: Portal), as the Log Artifact task is disabled to conform with Azure release pipeline limitations.



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **REQUIREMENTS** </u></span>
- TestComplete projects must be prepared as described [Prepare TestComplete Project for Integration](https://support.smartbear.com/testcomplete/docs/working-with/integration/azure/test-adapter/prepare-tc-project.html) and added to the team project’s [qa-automation]() repository.
- Test agents on which you will run tests must have TestComplete (or TestExecute) installed.
- Team project in Azure DevOps must have the [TestComplete Test Adapter]() extension installed.



## <span style="color:#555555"><u> **AGENT VM (SELF-HOSTED)** </u></span>
### <span style="color:#A6A6A6"> **OVERVIEW** </span>
Running TestComplete test suites manually on the VM or via the <u>tc-automation-sgb-agent</u> pipeline
- IP: 13.91.218.207
- Agent: W10-Selenium 
- Pool: AgentTC 
- Image: Windows 10 Pro
- RunAs: 'SeleniumUser'

### <span style="color:#A6A6A6"> **PREREQUISITES** </span>
- Windows 7, 8.1, or 10 (if using a client OS)
- Windows 2008 R2 SP1 or higher (if using a server OS)
- PowerShell 3.0 or higher
- .NET Framework 4.6.2 or higher
- Visual Studio build tools (2015 or higher)
- Configure Agent's User Permissions - see [Microsoft Documentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-windows?view=azure-devops)
- Establish Database Connection - see [TestComplete Database Connections](/TestComplete-Automation/Database-Connections)

### <span style="color:#A6A6A6"> **SGB AGENT SETUP** </span>
1. Create a new Agent Pool in the [Azure DevOps Team Project]()
2. Open the new Agent Pool and go to the Agents tab to create a New Agent
   - download the agent packet and copy it to the C:\ of the VM listed below
3. Launch the VM to be used as the Self-Hosted Agent (W10-Selenium)
4. Open PowerShell as Admin
5. Run the following commands in order:
``` ps
cd C:\
mkdir agent ; cd agent
Add-Type -AssemblyName System.IO.Compression.FileSystem ; [System.IO.Compression.ZipFile]::ExtractToDirectory("$HOME\vsts-agent-win-x64-2.194.0.zip", "$PWD")
.\config.cmd --unattended --url "https://standard.visualstudio.com/" --auth pat --token "<enter token>" --pool AgentTC --runAsAutoLogon --windowsLogonAccount "<enter user>" --windowsLogonPassword "<enter password>" --overwriteAutoLogon
```
NOTE: when working through the configuration steps in PowerShell, do NOT opt to run the agent as a service. The agent will be run interactively either through the pipeline or manually on the VM using the PowerShell command below:
``` ps
cd C:\
cd agent
.\run.cmd
```



## <span style="color:#555555"><u> **TASK GROUPS AND PIPELINES** </u></span>
### <span style="color:#A6A6A6"> **OVERVIEW** </span>
There are several Task Groups and Pipelines currently configured. Each is set to run different Test Plans in Azure DevOps at differently scheduled times. Below is a breakdown of each and their associated YAML markup.



### <span style="color:#A6A6A6"> **TESTCOMPLETE PIPELINES** </span>
Pipelines are configured to run a specific task group during runtime. See additional information below:
- [Azure DevOps Pipelines](https://standard.visualstudio.com/DevProjects/_taskgroups)

![tc_wiki_pipelines.png](/src/assets/tc_wiki_pipelines.png)



### <span style="color:#A6A6A6"> **TESTCOMPLETE TASK GROUPS** </span>
Task groups are configured to run a group of different tasks within a pipeline. All TestComplete Task Groups will be managed and maintained by QA Engineering except for 'AdHoc' - which can be utilized by permissioned team members to run one off tests. See [AdHoc Pipelines](/TestComplete-Automation/AdHoc-Pipelines) for more info.
- [Azure DevOps Task Groups](https://standard.visualstudio.com/DevProjects/_taskgroups)

![tc_wiki_task_groups.png](/src/assets/tc_wiki_task_groups.png)



### <span style="color:#A6A6A6"> **PIPELINE YAML** </span>
Example YAML for task group [Run TestComplete Automation QA - Regression]
``` yaml
pool: 
  name: AgentTC
steps:
- task: VisualStudioTestPlatformInstaller@1
  displayName: 'Visual Studio Test Platform Installer'
  inputs:
    versionSelector: latestStable

- task: SmartBearSoftware.install-testcomplete-adapter-task.install-testcomplete-adapter-task.InstallTestCompleteAdapter@1
  displayName: 'TestComplete test adapter installer'
  inputs:
    preferredExecutor: TC
    installExecutor: false
    updateExecutor: false
    accessKey: '$(access-key)'
    logsLevel: 0

- task: VSTest@2
  displayName: 'VsTest - testPlan QA Regression'
  inputs:
    testSelector: testPlan
    testPlan: 15366
    testSuite: '18021,16105'
    testConfiguration: 16
    uiTests: true
    vsTestVersion: toolsInstaller
    failOnMinTestsNotRun: false
    rerunFailedTests: false
  continueOnError: true

- task: PublishPipelineArtifact@1
  displayName: 'Publish TestComplete Log Artifact'
  inputs:
    targetPath: '$(System.DefaultWorkingDirectory)\Standard\Log'
  condition: succeededOrFailed()

- powershell: |
   # restart w10-selenium vm
   shutdown /r /t 60
   
  displayName: 'Restart Agent VM'
  condition: always()
```