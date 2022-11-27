
/***************************************************************
Name: RegressionSUITE
Description: Automated test cases - Portal E2E Regression
Author: Keith Hudson
Creation Date: 12/09/2021
***************************************************************/

// TC13721 > Regression Test: Verify Portal User
function regressionTest_13721() {
  // login to back office as back office admin
  ProjectSuite.Variables.ActiveTestSuite = "Regression";
  Main.sgbRefresh();  
  if (!equal(ProjectSuite.Variables.ActiveUserType, "Trader")) {
    Main.sgbLogout();
    PortalMAIN.loginPortalTrader(); 
  }
}

// TC15822 > Regression Test: Verify Portal Logout
function regressionTest_15822() {
  // logout and login
  Main.sgbLogout();
  PortalMAIN.loginPortalTrader(); 
}

// TC13724 > Regression Test: Verify Account Wallets
function regressionTest_13724() {
  // verify account wallets
 Main.navigatePortal("Home");
}

// TC13729 > Regression Test: Verify Account History
function regressionTest_13729() {
  // refresh test data and account
  ProjectSuite.Variables.ServiceType = "FX Trade Execution";
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // open trade history
  Main.navigatePortal("Trades");
  
  // verify trade history - search
  Project.Variables.fxTradeNumber = PortalSQL.sqlGetRandomTradeId();
  PortalFX.fxReportHistorySearch("Find", Project.Variables.fxTradeNumber);  
}

// TC13454 > Regression Test: SEN Enabled Connections
function regressionTest_13454() {
  // refresh test data
  ProjectSuite.Variables.ServiceType = "SEN Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // open profile admin
  Main.sgbSwitchPortalUser();
  BackOfficeADMIN.adminProfileNavigation("Services");
 
  // verify sen service
  BackOfficeADMIN.adminVerifyProfileServices("Transaction Limit", 1, "Save");
  
  // request transfer > new limit
  PortalSEN.senRequestTransfer(1);  
}

// TC14956 > Regression Test: SEN Transfer Eligibility
function regressionTest_14956() {
  // refresh test data
  ProjectSuite.Variables.ServiceType = "SEN Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // open profile admin
  PortalMAIN.sgbSwitchPortalUser();
  BackOfficeADMIN.adminProfileNavigation("Services");
 
  // verify sen service
  BackOfficeADMIN.adminVerifyProfileServices("Transaction Limit", 1, "Save");
  
  // request transfer > new limit
  PortalSEN.senRequestTransfer(1);  
}

// TC16214 > Regression Test: INT Transfer USD > USD
function regressionTest_16214() {
  // set internal transaction type
  ProjectSuite.Variables.ServiceType = "Internal Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // request transfer
  PortalMAIN.sgbSwitchToPortalTrader();
  PortalINT.intRequestTransfer(1);  
}

// TC16215 > Regression Test: SEN Transfer USD > USD
function regressionTest_16215() {
  // set sen transaction type
  ProjectSuite.Variables.ServiceType = "SEN Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // request transfer 
  PortalSEN.senRequestTransfer(1);  
}

// TC16216 > Regression Test: SEN Transfer USD > USD w/Approval Limit
function regressionTest_16216() {
  // set sen transaction type
  ProjectSuite.Variables.ServiceType = "SEN Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // request transfer
  PortalSQL.sqlSetUserLimit("Transaction", "0.99");
  PortalSEN.senRequestTransfer("Limit Test");   
}

// TC15075 > Regression Test: FX Quote, Trade, and Payment
function regressionTest_15075() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution";
  ProjectSuite.Variables.TransactionType = "Outbound";
  
  // refresh test data
  Main.sgbRefresh(); 
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();
  
  // get user permissioned service account
  Main.sgbTestAccount();
  
  // request fx quote
  PortalFX.fxRequestQuote(1);
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", 1);
  
  // verify trade confirmation
  PortalFX.fxTradeConfirmation();
  
  // verify trade in database
  PortalFX.fxTradeExecutionDB();  
}

// TC15076 > Regression Test: FX Quote, Trade, and Payment w/Approval
function regressionTest_15076() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution"; 
  ProjectSuite.Variables.TransactionType = "Inbound";
  
  // refresh test data
  Main.sgbRefresh(); 
     
  // set auto quoting - Manual Only
  BackOfficeSQL.sqlSetAutoQuoting(3);
  
  // switch to trader and verify trade desk
  PortalMAIN.sgbSwitchToPortalTrader();
  BackOfficeADMIN.adminVerifyTraderServices("RFQ"); 

  // refresh to home page
  PortalMAIN.navigatePortal("Home");
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();

  // get user permissioned service account
  Main.sgbTestAccount();
    
  // request fx quote
  PortalFX.fxRequestQuote(1); 
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", "Manual");  
}

