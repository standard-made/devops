  //USEUNIT FinastraMAIN

/***************************************************************
Name: Common
Description: General common functions
Author: kITt
Creation Date: 08/24/2021
***************************************************************/

function setEnvironment(envt) {
  ProjectSuite.Variables.ServiceType = null;
  ProjectSuite.Variables.Environment = envt;
  ProjectSuite.Variables.dboDatabaseServer = aqString.ToLower("sql-silvergate-apis-shared-" + envt);
  ProjectSuite.Variables.ProfileName = "TestComplete Automation";
  CommonMAIN.refreshChromeBroswer(); 
  Log.Checkpoint("| Test Environmnet Set | - " + ProjectSuite.Variables.Environment);
  CommonMAIN.launchChromeBrowser(ProjectSuite.Variables.Site);
  Log.Checkpoint("| Browser Launched | - " + ProjectSuite.Variables.Site);
  PortalMAIN.loginFinastra();
}

function cleanUpEnvironment() {
  CommonMAIN.sgbDataRefresh();
  CommonMAIN.sgbLogout();
  Sys.Browser("*").Close();
  Log.Checkpoint("| Test Automation Complete | - Enjoy Some TACOS!!!");   
}

function killChromeBrowser() {
  while (Sys.WaitBrowser("chrome").Exists) {
    Sys.Browser("chrome").Terminate()
  }
  Log.Checkpoint("| Browser Closed |");    
}

function chromeIncognitoBrowser() {
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
  Sys.Refresh(); 
  if (equal(Sys.WaitBrowser("chrome").Exists, false)) {
    Browsers.Item(btChrome).Run(envtURL, 2500);
    Sys.Browser().BrowserWindow(0).Maximize();
  }
  else {
    CommonMAIN.refreshChromeBroswer();
  }
}

