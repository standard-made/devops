/*************************************************************** 
Name: DIALOG MESSAGE
Description: Create dialog
Author: 8Kit
***************************************************************/
Input Box Methods
BuiltIn.InputBox(Caption, Prompt, Default)
 
function InputBox() 
{
  var i;
  i = BuiltIn.InputBox("Regression Environment", "Which environment would you like to run regression against?", "StandardQA");
  Log.Message(i);
}

/*************************************************************** 
Name: DATETIME STRING
Description: Convert time variable to string
Author: 8Kit
***************************************************************/
function EncodeTimeTest()
{
  var time = (00,00,15);  
  var myTime, EncodedTime, VariantTime;

  // Create a Date variable having the specified hour, minute and second values
  myTime=aqDateTime.SetTimeElements(00,00,15);

  // Convert the value of the myTime variable to a string using the specified format and post this string to the log
  EncodedTime = aqConvert.DateTimeToFormatStr(myTime, "%H:%M:%S");
  Log.Message("The encoded time is "+ EncodedTime);
}

/*************************************************************** 
Name: SEND INFINITE SPAM MAIL
Description: Sends emails to a specified recipient for a 
	specified number of times
Author: 8Kit
***************************************************************/
function EmailZachSoHisFartNoiseNotificationPlays()
{
  var stopSendingZachEmails = false;
  var emailCounter = 0;
  while(!stopSendingZachEmails)
  {
    if (emailCounter < 10)
    {
      Wait.Wait(5);
      if (SendMail("kITt@made.llc", "outlook.rt.corp", "poop", "test@made.llc", "poop", "poop")) 
      { 
        Log.Message("Script completed successfully");
      } 
      else 
      { 
        Log.Warning("Mail Was Not Sent"); 
      }
      emailCounter = emailCounter + 1;
    }
    else
    {
      stopSendingZachEmails = true;
    }
  }

}

/*************************************************************** 
Name: FIND NEW FILES
Description: Counts all files in a specified folder and returns 
	the most recently modified file
Author: 8Kit
***************************************************************/
  var fileDate;
  var fileName;
  var filePath;
  var folderInfo;
  var latestFileIndex;
  var newestTime;
  var num; 
  
  // Count number of files in specified folder
  folderInfo = aqFileSystem.GetFolderInfo(filePath);
  num = folderInfo.Files.Count;
  Log.Message("The folder contains " + num + " files.");
  
  newestTime = aqDateTime.SetDateTimeElements(1000, 1, 1, 0, 0, 0);
  latestFileIndex = 0;

  // Get the most recently modified file in the specified folder
  for (var i=0; i < num; i++)
  {
    fileDate = folderInfo.Files.Item(i).DateLastModified;
    
    if(aqDateTime.Compare(newestTime, fileDate) < 0)
    {
      newestTime = fileDate;
      latestFileIndex = i;
    } 
  }
  fileName = folderInfo.Files.Item(latestFileIndex).Name;
  Log.Message("The most recently modified file " + fileName + " was created on " + newestTime); 
  
  // Verify that file was created today
  if(aqDateTime.Compare(newestTime, aqDateTime.Today()) == 1)
  {
    Log.Message("SUCCESS. File was created today."); 
  }
  else
  {
    Log.Warning("FAILURE. The file found was not recently created, this may be a result of the folder view not being refreshed."
    +" Check '" + filePath + "' for more information.");
  }

/*************************************************************** 
Name: FIND FILES IN FOLDER
Description: Creates an array of all files in the folder specified
Author: 8Kit
***************************************************************/
  var folderObject = aqFileSystem.GetFolderInfo(filePath, fileExtension);
  var folderItems = folderObject.Files     
  var fileDateModified = new Array();  
  var fileNumber = new Array();     
  var latestFileNumber;             
  var newestTime;                    

  //Builds arrays with filnames containing FileNameContains regular expression
  for (var i=0; i < folderItems.Count; i++)
  {    
    if(folderItems.Count > -1)
    {  
      fileNumber.push(i);
      fileDateModified.push(folderItems.Item(i).DateLastModified);       
    }
  }         

  //Finds the most resent modified file
  newestTime = fileDateModified[0];
  latestFileNumber = fileNumber[0];

  for (var i=0; i < fileNumber.length; i++)
  {       
    if(aqDateTime.Compare(newestTime, fileDateModified[i]) < 0)
    {
      newestTime = fileDateModified;
      latestFileNumber = fileNumber; 
    }    
  }
  return folderItems.Item(latestFileNumber).Path;
  
