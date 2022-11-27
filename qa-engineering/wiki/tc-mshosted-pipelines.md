**<h1> TESTCOMPLETE PIPELINES w/MICROSOFT-HOSTED-AGENTS </h1>**
![standard-automation.png](/src/standard-automation.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
Standard's Partner Portal automated regression testing is run via Azure Pipelines using Standard's Self-Hosted Agent (VM: W10-Selenium), but can be also configured to run on Microsoft-Hosted Agents. Below is more information regarding how to set up and configure TestComplete pipelines to run using a Microsoft-Hosted Agent. 



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **MS AGENT VM (MICROSOFT-HOSTED)** </u></span>
### <span style="color:#A6A6A6"> **OVERVIEW** </span>
Running automated test cases specified in the TestComplete Execution Plan and executed via an Azure pipeline.
- IP: obtained at runtime
- Agent: Hosted-Agent
- Pool: Azure Pipelines
- Image: windows-2019 
- RunAs: 'VssAdministrator'

### <span style="color:#A6A6A6"> **PREREQUISITES** </span>
- Windows 7, 8.1, or 10 (if using a client OS)
- Windows 2008 R2 SP1 or higher (if using a server OS)

### <span style="color:#A6A6A6"> **MS AGENT SETUP** </span>
1. Agent and test environment are created at runtime using the default MS hosted-agent specifications - see [Microsoft Documentation](https://github.com/actions/virtual-environments/blob/win19/20211018.0/images/win/Windows2019-Readme.md)
1. The IP address of the MS agent VM used in the pipeline also needs to be whitelisted. This is done by the following tasks noted in the YAML below: *Get Agent IP, Add IP, and Remove IP*.
1. By default, SQL Native Client 11 is not pre-installed on the MS agent. This is used by ADO (ActiveX Data Objects) to establish a connection to the Standard data sources exposed through OLE DB and ODBC (currently we use OLEDB). This is done by the following tasks noted in the YAML below: *Get OLEDB Providers, Download and Install SSMS, and Get OLEDB Providers Again*.
1. Screen resolution needs to be set prior to the TestAssembly task. This is done by the following tasks noted in the YAML below: *Set Screen Resolution*

### <span style="color:#A6A6A6"> **MS AGENT PIPELINE YAML** </span>
``` yaml
pool:
  name: Azure Pipelines
  demands: InteractiveSession

#Your build pipeline references an undefined variable named ‘curl -s https://api.ipify.org’. Create or edit the build pipeline for this YAML file, define the variable on the Variables tab. See https://go.microsoft.com/fwlink/?linkid=865972
#Your build pipeline references an undefined variable named ‘ip’. Create or edit the build pipeline for this YAML file, define the variable on the Variables tab. See https://go.microsoft.com/fwlink/?linkid=865972
#Your build pipeline references an undefined variable named ‘ip’. Create or edit the build pipeline for this YAML file, define the variable on the Variables tab. See https://go.microsoft.com/fwlink/?linkid=865972

steps:
- bash: |
   IP=$(curl -s https://api.ipify.org)
   echo Agent IP is $IP
   echo "##vso[task.setvariable variable=ip]$IP"
  displayName: 'Get Agent IP'

- task: AzureCLI@2
  displayName: 'Add IP'
  inputs:
    azureSubscription: 'Unified Architecture (<access key>)'
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: 'az sql server firewall-rule create -g rg-shared-api-qa -s sql-Standard-apis-shared-qa -n azure-pipeline --start-ip-address $(ip) --end-ip-address $(ip)'

- powershell: |
   # get list of oledb providers to see if ssms is installed
   foreach ($provider in [System.Data.OleDb.OleDbEnumerator]::GetRootEnumerator())
   {
       $v = New-Object PSObject        
       for ($i = 0; $i -lt $provider.FieldCount; $i++) 
       {
           Add-Member -in $v NoteProperty $provider.GetName($i) $provider.GetValue($i)
       }
       $v
   }
  displayName: 'Get OLEDB Providers'

- powershell: |
   # set file and folder path for SSMS installer .exe
   $folderpath="c:\windows\temp"
   $filepath="$folderpath\SSMS-Setup-ENU.exe"
    
   #If SSMS not present, download
   if (!(Test-Path $filepath)){
   write-host "Downloading SQL Server Management Studio..."
   $URL = "https://aka.ms/ssmsfullsetup"
   $clnt = New-Object System.Net.WebClient
   $clnt.DownloadFile($url,$filepath)
   Write-Host "SSMS installer download complete" -ForegroundColor Green
    
   }
   else {
   write-host "Located the SQL SSMS Installer binaries, moving on to install..."
   }
    
   # start the SSMS installer
   write-host "Beginning SSMS install..." -nonewline
   $Parms = " /Install /Quiet /Norestart"
   $Prms = $Parms.Split(" ")
   & "$filepath" $Prms | Out-Null
   Write-Host "SSMS installation complete" -ForegroundColor Green
  displayName: 'Download and Install SSMS'

- powershell: |
   # get list of oledb providers to see if ssms is installed
   foreach ($provider in [System.Data.OleDb.OleDbEnumerator]::GetRootEnumerator())
   {
       $v = New-Object PSObject        
       for ($i = 0; $i -lt $provider.FieldCount; $i++) 
       {
           Add-Member -in $v NoteProperty $provider.GetName($i) $provider.GetValue($i)
       }
       $v
   }
  displayName: 'Get OLEDB Providers Again'

- task: VisualStudioTestPlatformInstaller@1
  displayName: 'Visual Studio Test Platform Installer'
  inputs:
    versionSelector: latestStable

- task: SmartBearSoftware.install-testcomplete-adapter-task.install-testcomplete-adapter-task.InstallTestCompleteAdapter@1
  displayName: 'TestComplete test adapter installer'
  inputs:
    preferredExecutor: TC
    installExecutor: true
    updateExecutor: false
    accessKey: '<access key from SmartBear>'
    logsLevel: 0

- task: ms-autotest.screen-resolution-utility-task.screen-resolution-utlity-task.ScreenResolutionUtility@1
  displayName: 'Set Screen Resolution'
  inputs:
    displaySettings: specific
    width: 1920
    height: 1080

- task: VSTest@2
  displayName: 'VsTest - testAssemblies'
  inputs:
    testAssemblyVer2: '**\*.pjs'
    uiTests: true
    vsTestVersion: toolsInstaller
    failOnMinTestsNotRun: true

- task: AzureCLI@2
  displayName: 'Remove IP'
  inputs:
    azureSubscription: 'Unified Architecture (<access key>)'
    scriptType: bash
    scriptLocation: inlineScript
    inlineScript: 'az sql server firewall-rule delete -g rg-shared-api-qa -s sql-Standard-apis-shared-qa -n azure-pipeline'
  condition: always()

- task: PublishPipelineArtifact@1
  displayName: 'Publish TestComplete Log Artifact'
  inputs:
    targetPath: '$(System.DefaultWorkingDirectory)\Standard\Log'
```