// TC16220 > Regression Test: Request a Quote > Manual
function regressionTest_16220() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution"; 
  ProjectSuite.Variables.TransactionType = "Inbound";
  
  // refresh test data
  Main.sgbRefresh(); 
     
  // set auto quoting - Manual Only
  BackOfficeSQL.sqlSetAutoQuoting(3);
  BackOfficeADMIN.adminVerifyTraderServices("RFQ"); 
  
  // refresh to home page
  PortalMAIN.navigatePortal("Home");
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();

  // get user permissioned service account
  Main.sgbTestAccount();
    
  // request fx quote
  PortalFX.fxRequestQuote(1); 
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", "Manual");  
}

// TC16221 > Regression Test: Request Quote > Outbound - Manual
function regressionTest_16221() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution";
  ProjectSuite.Variables.TransactionType = "Outbound";
  
  // refresh test data
  CommonMAIN.sgbRefresh(); 
  
  // set auto quoting - Manual Only
  BackOfficeSQL.sqlSetAutoQuoting(3);
  BackOfficeADMIN.adminVerifyTraderServices("RFQ"); 
  
  // refresh to home page
  PortalMAIN.navigatePortal("Home");
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();

  // get user permissioned service account
  Main.sgbTestAccount();
    
  // request fx quote
  PortalFX.fxRequestQuote(1); 
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", "Manual");  
}

// TC15222 > Regression Test: Request a Quote > All Quoting On
function regressionTest_16222() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution";
  ProjectSuite.Variables.TransactionType = "Inbound";
  
  // refresh test data
  Main.sgbRefresh(); 
     
  // set auto quoting - All On
  BackOfficeSQL.sqlSetAutoQuoting(1);
  BackOfficeADMIN.adminVerifyTraderServices("RFQ");
  
  // refresh to home page
  PortalMAIN.navigatePortal("Home");
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();
  
  // get user permissioned service account
  Main.sgbTestAccount();
  
  // request fx quote
  PortalFX.fxRequestQuote(1);
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", 1);
  
  // verify trade confirmation
  PortalFX.fxTradeConfirmation();
  
  // verify trade in database
  PortalFX.fxTradeExecutionDB();  
}

// TC15073 > Regression Test: Request a Quote > Auto
function regressionTest_15073() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution"; 
  ProjectSuite.Variables.TransactionType = "Inbound";
  
  // refresh test data
  Main.sgbRefresh(); 
     
  // set auto quoting - Auto Only
  BackOfficeSQL.sqlSetAutoQuoting(4); 
  BackOfficeADMIN.adminVerifyTraderServices("RFQ");

  // refresh to home page
  PortalMAIN.navigatePortal("Home");
    
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();

  // get user permissioned service account
  Main.sgbTestAccount();
    
  // request fx quote
  PortalFX.fxRequestQuote(1);
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", 1);
  
  // verify trade confirmation
  PortalFX.fxTradeConfirmation();
  
  // verify trade in database
  PortalFX.fxTradeExecutionDB();  
}

// TC15074 > Regression Test: Execute a Trade
function regressionTest_15074() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution"; 
  ProjectSuite.Variables.TransactionType = "Outbound";
  
  // refresh test data and account
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();
  
  // request fx quote
  PortalFX.fxRequestQuote(1);
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", 1);
  
  // verify trade confirmation
  PortalFX.fxTradeConfirmation();
  
  // verify trade in database
  PortalFX.fxTradeExecutionDB();  
}

// TC15397 > Regression Test: Search for Trade
function regressionTest_15397() {
  // refresh test data
  Main.sgbRefresh();
  Main.sgbTestAccount(); 
  
  // open trade history
  PortalMAIN.navigatePortal("Trades");
  
  // verify trade history - search
  Project.Variables.fxTradeNumber = PortalSQL.sqlGetRandomTradeId();
  PortalFX.fxReportHistorySearch("Find", Project.Variables.fxTradeNumber);  
}

// TC15396 > Regression Test: Reporting Trade History
function regressionTest_15396() {
  // refresh test data
  Main.sgbRefresh(); 
  
  // open trade history
  PortalMAIN.navigatePortal("Trades");
  
  // verify trade history - search
  Project.Variables.fxTradeNumber = PortalSQL.sqlGetRandomTradeId();
  PortalFX.fxReportHistorySearch("Find", Project.Variables.fxTradeNumber); 
}