/*************************************************************** 
Name: STOPWATCH
Description: Uses stopwatch to time a process. If the process	
	exceeds the timelimit the test ends. It can also refresh
	the grid every _ minutes
Author: 8Kit
***************************************************************/ 
  // Time parameters
  var stopWatch = HISUtils.StopWatch;
  var limit = 7200000;// 2 hours
  
  // Start time limit loop
  stopWatch.Start();
  if (stopWatch.Split() >= limit)
  {
    Log.Warning("The process has exceeded the " + (limit/1000)/60 + " minute time limit.");
    stopWatch.Stop();
  }
  Log.Message("The process ran for a total time of " + stopWatch.ToString() + "!"); 

/*************************************************************** 
Name: REFRESH TIMER
Description: Refresh the grid every every 2.5 minutes as process 
	continues in order to update the object list or child count
	within the specified grid
Author: 8Kit
***************************************************************/  
  // Start refresh timer, refreshes grid every 2.5 minutes
  var time = 150000;// 2.5 minutes
  var refreshTimer = Utils.Timers.Add(time,"Settlement.RefreshGrid", true);
    
  var logGrid = Standard.MainForm.MdiClient.Grid_Manager.WindowDockingArea.DockableWindow2.gridqueue.Data_Area.ColScrollRegion_0_RowScrollRegion_0;
  while(logGrid.ChildCount > 1)
  { 
    if(logGrid.ChildCount <= 1)
    {
      stopWatch.Stop();
      Log.Message("Settlement ran for a total time of " + stopWatch.ToString() + "!"); 
    }
  }

/*************************************************************** 
Name: TIMEOUT LOOP
Description: Exits loop after specified timelimit.
Author: 8Kit
***************************************************************/    
  var loopTimeout = 0;
  while (Aliases.Standard.FindChild("WndCaption", "Retrieving*", 3).Exists) 
  {
    Wait.Wait(1);
    loopTimeout++;
    if (loopTimeout == 45)  // If the loop has been going for 45 seconds get out of it.
    {
      Log.Error("Process exceeded the allotted time to retrieve data.");
      break;
    }
  }

/*************************************************************** 
Name: RUN .BAT FILE
Description: Executes a batch file through the command line.
Author: 8Kit
***************************************************************/    
  // Refresh Data in FuelOpt
  var batch = Sys.OleObject("WScript.Shell");  
  var batchRun = batch.Run("C:\\UATLoaders\\Refresh-UAT.bat");
  var cmd = Sys.Process("cmd");
  while(cmd.Exists)
  {
    Delay(100);
  } 
  
/*************************************************************** 
Name: GET PAST DATE
Description: Gets today's date, calculates for a date in the past
	and converts the date into a string (MM/DD/YYYY).
Author: 8Kit
***************************************************************/    
  var currentDate = aqDateTime.Today(); 
  var today = aqConvert.DateTimeToStr(currentDate);
  var pastDate = aqDateTime.AddDays(currentDate, -1); // how many days in the past
  var pastDateString = aqConvert.DateTimeToFormatStr(pastDate,"%m/%d/%Y");
  Log.Message(pastDateString);

