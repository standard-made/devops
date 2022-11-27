/***************************************************************
Name: Common
Description: General common functions
Author: Keith Hudson
Creation Date: 08/24/2021
***************************************************************/

function killBrowser() {
  while (Aliases.Browser.Exists) {
    Aliases.Browser.Terminate()
  }
  Log.Checkpoint("| Browser Closed |");    
}

function incognitoBrowser() {
  // launch mock service .bat
  var batch = Sys.OleObject("WScript.Shell");  
  var runMockService = batch.Run(Project.Path + "\\Stores\\Files\\Run_ChromeIncognito.bat");
  if(Sys.Process("cmd", 2).Window("ConsoleWindowClass", "Administrator:  CHROME INCOGNITO", 1).Exists)
  { 
    Log.Checkpoint("| Chrome Incognito Launched |");
    Sys.Process("cmd", 2).Close();
  }
}

function launchChromeBrowser(envtURL) {
  // launch browser and maximize window
  Main.refreshChromeBroswer();
  Sys.Refresh(); 
  if (equal(Sys.WaitBrowser("chrome").Exists, false)) {
    // environment handler
    switch (ProjectSuite.Variables.Environment) {
      case "QA":
        switch (Project.Variables.Site) {
          case "Back Office":
            envtURL = ProjectSuite.Variables.urlBackOfficeQA;
            break;
          case "Portal":
            envtURL = ProjectSuite.Variables.urlPortalQA;
            break;
        }
        break;    
      case "STG":
        switch (ProjectSuite.Variables.Site) {
          case "Back Office":
            envtURL = ProjectSuite.Variables.urlBackOfficeSTG;
            break;
          case "Portal":
            envtURL = ProjectSuite.Variables.urlPortalSTG;
            break;
        }
        break;
      }
    Browsers.Item(btChrome).Run(envtURL, 2500);
    Aliases.Browser.BrowserWindow(0).Maximize();
  }
}

function refreshChromeBroswer() {
  // specify powershell file
  var psFile = Project.Path + "\\Stores\\Files\\killBrowsers.ps1";

  // run batch script and refresh
  WshShell.Run("powershell -file " + psFile);
  wait(2);
  Sys.Refresh();
}

function clearChromeCookies() {
  // specify powershell file
  var psFile = Project.Path + "\\Stores\\Files\\clearInternetData.ps1";
  
  // Run powershell script and refresh
  WshShell.Run("powershell -file " + psFile);
  Sys.Refresh();
}

function runPoswerShellScript(file) {
  // specify powershell file
  var psFile = Project.Path + "\\Stores\\Files\\" + file;
  
  // Run powershell script and refresh
  WshShell.Run("powershell -file " + psFile);
  Sys.Refresh();
}

function wait(timeInSeconds) {
  Delay(timeInSeconds * 1000);
}

function getRandomInteger(min, max) {
  var intMin = min;
  var intMax = max;
  if (equal(intMin, null) && equal(intMin, null)) {
    intMin = 1;
    intMax = 10;
  }
  return Math.round(Math.random()*(intMax-intMin)+intMin);
}

function getRandomFloat(max) {
  return Math.round((Math.random()*(max-0)+0) * 100) / 100;
}

function getRandomString() {
  return Math.random().toString(16).substr(2, 8);
}

function sgbLogin(envt, site, user, pass) {
  // navigate to specified environment
  Main.launchChromeBrowser(site);
  
  // set page variables
  var page = Aliases.Browser.sgbID; 
  page.WaitElement("#okta-signin-submit");
  Aliases.Browser.sgbID.Auth.Email.SetText(user);
  Aliases.Browser.sgbID.Auth.Password.SetText(pass);
  Aliases.Browser.sgbID.Auth.Login.ClickButton();
  
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // environment handler
  switch (envt) {
    case "QA":
      switch (site) {
        case "Back Office":
          Aliases.Browser.sgbBO_Main.WaitAliasChild("Nav"); //.WaitElement("//tbody/tr[1]"); // wait for profile load
          break;
        case "Portal":
          page = Sys.Browser("*").Page(ProjectSuite.Variables.urlPortalQA + "accounts/wallet");
          page.WaitElement("//div[@class='row normal-row']/div[1]"); // wait for account load
          break;
      }
      break;    
    case "STG":
      switch (site) {
        case "Back Office":
          page = Sys.Browser("*").Page(ProjectSuite.Variables.urlBackOfficeSTG + "profiles");
          page.WaitElement("//tbody/tr[1]"); // wait for profile load
          break;
        case "Portal":
          page = Sys.Browser("*").Page(ProjectSuite.Variables.urlPortalSTG + "accounts/wallet");
          page.WaitElement("//div[@class='row normal-row']/div[1]"); // wait for account load
          break;
      }
      break;
  }
  stopWatch.Stop();
  Log.Checkpoint("| LOGIN SPEED | - " + stopWatch.ToString());
}

