//USEUNIT Data
//USEUNIT Main

/* **** | Auth | **** */
Given("The test data has been refreshed and Browser is open", function (){
  BackOfficeSQL.sqlClearTestApprovals();
  BackOfficeSQL.sqlSetDefaultProfileLimits();
  BackOfficeSQL.sqlEnableAutoQuoting();
  BackOfficeSQL.sqlEnableTradeExecution();  
  BackOfficeSQL.sqlEnableConnectionPermissions();
});

Given("A {arg} user navigates to the {arg} homepage in the {arg} environment", function (param1, param2, param3){
  // set global variables
  Project.Variables.varUserRole = param1;
  Project.Variables.varSite = param2
  Project.Variables.sgbEnvironment = param3;
  Project.Variables.dboServerURL = Project.Variables.dboServer + Project.Variables.sgbEnvironment;
  Log.Checkpoint("| Test Environmnet Set | - " + Project.Variables.sgbEnvironment);
  
  // launch browser to site 
  CommonMAIN.launchChromeBrowser(Project.Variables.varSite);
  Log.Checkpoint("| Browser Launched | - " + Project.Variables.varSite);
});

Given("The user has been redirected to {arg} page for authentication", function (param1){
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.WaitProperty("VisibleOnScreen", true);
  ProjectSuite.Variables.urlIdentity = Aliases.Browser.pageSilvergateIdentityDev.URL;
  Log.Checkpoint("| Redirected to Identity Login | - " + Aliases.Browser.pageSilvergateIdentityDev.URL);
});

When("The user enters their email and password into the login form", function (){
  // email, pass handler
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
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxEmail.SetText("");
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxPass.SetText("");
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxEmail.SetText(emailVar);
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxPass.SetText(passVar);
  if (equal(Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxPass.contentText, "")) {
    Aliases.Browser.pageSilvergateIdentityDev.loginForm.textboxPass.SetText(passVar);  
  }
  Log.Checkpoint("| Login Information Entered | - email:" + emailVar + " & pass:" + passVar);
});

When("The login button has been clicked", function (){
  Aliases.Browser.pageSilvergateIdentityDev.loginForm.btnLogin.Click(); 
});

Then("The user should be authenticated and redirected to {arg}", function (param1){
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // wait for Partner Portal page load
  var page;
  switch (ProjectSuite.Variables.Site) {
    case "Portal":
      Aliases.Browser.pageSilvergatePortal.panelAccounts.Wallets.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageSilvergatePortal.URL;
      break;
    case "Back Office":
      Aliases.Browser.pageSilvergateBackOffice.panelProfiles.Search.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageSilvergateBackOffice.URL;
      break;
  }
  
  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| Page Load Speed | page - " + page + " & speed " + stopWatch.ToString());
});

Given("The user has an active session in Partner Portal", function (){
  CommonMAIN.sgbGetCurrentUser();
});

When("The user navbar menu is verified", function (){
  var page;
  switch (ProjectSuite.Variables.Site) {
    case "Portal":
      Aliases.Browser.pageSilvergatePortal.panelAccounts.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageSilvergatePortal;
      page.navLogout.infoUser.WaitProperty("Visible", true);
      break;
    case "Back Office":
      Aliases.Browser.pageSilvergateBackOffice.panelProfiles.WaitProperty("VisibleOnScreen", true);
      page = Aliases.Browser.pageSilvergateBackOffice;
      page.navLogout.infoUserRole.WaitProperty("Visible", true);
      break;
  }
});

Then("The user can logout", function (){ 
  CommonMAIN.sgbLogout();
});

/* **** | Demo | **** */
Given("The test data has been refreshed and Browser is open", function (){
  CommonMAIN.refreshChromeBroswer(); 
  Log.Checkpoint("| Test Environmnet Set | - " + Project.Variables.gppEnvironment);
  
});

Given("A user has navigated to the Finastra Login page", function (){
  CommonMAIN.launchChromeBrowser(Project.Variables.gppURL);
  Log.Checkpoint("| Webpage Launched | - " + Project.Variables.gppURL);
});

When("The user logs in", function (){
  CommonMAIN.gppLogin();
});

Then("The user is redirected to the Finastra Message Center page", function (){
  aqObject.CheckProperty(Aliases.Browser.gppFinastra_Main.Nav, "VisibleOnScreen", cmpEqual, true);
});

Given("The user is logged into Finastra ", function() {
  aqObject.CheckProperty(Aliases.Browser.gppFinastra_Main.Nav, "contentTest", cmpContains, Project.Variables.gppUsername);  
});

When("The user logs out", function (){ 
  CommonMAIN.gppLogout();  
});

/* **** | Payments| **** */
Given("The {arg} is logged into Portal", function (param1, param2){ 
  ProjectSuite.Variables.ActiveUserType = param1;
  switch (param1) {
    case "Trader":
        PortalMAIN.loginPortalTrader();
      break;
    case "Super Admin":
        PortalMAIN.loginPortalAdmin();
      break;
    case "Front Office":
        PortalMAIN.loginPortalFO();
      break;
    case "Back Office Admin":
        PortalMAIN.loginPortalBOA();
      break;
  }
});

Given("The user requires {arg} approval for {arg} and {arg}", function (param1, param2, param3){
  ProjectSuite.Variables.ServiceType = param2; // service
  ProjectSuite.Variables.TransactionType = param3; // subservice
  PortalSQL.sqlSetUserApprovalPermissions(param1); // permission
});

When("The user submits a valid {arg} transaction", function (param1){
  switch (param1) {
    case "Payment":
      PortalPAY.payRequestTransfer(1);
      break;
    case "FX Trade Execution":
      PortalFX.fxRequestQuote(1);
      PortalFX.fxQuoteHandler("Accept", 1);
      PortalFX.fxTradeConfirmation();
      PortalFX.fxTradeExecutionDB(); 
      break;
    case "SEN Transfer":
      PortalSEN.senRequestTransfer(1);
      break;
    case "Internal Transfer":
      PortalINT.intRequestTransfer(1); 
      break;
  }
});

Then("The user should receive a {arg}", function (param1){
  PortalMAIN.mainMessageHandler(param1);
});

Then("The payment can be verified", function (){
  Project.Variables.fxPaymentID = PortalSQL.sqlGetRandomPaymentId();
  PortalFX.fxReportHistorySearch("Find", Project.Variables.fxPaymentID);
});