/*************************************************************** 
Name: KEYSTROKE
Description: Mimics keystrokes made by a user and can press and
	release multipl keys (Ctrl + Q = Query; Ctrl + S = Search).
Author: 8Kit
***************************************************************/   
  // ALPHABET LETTERS START AT 65 - 90
  Sys.Desktop.KeyDown(Win32API.VK_CONTROL);      //Press Ctrl
  Sys.Desktop.KeyDown(81);            //Press Q
  Sys.Desktop.KeyUp(81);              //Release Q
  Wait.Wait(2);
  Sys.Desktop.KeyUp(Win32API.VK_CONTROL);        //Release Ctrl
 
 /*************************************************************** 
Name: RUN SLQ JOB
Description: Executes a specifiic job on a specific server.
Author: 8Kit
***************************************************************/
function runJob()  
{  
  var AConnection, RecSet, Cmd;  
    
  //--Create a new Connection object--//  
  AConnection = ADO.CreateConnection();  
  
  //--Step 1:  Replace X's with valid entries to connect to the desired database--//  
  //--Specify the connection string--//  
    
  AConnection.Open("Driver={SQL Server};Server=XXXXX;Database=XXXXXXX;Uid=XXXXXX;Pwd=XXXXXX");            
  //--Create a new Command object--//  
  Cmd = ADO.CreateCommand();   
  //--Specify the connection--//  
  Cmd.ActiveConnection = AConnection;   
  //--Specify command type and text--//  
  Cmd.CommandType = adCmdText;      
  //--Replace X's with valid entry for Job Name--//  
  Cmd.CommandText = "exec msdb.dbo.sp_start_job @job_name = 'XXXXX'";    
  RecSet = Cmd.Execute();  
  
  
  AConnection.Close();   
}  

/*************************************************************** 
Name: DATABASE QUERY
Description: Returns the first cell in the query results.
Author: 8Kit
***************************************************************/
var database;
  var prices = null;
  var settlementQuery = "SELECT COUNT(*) FROM StandardQA.dbo.findetail fd  "
      + "WHERE fd.creationdate >= CAST(GETDATE() AS DATE)";
      
  AConnection = ADO.CreateConnection();
  AConnection.Open ("Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;" 
    + ProjectSuite.Variables.StandardQADB 
    + ProjectSuite.Variables.StandardServer);
  Cmd = ADO.CreateCommand();
  Cmd.ActiveConnection = AConnection;
  Cmd.CommandType = adCmdText;
  
  // SETTLEMENT
  Cmd.CommandText = settlementQuery;
  var compSet = Cmd.Execute();
  if(compSet.Fields(0).Value != "0")
  {
    prices = compSet.Fields(0).Value;
    Log.Message(prices + " prices made it through settlement for today.");
  }
  else
  {
    Log.Warning("Settlmement failed. No prices have been placed in actual.");
  }
  return prices;
  
/*************************************************************** 
Name: DATABASE QUERY ARRAY
Description: Returns query results in an array.
Author: 8Kit
***************************************************************/  
  var dataset = [];
  var compQuery = "SELECT DISTINCT(product) FROM physicalposition WHERE product <> 'Freight' ORDER BY product";
  
  AConnection = ADO.CreateConnection();
  AConnection.Open ("Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=StandardQA;Data Source=Standarddbqa01;");
  Cmd = ADO.CreateCommand();
  Cmd.ActiveConnection = AConnection;
  Cmd.CommandType = adCmdText;
  Cmd.CommandText = compQuery;
  var compSet = Cmd.Execute();
  for (i = 0; i <= compSet.RecordCount - 1; i++)
  {
    dataset.push(compSet.Fields(0).Value);
    compSet.MoveNext();
  }
  return dataset;
  