// TC15398 > Regression Test: Add Beneficiary
function regressionTest_15398() { 
  // refresh test data and account
  Main.sgbRefresh(); 
  
  // add post payment beneficiary
  PortalFX.addPostPaymentBeneficiary();  
}

// TC6447 > Regression Test: Verify Profile Connections
function regressionTest_6447() {
  // set payment transaction type
  ProjectSuite.Variables.ServiceType = "Payment";
  ProjectSuite.Variables.TransactionType = "Foreign Currency Payment";
  
  // refresh test data
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // verify profile connection permissions
  PortalMAIN.navigatePortal("Connections");
  PortalMAIN.portalConnections("Verify");  
}

// TC6471 > Regression Test: Add New 3rd Party Contact > Not Permissioned
function regressionTest_6471() {
  // set payment transaction type
  ProjectSuite.Variables.ServiceType = "Payment";
  ProjectSuite.Variables.TransactionType = "Foreign Currency Payment";
  
  // refresh test data
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // update current user's connection permissions
  BackOfficeSQL.sqlSetUserConnectionPermission(2); // 2 = edit existing
  
  // verify profile connection permissions
  PortalMAIN.navigatePortal("Connections");
  PortalMAIN.portalConnections("Verify");
  
  // set user connection permission to default
  BackOfficeSQL.sqlSetUserConnectionPermission(3); // 3 = add new and edit existing   
}

// TC6476 > Regression Test: Edit Existing 3rd Party Contact > Not Permissioned
function regressionTest_6476() { 
  // set payment transaction type
  ProjectSuite.Variables.ServiceType = "Payment";
  ProjectSuite.Variables.TransactionType = "Foreign Currency Payment";
  
  // refresh test data
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // update current user's connection permissions
  BackOfficeSQL.sqlSetUserConnectionPermission(1); // 1 = add new
  
  // verify profile connection permissions
  PortalMAIN.navigatePortal("Connections");
  PortalMAIN.portalConnections("Verify");
  
  // set user connection permission to default
  BackOfficeSQL.sqlSetUserConnectionPermission(3); // 3 = add new and edit existing   
}

// TC6477 > Regression Test: Delete Existing 3rd Party Contact > Not Permissioned
function regressionTest_6477() {
  // set payment transaction type
  ProjectSuite.Variables.ServiceType = "Payment";
  ProjectSuite.Variables.TransactionType = "Foreign Currency Payment";
  
  // refresh test data
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // update current user's connection permissions
  BackOfficeSQL.sqlSetUserConnectionPermission(0); // 0 = none
  
  // verify profile connection permissions
  PortalMAIN.navigatePortal("Connections");
  PortalMAIN.portalConnections("Verify");
  
  // set user connection permission to default
  BackOfficeSQL.sqlSetUserConnectionPermission(3); // 3 = add new and edit existing 
}

// TC7881 > Regression Test: Verify Service Level Approval Requirements
function regressionTest_7881() {
  // set int transaction type 
  ProjectSuite.Variables.ServiceType = "Internal Transfer";
  ProjectSuite.Variables.TransactionType = "Transfer";
  
  // login as admin and refresh test data
  BackOfficeMAIN.sgbSwitchBackOfficeUser("Back Office Admin");
  Main.sgbRefresh(); 
  Main.sgbTestAccount();
  
  // verify profile service approval requirements
  BackOfficeADMIN.adminProfileNavigation("Services");
  BackOfficeADMIN.adminVerifyProfileServices("Approval", "", "");   
}

// TC11186 > Regression Test: Verify Profile Notational and Wallet Cards
function regressionTest_18692() {
  PortalMAIN.navigatePortal("Home");
  PortalMAIN.portalWallet();  
}

// TC17597 > Regression Test: Verify Internal FX Settlement Date
function tesgressionTest_17597() {
  // set fx transaction type
  ProjectSuite.Variables.ServiceType = "FX Trade Execution";
  ProjectSuite.Variables.TransactionType = "Inbound";
  
  // refresh test data
  Main.sgbRefresh(); 
  
  // verify profile services
  PortalSQL.sqlVerifyProfileServices();

  // get user permissioned service account
  Main.sgbTestAccount();
    
  // request fx quote
  PortalFX.fxRequestQuote(1);
  
  // accept quote
  PortalFX.fxQuoteHandler("Accept", 1);
  
  // verify trade confirmation
  PortalFX.fxTradeConfirmation();
  
  // verify trade in database
  PortalFX.fxTradeExecutionDB();    
}

// TC18198 > Regression Test: Stage for Clean-up
function regressionTest_18198() {
  // refresh test data for logout
  Main.sgbRefresh();   
}