function refreshChromeBroswer() {
  // specify powershell file
  var psFile = Project.Path + "\\Stores\\Files\\killBrowsers.ps1";

  // run batch script and refresh
  WshShell.Run("powershell -file " + psFile);
  CommonMAIN.wait(2);
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

function gppLogin() {
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // login
  var gpp = Aliases.Browser.gppFinastra_Main;
  if (equal(gpp.Auth.VisibleOnScreen, true)) {
    gpp.Auth.User.SetText(Project.Variables.gppUsername); 
    gpp.Auth.Password.SetText(Project.Variables.gppPassword.DecryptedValue);
    gpp.Auth.Login.Click();
    Log.Message("LOG: user = " + Project.Variables.gppUsername + " | envt = " + Project.Variables.gppEnvironment); 
  }

  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| LOGIN SPEED | - " + stopWatch.ToString());
}

function gppLogout() { 
  // timer
  var stopWatch = HISUtils.StopWatch;
  stopWatch.Start();
  
  // logout
  var gpp = Aliases.Browser.gppFinastra_Main; 
  gpp.Nav.Click();
  gpp.Nav.Select.Logout.Click();
  
  // verify
  aqObject.CheckProperty(gpp.Auth, "VisibleOnScreen", cmpEqual, true);  
  
  // stop timer
  stopWatch.Stop();
  Log.Checkpoint("| LOGOUT SPEED | - " + stopWatch.ToString());
}

function gppCloseAction() {
  // set page variables
  var page = Aliases.Browser.gppFinastra_Main;
  var closeBtn = page.WaitElement("//i[contains(text(),'close')]");
  
  // perform close action
  closeBtn.Click();
}

function gppSearchMID(searchFor) {
  // search payment
  var gpp = Aliases.Browser.gppFinastra_Main;
  gpp.Search.Input.SetText(searchFor); 
  gpp.Search.Icon.Click();
  gpp.Search.Result.Click();
  
  // verify payment (iframe)
  var gppTransaction = Aliases.Browser.gppFinastra_Transaction;
  aqObject.CheckProperty(gppTransaction.ref_MID, "value", cmpEqual, Project.Variables.gppPaymentId); // M098A27047S96VZ2
  aqObject.CheckProperty(gppTransaction.ref_Acct, "value", cmpEqual, Project.Variables.gppAccount); // 013500010023398
  gppTransaction.Exit.Click();
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

// TEST RUNTIME WITH LOG EVENT REMOVED
//function onStopMHT_OnStopTest() {
//  Log.SaveResultsAs(ProjectSuite.Path + "Log\\" + aqTestCase.CurrentTestCase.Name + ".mht", lsMHT);
//}

function SendEmail(mFrom, mTo, mSubject, mBody, mAttach)
{
  var schema, mConfig, mMessage;

  try
  {
    schema = "http://schemas.microsoft.com/cdo/configuration/";
    mConfig = getActiveXObject("CDO.Configuration");
    mConfig.Fields.$set("Item", schema + "sendusing", 2); // cdoSendUsingPort
    mConfig.Fields.$set("Item", schema + "smtpusessl", 1); // Use SSL 

    // sgb relay server
    mConfig.Fields.$set("Item", schema + "smtpserver", "mxa-006af402.gslb.pphosted.com"); // default SMTP server
    mConfig.Fields.$set("Item", schema + "smtpserverport", 25);

    mConfig.Fields.$set("Item", schema + "smtpauthenticate", 1); // Authentication mechanism

    // credentials
    mConfig.Fields.$set("Item", schema + "sendusername", "noreply@silvergate.com");
    mConfig.Fields.$set("Item", schema + "sendpassword", ProjectSuite.Variables.EmailPass.DecryptedValue); 

    mConfig.Fields.Update();

    mMessage = getActiveXObject("CDO.Message");
    mMessage.Configuration = mConfig;
    mMessage.From = mFrom;
    mMessage.To = mTo;
    mMessage.Subject = mSubject;
    mMessage.HTMLBody = mBody;

    aqString.ListSeparator = ",";
    for(let i = 0; i < aqString.GetListLength(mAttach); i++)
      mMessage.AddAttachment(aqString.GetListItem(mAttach, i));
    mMessage.Send();
  }
  catch (exception)
  {
    Log.Error("Email cannot be sent", exception.message);
    return false;
  }
  Log.Message("Message to <" + mTo + "> was successfully sent");
  return true;
}

function EventControls_OnLogError(Sender, LogParams)
{                   
  // envt handler
  Project.Variables.ErrorCounter++;
  var page = Sys.Browser("*").Page("*"); 
  switch(ProjectSuite.Variables.Environment) {
    case "QA":
      var alertRecipient = "khudson@silvergate.com";
      break;
    case "STG":
      var alertRecipient = "SEtestingalerts@silvergate.com";
      break;
  }
  
  // FX failure alert
  if (equal(ProjectSuite.Variables.ServiceType, "FX Trade Execution")) {
    LogParams.Locked = false;
    LogParams.Priority = pmHighest;
    LogParams.FontStyle.Bold = true;
    LogParams.FontColor = clSilver;
    LogParams.Color = clRed;
    
    // send alert email w/screenshot   
    if (CommonMAIN.SendEmail("noreply@silvergate.com", alertRecipient, "PartnerPortal Automation Failure",
             "FX Failure in " + ProjectSuite.Variables.Environment + " - " + aqTestCase.CurrentTestCase.Name
             + " ERROR: " + LogParams.MessageText, Log.Picture(Sys.Desktop.Picture(), "Image of the error"))) {
      Log.Checkpoint("| Alert Email Sent |");
      page.Refresh();             
    }
    else {
      Log.Warning("WARNING: alert email unsuccessful");
    }
  }
  
  // stop project if unable to reach website
  var LogsCol = Project.Logs;
  var LogItem = LogsCol.LogItem(0);
  var Test = LogItem.Name;
  var Start = "Set" + ProjectSuite.Variables.Environment + "Environment";
  Log.Message("NAME: " + Test);
  if (equal(Project.Variables.ErrorCounter, 2)) {
    Log.Message("Error count: " + Project.Variables.ErrorCounter);
    if (equal(Test, Start)) {
      Log.Message("TEST: failed to launch website on retry");
      aqTestCase.CurrentTestCase.Name = "" + Project.Variables.Counter;
      Project.Variables.ErrorCounter = 0;
      Runner.Stop();
    }
  }
}


function EventControls_OnLogWarning(Sender, LogParams)
{
  // Check if the message includes the desired substring
  var locked = aqString.Find(LogParams.Str, "Improve your test performance");
  if (locked != -1)
  {
    // If found, block the message
    LogParams.Locked = true;
  }
  else
  {
    // Else, post the message
    LogParams.Locked = false;
  }  
}