function sgbLogout() {
  // find logout
  var page = Sys.Browser("*").Page("*");
  var profile = page.FindElement("//a[@id='user-navbar-dropdown']");
  var logout = page.FindElement("//a[@name='navbar-logout']");
  
  // logout 
  profile.Click();
  logout.Click();
  
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // wait (if needed)
  var loopTimeout = 0;
  while ((!equal(page.URL, ProjectSuite.Variables.urlIdentity)) || (loopTimeout < 15)) {
    loopTimeout++
    Log.Message("LOG: current url = " + page.URL + " | expected url = " + ProjectSuite.Variables.urlIdentity); 
    Main.wait(1);
    Main.sgbGetCurrentURL();
    if (equal(page.URL, ProjectSuite.Variables.urlIdentity)) {
      Log.Checkpoint("| MATCH | " + page.URL + " = " + ProjectSuite.Variables.urlIdentity);
      break;
    }
  }
  
  // map login objects
  page = Sys.Browser("*").Page("*"); 
  var loginPage = page.FindElement("//div[@class='auth-content']");  
  var loginEmail = page.FindElement("//input[@id='okta-signin-username']");
  var loginPass = page.FindElement("//input[@id='okta-signin-password']");
  
  // verify return to login
  if (equal(loginPage.Exists, true)) {
    Log.Checkpoint("| Successful Logout |");
    // clear cached info
    if (!equal(loginEmail.Text, "")) {
      loginEmail.SetText("");
      loginPass.SetText("");  
    }
  }  
  else {
    Log.Warning("WARNING: login page not found");
  }
  stopWatch.Stop();
  Log.Checkpoint("| LOGOUT SPEED | - " + stopWatch.ToString());
}

function sgbCloseAction() {
  // set page variables
  var page = Sys.Browser("*").Page("*");
  var closeBtn = page.WaitElement("//i[contains(text(),'close')]");
  
  // perform close action
  closeBtn.Click();
}

function sgbSearchPage(searchFor) {
  // set page variables
  var page = Sys.Browser("*").Page("*");
  var search = page.FindElement("//div[contains(@class, 'search-box')]");  
  var searchBy = search.FindChildByXPath("//input");
  
  // perform search action
  searchBy.SetText(searchFor);
  
  // select result
  page.FindElement("//tbody//tr[1]").WaitProperty("VisibleOnScreen", true);
  var searchResult = page.FindElement("//th[contains(text(), '" + searchFor + "')]");
  searchResult.Click();
  Log.Checkpoint("| Search Found | - " + searchFor);
}

function sgbGetCurrentURL() {
  // capture current url and set global variable
  var page = Sys.Browser("*").Page("*");
  var backofficeURL = "backoffice";
  var portalURL = "portal";
  var identityURL = "identity";
  var backofficeSite = aqString.Find(page.URL, backofficeURL);
  var portalSite = aqString.Find(page.URL, portalURL);
  var identitySite = aqString.Find(page.URL, identityURL);
  if (!equal(backofficeSite, -1)) {
    Project.Variables.sgbCurrentSite = backofficeURL;
  }
  if (!equal(portalSite, -1)) {
    Project.Variables.sgbCurrentSite = portalURL;
  }
  if (!equal(identitySite, -1)) {
    Project.Variables.sgbCurrentSite = identityURL;
  }
  // Project.Variables.sgbCurrentURL = page.URL;
  Log.Message("LOG: current " + Project.Variables.sgbCurrentSite + " url = " + Project.Variables.sgbCurrentURL);
}

function sgbGetCurrentUser() { 
  // refresh page
  var page = Sys.Browser("*").Page("*");  
  Aliases.Browser.sgbP_Main.Menu
  page.FindElement("#user-navbar-dropdown").WaitProperty("VisibleOnScreen", true);

  // get current user
  var currentUser = page.FindElement("//div[@class='my-auto']/div[1]").contentText;
  Project.Variables.ProfileUserFirst = aqString.Trim(aqString.Remove(currentUser, 14, 7), aqString.stAll);
  Project.Variables.ProfileUserLast = aqString.Trim(aqString.Remove(currentUser, 0, 14), aqString.stAll);
  Project.Variables.sgbCurrentUser = ProjectSuite.Variables.ProfileUserFirst + " " + ProjectSuite.Variables.ProfileUserLast;
  Log.Checkpoint("| Current Active User = " + ProjectSuite.Variables.ProfileUserFirst + " " + ProjectSuite.Variables.ProfileUserLast + " |");
  
  // update active user type 
  switch (ProjectSuite.Variables.ProfileUserLast) {
    case "User 1":
      ProjectSuite.Variables.ActiveUserType = "Super Admin";
      break;   
    case "User 2":
      ProjectSuite.Variables.ActiveUserType = "Back Office Admin";
      break;
    case "User 3":
      ProjectSuite.Variables.ActiveUserType = "Front Office";
      break;    
    case "User 4":
      ProjectSuite.Variables.ActiveUserType = "Trader";
      break;  
  }
}

