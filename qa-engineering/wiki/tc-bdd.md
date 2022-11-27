**<h1> STANDARD: Automation w/Behavior-Driven Development (BDD) </h1>**
![standard-automation.png](/src/standard-automation.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
Behavior-driven development (BDD) is a software development methodology that combines technical aspects and business interests. It implies that the team decides what to test and to what extent, and creates test scenarios in a simple language that is understandable by even non-technical-savvy employees.

In TestComplete, you can create such BDD tests against desktop, web and mobile applications, you can also automate their test steps and run these tests daily. 

## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **BDD REFERENCES** </u></span>
- [Azure - BDD Test Case Template](https://cucumber.io/docs/gherkin/reference/)
- [Cucumber - Gherkin Reference](https://cucumber.io/docs/gherkin/reference/)
- [TestComplete - BDD Reference](https://support.smartbear.com/testcomplete/docs/bdd/index.html)



## <span style="color:#555555"><u> **BDD TAGGING** </u></span>
BDD Project Backlog Items and Test Cases will use the same tagging features in Azure as described in the [STANDARD: Automation Wiki](../README.md) in addition to the main tag referenced below:
- <span style="color:hotpink"> [@]_BDD</span> 



## <span style="color:#555555"><u> **SCENARIO EXAMPLE** </u></span>
This is a concrete example that illustrates a business rule. It consists of a list of steps. You can have as many steps as you like, but we recommend 3-5 steps per example. Having too many steps will cause the example to lose its expressive power as a specification and documentation. Each step starts with _Given, When, Then, And,_ or _But_. Each step in a scenario is executed one at a time, in the sequence you’ve written them in.

```
@Auth
Feature: partnerPortalAuth

  Background: Setup 
    Given The test data has been refreshed and Browser is open

  @loginPortalTraderQA
  Scenario: Verify Portal Trader Login
    Given A "Trader" user navigates to the "Portal" homepage in the "QA" environment   
    And The user has been redirected to "https://identity.made.llc/" page for authentication
    When The user enters their email and password into the login form
    And The login button has been clicked
    Then The user should be authenticated and redirected to "https://portal.made.llc/accounts/wallet"

  @logoutPartnerPortal  
  Scenario Outline: Verify the Partner Portal login for every role (data-driven test)
    Given A <role> user navigates to the <site> homepage in the <envt> environment   
    And The user has been redirected to <redirect> page for authentication
    When The user enters their email and password into the login form
    And The login button has been clicked
    Then The user should be authenticated and redirected to <homepage>
    And The navbar dropdown menu is verified before logout
  
  # portalQA
  @ex-SuperAdmin-pQA
  Examples:
    | envt | role            | site      | redirect                               | homepage                                           |
    | "QA" | "Super Admin"   | "Portal"  | "https://identity.made.llc/" | "https://portal.made.llc/accounts/wallet1" |
    
  @ex-BackOfficeAdmin-pQA
  Examples:
    | envt | role                | site     | redirect                               | homepage                                           |
    | "QA" | "Back Office Admin" | "Portal" | "https://identity.made.llc/" | "https://portal.made.llc/accounts/wallet2" |
    
  @ex-FrontOffice-pQA
  Examples:
    | envt | role           | site          | redirect                               | homepage                                           |
    | "QA" | "Front Office" | "Back Office" | "https://identity.made.llc/" | "https://backoffice.made.llc/profile/user" |
    
  @ex-TraderAdmin-pQA
  Examples:
    | envt | role            | site           | redirect                               | homepage                                           |
    | "QA" | "Front Office"  | "Back Office"  | "https://identity.made.llc/" | "https://backoffice.made.llc/profile/user" |
```
**NOTE:** _tags can be assigned to Features and Scenarios to organize and run them by some criteria, as shown above. These are **NOT** related to the tags used within Azure's query based test suites._



## <span style="color:#555555"><u> **STEP DEFINITIONS EXAMPLE** </u></span>
This is a JavaScript method with an expression that links it to one or more Gherkin steps. When executing a Gherkin step within a scenario (like the example above), the test runner will look for a matching step definition to execute.
``` js
//USEUNIT BackOfficeSQL
//USEUNIT CommonMAIN

Given("The test data has been refreshed and Browser is open", function (){
  // close browsers and cleare cache
  CommonMAIN.refreshChromeBroswer();
  
  // refresh test data
  BackOfficeSQL.sqlClearTestApprovals();
  BackOfficeSQL.sqlSetDefaultProfileLimits();
  BackOfficeSQL.sqlEnableAutoQuoting();
  BackOfficeSQL.sqlEnableTradeExecution();  
  BackOfficeSQL.sqlEnableConnectionPermissions();
});

Given("A {arg} user navigates to the {arg} homepage in the {arg} environment", function (param1, param2, param3){
  // set global variables
  ProjectSuite.Variables.ActiveUserType = param1;
  ProjectSuite.Variables.Site = param2
  ProjectSuite.Variables.Environment = param3;
  ProjectSuite.Variables.dboDatabaseServer = aqString.ToLower("sql-standard-apis-shared-" + ProjectSuite.Variables.Environment);
  ProjectSuite.Variables.ProfileName = "STANDARD: Automation";
  Log.Checkpoint("| Test Environmnet Set | - " + ProjectSuite.Variables.Environment);
  
  // relaunch browser to 
  CommonMAIN.launchChromeBrowser(ProjectSuite.Variables.Site);
  Log.Checkpoint("| Browser Launched | - " + ProjectSuite.Variables.Site);
});

Given("The user has been redirected to {arg} page for authentication", function (param1){
  Aliases.Browser.pageStandardIdentityDev.loginForm.WaitProperty("VisibleOnScreen", true);
  Log.Checkpoint("| Redirected to Identity Login | - " + Aliases.Browser.pageStandardIdentityDev.URL);
});

When("The user enters their email and password into the login form", function (){
  // email
  var emailVar, passVar;
  switch (ProjectSuite.Variables.ActiveUserType) {
    case "Super Admin":
      emailVar = ProjectSuite.Variables.AdminUser;
      passVar = ProjectSuite.Variables.AdminPass;
      break;
    case "Back Office Admin":
      emailVar = ProjectSuite.Variables.BackOfficeUser;
      passVar = ProjectSuite.Variables.BackOfficePass;
      break;
    case "Front Office":
      emailVar = ProjectSuite.Variables.FrontOfficeUser;
      pass = ProjectSuite.Variables.FrontOfficePass;
      break;
    case "Trader":
      emailVar = ProjectSuite.Variables.TraderUser;
      passVar = ProjectSuite.Variables.TraderPass;
      break;    
  }
  Aliases.Browser.pageStandardIdentityDev.loginForm.textboxEmail.SetText(emailVar);
  Aliases.Browser.pageStandardIdentityDev.loginForm.textboxPass.SetText(passVar); 
  Log.Checkpoint("| Login Information Entered | - email:" + emailVar + " & pass:" + passVar.DecryptedValue);
});

When("The login button has been clicked", function (){
  Aliases.Browser.pageStandardIdentityDev.loginForm.btnLogin.Click(); 
  Log.Checkpoint("| Login Clicked |");
});

Then("The user should be authenticated and redirected to {arg}", function (param1){
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // wait for Partner Portal page load
  var page;
  switch (ProjectSuite.Variables.Site) {
    case "Portal":
      Aliases.Browser.pageStandardPortal.panelAccounts.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageStandardPortal.URL;
      break;
    case "Back Office":
      Aliases.Browser.pageStandardBackOffice.panelProfiles.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageStandardBackOffice.URL;
      break;
  }
  
  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| Page Load Speed | page - " + page + " & speed " + stopWatch.ToString());
});

Then("The navbar dropdown menu is verifiyed before logout", function (){
  var page;
  switch (ProjectSuite.Variables.Site) {
    case "Portal":
      Aliases.Browser.pageStandardPortal.panelAccounts.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageStandardPortal;
      page.navLogout.infoUser.WaitProperty("Visible", true);
      break;
    case "Back Office":
      Aliases.Browser.pageStandardBackOffice.panelProfiles.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageStandardBackOffice;
      page.navLogout.infoUserRole.WaitProperty("Visible", true);
      break;
  } 
  CommonMAIN.sgbLogout();
});
```