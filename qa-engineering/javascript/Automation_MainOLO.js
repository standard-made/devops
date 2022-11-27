//USEUNIT Orders
//USEUNIT APIs

/***************************************************************
Name: MAIN
Description: Run main functions - Regression
Author: 8Kit
Date: 11/20/2020

Revision History:
01) 11/23/2020 kit: RunRandomOrders, RunRandomOrdersAPIEndpoint()
02) 12/04/2020 kit: QuickAndDirty_OrdersAPI() 
***************************************************************/
// Submits randomized orders thru OLO API endpoint
function Random_OrdersAPI()
{
  Common.setTestEnvironmnet();
  APIs.Random_OrdersAPIEndpoint();
}

// Submits randomized orders thru OLO UI
function Random_OrdersUI()
{
  Common.setTestEnvironmnet();
  Orders.Random_OrdersUI();  
}

// Submits one order per store - all stores
function QuickAndDirty_OrdersAPI()
{
  ProjectSuite.Variables.environment = "PROD"; // other options: DEV, QA, DEP = run on test envt
  APIs.All_OrdersAPIEndpoint();  
}