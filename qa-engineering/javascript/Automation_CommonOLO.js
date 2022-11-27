//USEUNIT Spreadsheets

/***************************************************************
Name: Common
Description: Various reusable functions.
Author: 8Kit
Date: 10/23/2020

Revision History:
01) 10/23/2020 kit: Initial Creation
02) 11/17/2020 kit: setTestEnvironment()
03) 12/03/2020 kit: Migrate functions to Common
04) 12/04/2020 kit: Refactor for enhanced envt and runtime handling
05) 12/17/2020 kit: Refactor GetStoreInfo() for AreaTest & All stores
***************************************************************/
function KillBrowser()
{
  while (Sys.WaitBrowser("iexplore").Exists)
    {
      Sys.Browser("iexplore").Terminate()
    }
    Log.Checkpoint("Browser is closed");    
}

function Wait(timeInSeconds)
{
  Delay(timeInSeconds * 1000);
}

function waitProp(propName,popValues)
{
    Sys.Browser("*").Page("*").WaitProperty(propName,popValues);
}

function getRandomInteger(min, max)
{
  return Math.round(Math.random()*(max-min)+min);
}

function setTestEnvironmnet()
{
  //Show form
  UserForms.EnvtForm.ShowModal();
  var store;
  var url;
  var address;
  var environmentSetup = false;
  var environment = UserForms.EnvtForm.cxComboBox1;
  var numberOfOrders = UserForms.EnvtForm.cxSpinEdit1;
  if(environment.ItemIndex == -1)
  {
    ShowMessage("Please select an environment");
    return setTestEnvironmnet(); 
  }
  else
  {     
    store = "100";
    address = "111 12th Avenue E., Bradenton, FL, 34208";   
    var envt = UserForms.EnvtForm.cxComboBox1.Text;
    switch(aqString.Replace(envt, '"', ""))
    {  
      case "DEV" :        
        url = "https://orderswebappdev.azurewebsites.net/";
        break;  
      
      case "QA" :
        url = "https://orderswebappqa.azurewebsites.net/";
        break;
    
      case "DEPLOY" :
        url = "https://orderswebappdeploy.azurewebsites.net/";
        break;
        
      case "PROD" :
        url = "https://order.racetrac.com/";
        break;
    }
    ProjectSuite.Variables.storeNumber = store;
    ProjectSuite.Variables.storeAddress = address;
    ProjectSuite.Variables.environment = envt;
    ProjectSuite.Variables.envtURL = url;
    ProjectSuite.Variables.numberOfOrders = numberOfOrders.Value;
    environmentSetup = true;
  }
  Log.Checkpoint("Environment: " + ProjectSuite.Variables.environment + " | URL: "
    + ProjectSuite.Variables.envtURL + " | #Orders: " + ProjectSuite.Variables.numberOfOrders)
  return environmentSetup;
}

function clearCookies()
{
  // clear cookies/cache for subsequent runs
  Sys.Browser("*").ToUrl("chrome://settings/clearBrowserData");
  Sys.Browser("*").Page("*").Click(1275, 625);
  Wait(1);
}

function GetStoreInfo(start, store)
{
  // Environment handler
  Common.envtStoreHandler();
  
  var storeInfo;
  
  // Run type handler
  switch (start)
  {
    case "All":
      // Increment store counter for All stores
      ProjectSuite.Variables.counter++;
      storeInfo = ProjectSuite.Variables.counter;
      Log.Checkpoint("order " + storeInfo + " of " + ProjectSuite.Variables.orderCount)
      break;
    case "Random":
      var storeInfo = Common.getRandomInteger(1, 592); //current store count;
      break;
    case "Single":
      var storeInfo = store;
  }
  
  // Iterates through records
  while (! DDT.CurrentDriver.EOF())
  {       
    //Gets a value from storage and posts it to the log
    if (DDT.CurrentDriver.Value(0) == storeInfo)
    {
      ProjectSuite.Variables.storeNumber = DDT.CurrentDriver.Value(1);
      ProjectSuite.Variables.storeAddress = DDT.CurrentDriver.Value(2); 
      Log.Message("STORE NUM: " + ProjectSuite.Variables.storeNumber + " | STORE: " + ProjectSuite.Variables.storeAddress);
      return ProjectSuite.Variables.storeNumber, ProjectSuite.Variables.storeAddress;
    }    
    DDT.CurrentDriver.Next();       
  } 
  
  // Closes the driver
  DDT.CloseDriver(DDT.CurrentDriver.Name);
}