/*************************************************************** 
Name: ITERATE THROUGH GRID
Description: Iterates through each row in the grid and looks 
	for null values in each of the critical columns specified in 
	the regression requirements.
Author: 8Kit
***************************************************************/
  var exitAllLoops = false;
  for (transactionCounter = 0; transactionCounter <= gridCount; transactionCounter++)
  {  
    var currentGrid = Standard.MainForm.MdiClient.WinFormsObject("End of Month Tax Export").WinFormsObject("WindowDockingArea", "", 1).WinFormsObject("DockableWindow", "").WinFormsObject("All_Transactions");
    var currentRow = currentGrid.UIAObject("Data_Area").UIAObject("ColScrollRegion_0_RowScrollRegion_0");
    var currentPosition = currentRow.FindChild("AutomationId", transactionCounter);
    var productCode = currentPosition.UIAObject("ProductCode").Value; 
    var taxJurisdiction = currentPosition.UIAObject("TaxSessionJurisdiction").Value; 
    var origJurisdiction = currentPosition.UIAObject("OriginJurisdiction").Value;
    var destJurisdiction = currentPosition.UIAObject("DestinationJurisdiction").Value;
    var consignorTradeName = currentPosition.UIAObject("ConsignorTradeName").Value; 
    var sellerTradeName = currentPosition.UIAObject("SellerTradeName").Value;
    var modeCode = currentPosition.UIAObject("ModeCode").Value;
    var customFour = currentPosition.UIAObject("CUSTOM_04").Value;
    var customSix = currentPosition.UIAObject("CUSTOM_06").Value; 
    
    // LOOP    
    if ((productCode == null) || (taxJurisdiction == null) || (origJurisdiction == null) || (destJurisdiction == null) ||
      + (consignorTradeName == null) || (sellerTradeName == null) || (modeCode == null) || (customFour == null) || (customSix == null))
    {
      Log.Warning("CURRENT ROW: Product Code = " + productCode + "| Tax Jursidiction = " + taxJurisdiction + "| Origin Jursidiction = " 
      + origJurisdiction + "| Destination Jursidiction = " + destJurisdiction + "| Cosignor Trade Name = " + consignorTradeName 
      + "| Seller Trade Name = " + sellerTradeName + "| Mode Code = " + modeCode + "| CUSTOM_04 = " + customFour + "| CUSTOM_06 = " + customSix);
      exitAllLoops = true;
      break;
    }
    else
    {
      Log.Message("CURRENT ROW: Product Code = " + productCode + "| Tax Jursidiction = " + taxJurisdiction + "| Origin Jursidiction = " 
      + origJurisdiction + "| Destination Jursidiction = " + destJurisdiction + "| Cosignor Trade Name = " + consignorTradeName 
      + "| Seller Trade Name = " + sellerTradeName + "| Mode Code = " + modeCode + "| CUSTOM_04 = " + customFour + "| CUSTOM_06 = " + customSix);
    }

    // PRODUCT
    if (productCode == null) 
    //((productCode == "") || (productCode == " "))
    {
      Log.Warning("Incorrect or missing product code: " 
         + "Product Code = " + productCode);
      exitAllLoops = true;
      break;
    }
    // TAX JURISDICTIONS
    if ((taxJurisdiction == null) || (origJurisdiction == null) || (destJurisdiction == null))
    //((taxJurisdiction == "") || (taxJurisdiction == " ") || (origJurisdiction == "") || (origJurisdiction == " ") || (destJurisdiction == "") || (destJurisdiction == " "))
    {
      Log.Warning("Incorrect or missing tax jurisdiction: " 
        + "Tax Jursidiction = " + taxJurisdiction + "; Origin Jursidiction = " + origJurisdiction + "; Destination Jursidiction = " + destJurisdiction);
      exitAllLoops = true;
      break;
    }
    // TRADE NAME
    if ((consignorTradeName == null) || (sellerTradeName == null)) 
    //((consignorTradeName == "") || (consignorTradeName == " ") || (sellerTradeName == "") || (sellerTradeName == " "))
    {
      Log.Warning("Incorrect or missing trade name: "
         + "Cosignor Trade Name = " + cosignorTradeName + "; Seller Trade Name = " + sellerTradeName);
      exitAllLoops = true;
      break;
    }
    // MODE CODE
    if (modeCode == null)
    //((modeCode == "") || (modeCode == " "))
    {
      Log.Warning("Incorrect or missing mode code: " 
        + "Mode Code = " + modeCode);
      exitAllLoops = true;
      break;
    }
    // CUSTOM COLUMNS
    if ((customFour == null) || (customSix == null)) 
    //((customFour == "") || (customFour == " ") || (customSix == "") || (customSix == " "))
    {
      Log.Warning("Incorrect or missing custom column: " 
        + "CUSTOM_04 = " + customFour + "; CUSTOM_06 = " + customSix);
      exitAllLoops = true;
      break;
    }
    if (exitAllLoops == true)
    {
      break;
    }
  }
  
