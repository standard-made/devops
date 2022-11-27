//USEUNIT Main

/***************************************************************
Name: Events
Description: General event controls
Author: Keith Hudson
Creation Date: 08/20/2022
***************************************************************/

// On Stop Test
function onStopMHT_OnStopTest(Sender)
{
  //Log.SaveResultsAs(Project.Path + "LogMHT\\" + aqTestCase.CurrentTestCase.Name + ".mht", lsMHT);
  verifyFiles_MHT();  
}

// Verify MHT Files
function verifyFiles_MHT()
{
  var foundFiles, aFile;
  foundFiles = aqFileSystem.FindFiles(Project.Path + "LogMHT\\", "*.mht");
  if (foundFiles != null) {
    while (foundFiles.HasNext())
    {
      aFile = foundFiles.Next();
      deleteFiles_MHT(aFile);
    }
  }
  else {
    Log.Message("No files were found.");
  }
}

// Delete MHT Files Older Than 3 Days
function deleteFiles_MHT(aFile){
  var DateTime = aqDateTime.Now();
  var DateTimeMinusXDays = aqDateTime.AddDays(DateTime, -3);
  Log.Message("NOW: " + DateTime + " | THEN: " + DateTimeMinusXDays);
  
  if (aFile.DateLastModified < DateTimeMinusXDays) {
    FilePathString = aqConvert.VarToStr(aFile.Path)
    aqFileSystem.DeleteFile(FilePathString);
    Log.Message(FilePathString + " deleted" );
  }
  else {
    Log.Message("No files were deleted");
  }
}

// Send Alert Email
function SendEmail(mFrom, mTo, mSubject, mBody, mAttach)
{
  var schema, mConfig, mMessage;

  try {
    schema = "http://schemas.microsoft.com/cdo/configuration/";
    mConfig = getActiveXObject("CDO.Configuration");
    mConfig.Fields.$set("Item", schema + "sendusing", 2); // cdoSendUsingPort
    mConfig.Fields.$set("Item", schema + "smtpusessl", 1); // Use SSL 

    // sgb relay server
    mConfig.Fields.$set("Item", schema + "smtpserver", "mxa-006af402.gslb.pphosted.com"); // default SMTP server
    mConfig.Fields.$set("Item", schema + "smtpserverport", 25);
    mConfig.Fields.$set("Item", schema + "smtpauthenticate", 1); // Authentication mechanism

    // credentials
    mConfig.Fields.$set("Item", schema + "sendusername", "noreply@made.llc");
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
  catch (exception) {
    Log.Error("Email cannot be sent", exception.message);
    return false;
  }
  
  Log.Message("Message to <" + mTo + "> was successfully sent");
  return true;
}

// On Error
function EventControls_OnLogError(Sender, LogParams)
{                   
  Project.Variables.ErrorCounter++;
  var page = Sys.Browser("*").Page("*"); 
  switch(ProjectSuite.Variables.Environment) {
    case "QA":
      var alertRecipient = "kit@made.llc";
      break;
    case "STG":
      var alertRecipient = "testingalerts@made.llc";
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
    if (CommonMAIN.SendEmail("noreply@made.llc", alertRecipient, "PartnerPortal Automation Failure",
             "FX Failure in " + ProjectSuite.Variables.Environment + " - " + aqTestCase.CurrentTestCase.Name
             + " ERROR: " + LogParams.MessageText, Log.Picture(Sys.Desktop.Picture(), "Image of the error"))) {
      Log.Checkpoint("| Alert Email Sent |");
      page.Refresh();             
    }
    else {
      Log.Warning("WARNING: alert email unsuccessful");
    }
  }
  
  // stop project if error count exceeds 5
  var LogsCol = Project.Logs;
  var LogItem = LogsCol.LogItem(0);
  var Test = LogItem.Name;
  var Start = "Set" + ProjectSuite.Variables.Environment + "Environment";
  Log.Message("NAME: " + Test);  
  if (Project.Variables.ErrorCounter > 5) {
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
  if (locked != -1) {
    // If found, block the message
    LogParams.Locked = true;
  }
  else {
    // Else, post the message
    LogParams.Locked = false;
  }  
}