function envtAPIHandler()
{
    // Set store parameters
    switch (ProjectSuite.Variables.environment)
    {
      case "PROD" :   
        address = "https://order.racetrac.com/api/servicenow/CreateTestOrder"; 
        break;
      case "DEPLOY" :    
        address = "https://orderswebappdeploy.azurewebsites.net/api/servicenow/CreateTestOrder"; 
        break;
      case "QA" :   
        address = "https://orderswebappqa.azurewebsites.net/api/servicenow/CreateTestOrder"; 
        break;
      case "DEV" :   
        address = "https://orderswebappdev.azurewebsites.net/api/servicenow/CreateTestOrder"; 
        break;
    }
    return address;
}

function envtStoreHandler()
{
  // Change envt
  if(ProjectSuite.Variables.environment == "PROD")
  {
    Spreadsheets.SetSpreadsheet("\\Spreadsheets\\OLO_RandomOrder.xlsx", "AreaTest"); //Stores for PROD
  }
  else
  {
    Spreadsheets.SetSpreadsheet("\\Spreadsheets\\OLO_RandomOrder.xlsx", "AreaTest"); // or AreaTest
  }
}

function GetRandomUser()
{                                            
  Spreadsheets.SetSpreadsheet("\\Spreadsheets\\OLO_RandomOrder.xlsx", "Users");
  var randomUser = Common.getRandomInteger(1, 100)
  
  
  // Iterates through records
  while (! DDT.CurrentDriver.EOF())
  { 
    //Gets a value from the storage and posts it to the log
    if (DDT.CurrentDriver.Value(0) == randomUser){
      ProjectSuite.Variables.firstName = DDT.CurrentDriver.Value(1); 
      ProjectSuite.Variables.lastName = DDT.CurrentDriver.Value(2);
      ProjectSuite.Variables.email = DDT.CurrentDriver.Value(3); 
      Log.Message("FIRST: " + ProjectSuite.Variables.firstName + " | LAST: " 
        + ProjectSuite.Variables.lastName + " | EMAIL: " + ProjectSuite.Variables.email);
      return ProjectSuite.Variables.firstName + ProjectSuite.Variables.lastName + ProjectSuite.Variables.email;
    }    
    DDT.CurrentDriver.Next(); 
  }
  
  // Closes the driver
  DDT.CloseDriver(DDT.CurrentDriver.Name);
}

function GetRandomProduct()
{
  Spreadsheets.SetSpreadsheet("\\Spreadsheets\\OLO_RandomOrder.xlsx", "Products");
  var randomProduct = Common.getRandomInteger(1, 12);
  
  // Iterates through records
  while (! DDT.CurrentDriver.EOF())
  { 
    //Gets a value from the storage and posts it to the log
    if (DDT.CurrentDriver.Value(0) == randomProduct){
      ProjectSuite.Variables.product = DDT.CurrentDriver.Value(1);
      ProjectSuite.Variables.productSKU = DDT.CurrentDriver.Value(2); 
      Log.Message("PRODUCT: " + ProjectSuite.Variables.product + " | SKU: " + ProjectSuite.Variables.productSKU);
      return ProjectSuite.Variables.product, ProjectSuite.Variables.productSKU;
    }    
    DDT.CurrentDriver.Next(); 
  }
  
  // Closes the driver
  DDT.CloseDriver(DDT.CurrentDriver.Name);
}