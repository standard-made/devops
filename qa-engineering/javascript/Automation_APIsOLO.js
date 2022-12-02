//USEUNIT Common
//USEUNIT Spreadsheets
//USEUNIT Orders

/***************************************************************
Name: APIs
Description: Verifying Standard's OnlineOrders APIs
Author: 8Kit
Date: 11/20/2020

Revision History:
01) 11/20/2020 kit: Initial Creation, RandomOrdersAPIEndpoint()
02) 11/23/2020 kit: Run count, store parameters, basic auth, logging
03) 12/04/2020 kit: Refactor for enhanced envt and runtime handling
04) 12/17/2020 kit: Added counter/logging for All_OrdersAPIEndpoint()
***************************************************************/
function Random_OrdersAPIEndpoint()
{
  // Get credentials for basic auth
  APIs.getCredentials();
  
  // Variables
  var address;
  var i;
  var numOfRuns = aqConvert.StrToInt(ProjectSuite.Variables.numberOfOrders);

  // Specified run count
  Log.Checkpoint("Number of Runs: " + numOfRuns);
  for(i = 0; i < numOfRuns; i++)
  {  
    // Get random order info
    Common.GetRandomUser();
    Common.GetRandomProduct();
    
    // Set store parameters
    if(ProjectSuite.Variables.environment == "PROD")
    {
      Common.GetStoreInfo("Random", "");
      Common.envtAPIHandler();    
    }
    else
    {
      Common.envtAPIHandler();
    }
  
    // Send API request and verify response code
    APIs.sendOnlineOrdersAPIRequest(credentials);
  } 
}

function All_OrdersAPIEndpoint()
{
  // Get credentials for basic auth
  APIs.getCredentials();
  
  // Convert the user credentials to base64 for preemptive authentication
  var credentials = aqConvert.VarToStr(dotNET.System.Convert.ToBase64String
    (dotNET.System_Text.Encoding.UTF8.GetBytes_2(ProjectSuite.Variables.user + ":" + ProjectSuite.Variables.password)));
    
  // Variables
  var i, j;
  ProjectSuite.Variables.counter = 0; 
  
  // Environment handling if envt != PROD
  ProjectSuite.Variables.envtURL = Common.envtAPIHandler();
  Common.envtStoreHandler();
  
  // Set to run for All Stores by obtaining record cound of current driver 
  while (! DDT.CurrentDriver.EOF())
  {
    if(DDT.CurrentDriver.Value(0) == null)
    {
      // end of file
      break;
    }
    else
    {
      // Count rows
      i = DDT.CurrentDriver.Value(0); 
      DDT.CurrentDriver.Next();
    }
  }
  
  // Post store count
  ProjectSuite.Variables.orderCount = i;
  Log.Checkpoint("NUMBER OF STORES: " + i);
  DDT.CloseDriver(DDT.CurrentDriver.Name);
    
  // Post one order per store - All Stores
  for(j = 1; j <= i; j++)
  {     
    // Get order info
    Common.GetStoreInfo("All", "");
    Common.GetRandomUser();
    Common.GetRandomProduct();
    
    // Send API request and verify response code
    APIs.sendOnlineOrdersAPIRequest(credentials);  
  }   
}

function sendOnlineOrdersAPIRequest(credentials)
{
  // Loop variables
  var phoneNumber = Common.getRandomInteger(4041000000, 4041999999);
  var randomQty = Common.getRandomInteger(1, 5); 
    
  // Convert the address and user credentials to base64 for preemptive authentication
  var address = ProjectSuite.Variables.envtURL;
  var credentials = aqConvert.VarToStr(dotNET.System.Convert.ToBase64String
    (dotNET.System_Text.Encoding.UTF8.GetBytes_2(ProjectSuite.Variables.user + ":" + ProjectSuite.Variables.password)));
  
  // Define the request body JSON string
  var requestBody = '{"emailAddress": "' + ProjectSuite.Variables.email + '", "storeNumber": "' + ProjectSuite.Variables.storeNumber 
    + '", "FirstName": "' + ProjectSuite.Variables.firstName + '", "LastName": "' + ProjectSuite.Variables.lastName + '", "Phone": "' + phoneNumber 
    + '", "items": [{"SkuID": "' + ProjectSuite.Variables.productSKU + '", "qty": "' + randomQty + '"}]}';
    
  // Create the aqHttpRequest object
  var aqHttpRequest = aqHttp.CreatePostRequest(address, ProjectSuite.Variables.user, ProjectSuite.Variables.password);

  // Specify the Content-Type header value
  aqHttpRequest.SetHeader("Authorization", "Basic " + credentials);
  aqHttpRequest.SetHeader("Content-Type", "application/json");

  // Send the request, create the aqHttpResponse object, check the responses
  var aqHttpResponse = aqHttpRequest.Send(requestBody)
  
  // Check the response:
  if (aqHttpResponse != null)
  {
    // Read the response data
    Log.Message(aqHttpResponse.AllHeaders); // All headers      
    if(aqHttpResponse.StatusCode >= 100 && aqHttpResponse.StatusCode < 200) // Response status codes
    {
      Log.Warning("Informational response (100–199): " + aqHttpResponse.StatusCode);
    }
    else if (aqHttpResponse.StatusCode >= 200 && aqHttpResponse.StatusCode < 300)
    {
      Log.Checkpoint("Successful response (200–299): " + aqHttpResponse.StatusCode);
    }
    else if (aqHttpResponse.StatusCode >= 300 && aqHttpResponse.StatusCode < 400)
    {
      Log.Warning("Redirect (300–399): " + aqHttpResponse.StatusCode);
    }
    else if (aqHttpResponse.StatusCode >= 400 && aqHttpResponse.StatusCode < 500)
    {
      Log.Warning("Client error (400–499): " + aqHttpResponse.StatusCode);
    }
    else if (aqHttpResponse.StatusCode >= 500 && aqHttpResponse.StatusCode < 600)
    {
      Log.Warning("Server error (500–599): " + aqHttpResponse.StatusCode);
    }
    else
    {
      Log.Warning("Review status code: " + aqHttpResponse.StatusCode)  
    }
    Log.Message(aqHttpResponse.StatusText); // A status text
    Log.Message(requestBody); // A request body
  } 
}

function getCredentials()
{
  // Grab credentials and close the driver 
  Spreadsheets.SetSpreadsheet("\\Spreadsheets\\OLO_RandomOrder.xlsx", "Credentials");
  ProjectSuite.Variables.user = DDT.CurrentDriver.Value(0);
  ProjectSuite.Variables.password = DDT.CurrentDriver.Value(1);
  DDT.CloseDriver(DDT.CurrentDriver.Name);
}