/*************************************************************** 
Name: ITERATE THROUGH EXPANDABLE GRID
Description: Iteraties through each child row in the grid and 
	looks for specified values.
Author: 8Kit
***************************************************************/  
//Obtain the application process and its main form
  p = Standard.MainForm.MdiClient;
  frmMain = p.WinFormsObject("Scheduling").WinFormsObject("WindowDockingArea", "", 1).WinFormsObject("DockableWindow", "", 1).WinFormsObject("schedule");

  //Obtain the grid control
  Grid = frmMain.UIAObject("Data_Area").UIAObject("ColScrollRegion_0_RowScrollRegion_0");
  Grid.Click();
  ribbonArea.DblClickItem("DATA|Sort/Filter|Expand");
  
  //Start a loop to go through the entire grid. We are looking for Sched Type = Load and Confirmed = False.
  var objAbbrev = Aliases.Standard.MainForm.MdiClient.WinFormsObject("Scheduling").WinFormsObject("WindowDockingArea", "", 1).WinFormsObject("DockableWindow", "", 1).WinFormsObject("schedule").UIAObject("Data_Area").UIAObject("ColScrollRegion_0_RowScrollRegion_0");
  var products = GetPhysicalPositionProducts();
  var exitAllLoops = false;
  for (productCounter = 0; productCounter <= products.length - 1; productCounter++)
  {
    //Replace periods, spaces, and dashes with underscores to help us find the object.
    var currentProduct = aqString.Replace(aqString.Replace(aqString.Replace(products[productCounter], " ", "_"), "-", "_"), ".", "_");
    var terminals = GetPhysicalPositionTerminals(products[productCounter]);
    
    //Start a new loop to go through all of the records under each terminal for the current product.
    if (objAbbrev.UIAObject(currentProduct).UIAObject("Conf").Value == "False")
    {
      for (terminalCounter = 0; terminalCounter <= terminals.length - 1; terminalCounter++)
      {
        var currentTerminal = aqString.Replace(aqString.Replace(terminals[terminalCounter], "/", "_"), " ", "_");
        var objTerminal = objAbbrev.UIAObject(currentProduct).UIAObject("Item").UIAObject(currentTerminal).UIAObject("Item");
        var terminalRecordCount = objTerminal.ChildCount;

        //Start another loop. This one is for each Shipment under the Terminal.
        for (shipmentCounter = 0; shipmentCounter <= terminalRecordCount - 1; shipmentCounter++)
        {
          var rowShipment = objTerminal.FindChild("AutomationId", shipmentCounter);
          var groupDescription = rowShipment.UIAObject("Group_description").Value;
          var schedType = rowShipment.UIAObject("Sched_type").Value;
          var confirmed = rowShipment.UIAObject("Conf").Value;
          var purchaseVolume = rowShipment.UIAObject("Purchase_volume").Value;
          var saleVolume = rowShipment.UIAObject("Sale_volume").Value;
          if ((schedType == "LOAD" || schedType == "DISCHARGE") && (confirmed == "False") && (purchaseVolume != 0 || saleVolume != 0))
          {
            Log.Checkpoint(currentProduct + " - " + currentTerminal + " - " + schedType + " - " + confirmed + " - " + groupDescription);
            //Enter gallons
            rowShipment.ScrollIntoView();
            rowShipment.UIAObject("Sale_volume").UIAObject("Editor_Edit_Area").Keys(10000);
            
            //Sale Volume text is red (can't automate that), Confirm the Shipment, Sale Volume text should become blue (can't automate that),
            //Then Update
            rowShipment.UIAObject("Conf").Click();
            Wait.Wait(2);
            Standard.WinFormsObject("PopUpOptions").WinFormsObject("optionGroup").WinFormsObject("radiobutton2").Click();
            Standard.WinFormsObject("PopUpOptions").WinFormsObject("okButton").Click();
            ribbonArea.ribbon.Ribbon_Tabs.DATA.Click();
            ribbonArea.ribbon.Lower_Ribbon.Database.Update.Click();
            exitAllLoops = true;
            break;
          }
        }
        if (exitAllLoops == true)
        {
          break;
        }
      }
      if (exitAllLoops == true)
      {
        break;
      }
    }
    if (exitAllLoops == true)
    {
      break;
    }
		
/*************************************************************** 
Name: DATA DRIVEN TESTING
Description: Reads Excel files from a shared location
Author: 8Kit
***************************************************************/ 	
function CloseDDTDriver()
{

  if(!(DDT.CurrentDriver == null))
  {
    DDT.CloseDriver(DDT.CurrentDriver.Name); 
  }  

}

function SetSpreadsheet(filePathName, sheetName) //filePathName always starts with \\Automation_Spreadsheets\\ and goes from there
{
  CloseDDTDriver();
  DDT.ExcelDriver(ProjectSuite.Path + filePathName,sheetName);
}

function dataExcel(sheetName)
{

  if(!(DDT.CurrentDriver==null))
  {
    DDT.CloseDriver(DDT.CurrentDriver.Name);
    //Log.Message("Closed Excel DDT driver from dataExcel event");
  } 
  
  if(aqFileSystem.Exists("C:\\Users\\"+Sys.UserName+"\\EditPlanner.xls"))
  {
    aqFileSystem.DeleteFile("C:\\Users\\"+Sys.UserName+"\\EditPlanner.xls");
    //Log.Message("file deleted before execution");
  }
  
  var path = ProjectSuite.Path+"\\Automation_Spreadsheets\\EditPlanner.xls";
  aqFile.Copy(path, "C:\\Users\\"+Sys.UserName+"\\EditPlanner.xls", false);
  var filePath =DDT.ExcelDriver("C:\\Users\\"+Sys.UserName+"\\EditPlanner.xls", sheetName);
}

function RT_ContractsAndTrades()
{
  //Start["Start"]("Standard");
  SpreadSheets.SetSpreadsheet("\\Spreadsheets\\RT_ContractsAndTrades.xls", "Contract");
  createNewContract();
  SpreadSheets.SetSpreadsheet("\\Spreadsheets\\RT_ContractsAndTrades.xls", "Trade");
  TradeExecution.createTrade();
} 



/*************************************************************** 
Name: REFRESH DATA FROM PROD VIA BCP
Description: Refreshes Data from Production Database to Staging Database
Author: 8Kit
***************************************************************/ 
function RefreshFreightInvoicesAndFuelDeliveriesToStaging()
{ 
 Log.AppendFolder("RefreshFreightInvoicesAndFuelDeliveriesToStaging");
  
  //BCP Freight Invoices and Fuel Deliveries from FUELSQLSRVCL.Staging to SQLSRVCLDEPLOY.Standard_Staging_UAT
  var batch = Sys.OleObject("WScript.Shell");

  //If the existing data refresh files do not have today's date then pull the latest data from Prod
  var exportFreightInvoicesAndFuelDeliveriesFromProd = false;
  var sampleFilePath = "D:\\Data Refresh\\Freight_Invoice_Header.csv";
  if(aqFile.Exists(sampleFilePath) == true)
  {
    var sampleDataFile = aqFileSystem.GetFileInfo(sampleFilePath);
    if(sampleDataFile.DateCreated >= aqDateTime.Today())
    {
      exportFreightInvoicesAndFuelDeliveriesFromProd = false;
    }
    else
    {
      exportFreightInvoicesAndFuelDeliveriesFromProd = true;
    }
  }
  else
  {
    exportFreightInvoicesAndFuelDeliveriesFromProd = true;
  }
  
  //Export prices from Prod to D:\Data Refresh
  if(exportFreightInvoicesAndFuelDeliveriesFromProd == true)
  {
    batch.Run(ProjectSuite.Path + "UtilityScripts\\ExportFreightInvoicesFuelDeliveries.bat");
    Log.Checkpoint("Exporting freight invoices and fuel deliveries from Production");
    Wait.Wait(15);
  }
  
  //Import prices into Standard_FuelPurchaseOpDb_UAT
  batch.Run(ProjectSuite.Path + "UtilityScripts\\ImportFreightInvoicesFuelDeliveries.bat");
  Log.Checkpoint("Importing freight invoices and fuel deliveries into Deploy");
  Wait.Wait(15);
  Log.PopLogFolder();
}



/*************************************************************** 
Name: UPDATE POINTERS IN STORED PROCEDURES
Description: Updates the server and database references to the specified test environment
Author: 8Kit
***************************************************************/ 
function UpdateDbPointersInStoreProcedure(procName, database)
{ 
  
  Log.AppendFolder("UpdateDbPointersInStoreProcedure(" + procName + ", " + database + ")");  
  var server, database, text;
  var procName; //pass procedure name
  var stagingDB = "Standard_Staging_UAT";
  var fuelDB = "Standard_FuelPurchaseOpDb_UAT";
  var dataset = [];
  var compQuery = "EXEC sp_helpText N'" + procName + "';";

  AConnection = ADO.CreateConnection();
  AConnection.Open ("Provider=SQLNCLI11;Integrated Security=SSPI;Persist Security Info=False;" + database + ProjectSuite.Variables.FuelOpServer);
  Cmd = ADO.CreateCommand();
  Cmd.ActiveConnection = AConnection;
  Cmd.CommandType = adCmdText;
  Cmd.CommandText = compQuery;
  Cmd.CommandTimeout = 30000;  
  var compSet = Cmd.Execute();
  if(compSet.RecordCount > 0)
  {
    aqFileSystem.DeleteFile(ProjectSuite.Path + "\\SQL\\" + procName + ".txt");
    
    if (aqFile.Create(ProjectSuite.Path + "\\SQL\\" + procName + ".txt") == 0){
      
      var txtFile = aqFile.OpenTextFile(ProjectSuite.Path + "\\SQL\\" + procName + ".txt", aqFile.faWrite, aqFile.ctANSI, true);
      for (i = 0; i <= compSet.RecordCount - 1; i++)
      {
        txt = aqString.ToLower(compSet.Fields(0).Value);
        
        if(aqString.Find(txt, aqString.ToLower("Standard.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("Standard."), ProjectSuite.Variables.Database + ".");
        }
        else if(aqString.Find(txt, aqString.ToLower("StandardQA.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("StandardQA."), ProjectSuite.Variables.Database + ".");
        }
        else if(aqString.Find(txt, aqString.ToLower("StandardAutomation.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("StandardAutomation."), ProjectSuite.Variables.Database + ".");
        }
        else if(aqString.Find(txt, aqString.ToLower("FuelPurchaseOpDb.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("FuelPurchaseOpDb."), fuelDB + ".");
        }
        else if(aqString.Find(txt, aqString.ToLower("Staging.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("Staging."), stagingDB + ".");
        }
        else if(aqString.Find(txt, aqString.ToLower("CREATE PROCEDURE")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("CREATE PROCEDURE"), "ALTER PROCEDURE");
        }
        else if(aqString.Find(txt, aqString.ToLower("CREATE PROC")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("CREATE PROC"), "ALTER PROCEDURE");
        }
        else if(aqString.Find(txt, aqString.ToLower("INTSQLPRD01.")) != -1)
        {
          txt = aqString.Replace(txt, aqString.ToLower("INTSQLPRD01."), "INTERFACE1.");
        }
        txtFile.Write(txt);
        Log.Checkpoint(txt); //### Debug text ###
        compSet.MoveNext();
      } 
      txtFile.Close();
      Log.Checkpoint("Updated store procedure file created on location ==> " + ProjectSuite.Path + "\\" + procName + ".txt");
    }
    else
    {
      Log.Warning("Updated store procedure file not created.");
      return;
    }       
  }
  
  //execute updated procedure on required server  
  compQuery = aqFile.ReadWholeTextFile(ProjectSuite.Path + "\\SQL\\" + procName + ".txt", aqFile.ctANSI);
  Cmd.CommandType = adCmdText;
  Cmd.CommandText = compQuery;
  Cmd.CommandTimeout = 30000;  
  compSet = Cmd.Execute();
  Log.Checkpoint("Store procedure '" + procName + "' is updated on database " + ProjectSuite.Variables.StagingDatabase + " on server " + ProjectSuite.Variables.FuelOpServer);
  Log.PopLogFolder();
}