function utcDate() {
  var date = aqDateTime.Today();
  var time = aqDateTime.Time();  
  var gmtTime = aqString.Replace(aqConvert.DateTimeToFormatStr(date, "%Y/%m/%d"), "/", "-") 
    + " " + aqConvert.DateTimeToFormatStr(time, "%H:%M:%S");
  
  Log.Checkpoint("| GMT/UTC DateTime | - " + gmtTime);  
  return gmtTime;
}

function getCurrentDate() {
  var currentDate = aqDateTime.Today(); 
  var today = aqConvert.DateTimeToFormatStr(currentDate, "%m/%d/%y");
  ProjectSuite.Variables.Date1 = today;
  return today;
}

function getPastDate(days) {
  var currentDate = aqDateTime.Today(); 
  var today = aqConvert.DateTimeToStr(aqDateTime.AddHours(currentDate, -3)); // PST
  var pastDate = aqDateTime.AddDays(currentDate, days); // how many days in the past
  var pastDateX = aqConvert.DateTimeToFormatStr(pastDate,"%m/%d/%y");
  ProjectSuite.Variables.Date2 = pastDateX;
  return pastDateX;  
}

function sgbRefresh() {
  // refresh to home page (if needed)
  var envt = aqString.ToLower(ProjectSuite.Variables.Environment);
  Main.sgbGetCurrentURL();
  if (equal(Project.Variables.sgbCurrentSite, "portal") && !equal(Project.Variables.sgbCurrentURL, "https://portal-" + envt + ".silvergate.com/accounts/wallet")) {
    PortalMAIN.navigatePortal("Home");
  }
  if (equal(Project.Variables.sgbCurrentSite, "backoffice") && !equal(Project.Variables.sgbCurrentURL, "https://backoffice-" + envt + ".silvergate.com/profiles")) {
    BackOfficeMAIN.navigateBackOffice("profiles");
  }
  if (equal(Project.Variables.sgbCurrentSite, "identity") && equal(Project.Variables.sgbCurrentURL, "https://identity-dev.silvergate.com/")) {
    PortalMAIN.loginPortalTrader();
  }
  
  // clean-up/re-stage test data
  BackOfficeSQL.sqlClearTestApprovals();
  BackOfficeSQL.sqlSetDefaultProfileLimits();
  BackOfficeSQL.sqlEnableAutoQuoting();
  BackOfficeSQL.sqlEnableTradeExecution(); 
  PortalSQL.getProfileInfo(); 
  BackOfficeSQL.sqlEnableConnectionPermissions();
}

function sgbDataRefresh() { 
  BackOfficeSQL.sqlClearTestApprovals();
  BackOfficeSQL.sqlSetDefaultProfileLimits();
  BackOfficeSQL.sqlEnableAutoQuoting();
  BackOfficeSQL.sqlEnableTradeExecution(); 
  BackOfficeSQL.sqlEnableConnectionPermissions();
}

function sgbTestAccount() {
  PortalSQL.getServiceInfo();
  PortalSQL.getProfileServiceInfo();
  PortalSQL.getRandomProfileAccount();
  PortalSQL.getProfileUserInfo();
  PortalSQL.getProfileAccountUserEntitlements();
}

function fgppLogin() {
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // login
  var fgpp = Aliases.Browser.pageFinastra;
  if (equal(fgpp.login_Form.VisibleOnScreen, true)) {
    fgpp.login_Form.UserId.SetText(Project.Variables.fgppUsername); 
    fgpp.login_Form.Password.SetText(Project.Variables.fgppPassword.DecryptedValue);
    fgpp.login_Form.SigninBtn.Click();
    Log.Message("LOG: user = " + Project.Variables.fgppUsername + " | envt = " + Project.Variables.fgppEnvironment); 
  }

  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| LOGIN SPEED | - " + stopWatch.ToString());
}

function fgppLogout() { 
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // logout
  var fgpp = Aliases.Browser.pageFinastra; 
  fgpp.Nav.Click();
  fgpp.Nav.Dropdown.Logout.Click();
  
  // verify
  aqObject.CheckProperty()  
  
  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| LOGOUT SPEED | - " + stopWatch.ToString());
}

function setEnvironment(envt) {
  ProjectSuite.Variables.ServiceType = null;
  Project.Variables.sgbEnvironment = envt;
  ProjectSuite.Variables.dboDatabaseServer = aqString.ToLower("sql-silvergate-apis-shared-" + envt);
  ProjectSuite.Variables.ProfileName = "TestComplete Automation";
  CommonMAIN.refreshChromeBroswer(); 
  Log.Checkpoint("| Test Environmnet Set | - " + ProjectSuite.Variables.Environment);
  CommonMAIN.launchChromeBrowser(ProjectSuite.Variables.Site);
  Log.Checkpoint("| Browser Launched | - " + ProjectSuite.Variables.Site);
  PortalMAIN.loginPortalTrader();
}

function cleanEnvironment() {
  sgbDataRefresh();
  sgbLogout();
  Aliases.Browser.Close();
  Log.Checkpoint("| Test Automation Complete | - Enjoy Some TACOS!!!");   
}