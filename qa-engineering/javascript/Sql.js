/***************************************************************
Name: Sql
Description: Backend database handling - SSMS & ADO
Author: kITt
Creation Date: 08/19/2022
***************************************************************/

function setEnvironment(envt) {
  Project.Variables.sgbEnvironment = envt;
  switch (Project.Variables.sgbEnvironment){
    case "stg":
      Project.Variables.dboPass = Project.Variables.dboPassSTG.DecryptedValue;
      break;
    case "qa":
      Project.Variables.dboPass = Project.Variables.dboPassQA.DecryptedValue;
      break;
  }
  Project.Variables.dboServerURL = Project.Variables.dboServer + Project.Variables.sgbEnvironment + ".database.windows.net"; 
  Log.Checkpoint("| Environment Set | - " + aqString.ToUpper(Project.Variables.sgbEnvironment)); 
}


// SQL - NADA
// executes sql statement without capturing results (ex:update)
function sqlQueryNone(query) {
  Log.Message("SQL Query: " + query);
  var AConnection, recSet;
  
  AConnection = ADO.CreateConnection();
  AConnection.ConnectionString = "Provider=SQLNCLI11;"
    + "Server=tcp:" + Project.Variables.dboServerURL + ";"
    + "Database=sqldb-" + Project.Variables.varDbName + "-" + Project.Variables.sgbEnvironment + ";"
    + "Uid=" + Project.Variables.dboUser + ";" 
    + "Pwd=" + Project.Variables.dboPass.DecryptedValue + ";";     
  AConnection.Open();
  recSet = AConnection.Execute(query);
  AConnection.Close();
}

// SQL - SOLO
// executes sql statement capturing single result
function sqlQueryOne(query) {
  Log.Message("SQL Query: " + query);
  var AConnection, recSet, result;

  AConnection = ADO.CreateConnection();
  AConnection.ConnectionString = "Provider=SQLNCLI11;"
    + "Server=tcp:" + Project.Variables.dboServerURL + ";"
    + "Database=sqldb-" + Project.Variables.varDbName + "-" + Project.Variables.sgbEnvironment + ";"
    + "Uid=" + Project.Variables.dboUser + ";" 
    + "Pwd=" + Project.Variables.dboPass.DecryptedValue + ";";
  AConnection.Open();
  recSet = AConnection.Execute(query);
  if (!equal(recSet.Fields.Item(0).Value, "0")) {
    result = recSet.Fields.Item(0).Value;
    Log.Message("SQL Query Result: " + result);
  }
  else {
    Log.Warning("WARNING: no records found");
  }
  return result;
  AConnection.Close();
}

// SQL - ARRAY
// executes sql statement capturing results in an array
function sqlQueryArray(query) {
  Log.Message("SQL Query: " + query);
  var AConnection, recSet, results;
  var dataSet = [];
  
  AConnection = ADO.CreateConnection();
  AConnection.ConnectionString = "Provider=SQLNCLI11;"
    + "Server=tcp:" + Project.Variables.dboServerURL + ";"
    + "Database=sqldb-" + Project.Variables.varDbName + "-" + Project.Variables.sgbEnvironment + ";"
    + "Uid=" + Project.Variables.dboUser + ";" 
    + "Pwd=" + Project.Variables.dboPass.DecryptedValue + ";";
  AConnection.Open();
  recSet = AConnection.Execute(query);
  for (i = 0; i <= recSet.RecordCount - 1; i++) {
    dataSet.push(" " + recSet.Fields.Item(0).Value);
    recSet.MoveNext();
  }  
  ProjectSuite.Variables.DynamicVarInt = recSet.RecordCount; // track number of records in array
  return dataSet;
  AConnection.Close();
}

// SQL - BOOLEAN
// executes sql statement with expected boolean result
function sqlQueryBool(query) {
  Log.Message("SQL Query: " + query);
  var AConnection, recSet, result;

  AConnection = ADO.CreateConnection();
  AConnection.ConnectionString = "Provider=SQLNCLI11;"
    + "Server=tcp:" + Project.Variables.dboServerURL + ";"
    + "Database=sqldb-" + Project.Variables.varDbName + "-" + Project.Variables.sgbEnvironment + ";"
    + "Uid=" + Project.Variables.dboUser + ";" 
    + "Pwd=" + Project.Variables.dboPass.DecryptedValue + ";";
  AConnection.Open();
  recSet = AConnection.Execute(query);
  if (recSet.Fields.Item(0).Value >= "0") {
    result = recSet.Fields.Item(0).Value;
    Log.Message("SQL Query Result: " + result);
  }
  else {
    Log.Warning("WARNING: no records found");
  }
  return result;
  AConnection.Close();
}

//**********//
function sqlGetEnabledServices() {
  CommonSQL.sqlDatabaseHandler("sqldb-entitlements-" + aqString.ToLower(ProjectSuite.Variables.Environment));
  var dataset = CommonSQL.sqlQueryArray("SELECT s.[Name] FROM [Service] s "
    + "INNER JOIN [ProfileService] ps ON ps.[ServiceId] = s.[ServiceId] "
    + "WHERE ps.[ProfileId] = '" + ProjectSuite.Variables.ProfileId 
    + "' AND s.[Enabled] = 1 AND s.Name = '" + ProjectSuite.Variables.ServiceType + "'");
  return dataset;
}

function sqlGetTradeExecutionData(column){
  CommonSQL.sqlDatabaseHandler("sqldb-fx-" + aqString.ToLower(ProjectSuite.Variables.Environment));
  var dataset = CommonSQL.sqlQueryOne("SELECT [" + column + "] FROM [TradeExecution] WHERE [SierraTradeId] = '" 
    + Project.Variables.fxTradeNumber + "'");
  return dataset;
}

function sqlGetRandomTradeId(){
  CommonSQL.sqlDatabaseHandler("sqldb-fx-" + aqString.ToLower(ProjectSuite.Variables.Environment));   
  var dataset = CommonSQL.sqlQueryOne("SELECT ISNULL((SELECT TOP 1 [SierraTradeId] FROM [TradeExecution] WHERE [ChangedBy] = '" 
    + ProjectSuite.Variables.ProfileUserOkta + "' AND CAST([DateReceived] AS DATE) >= CAST(GETDATE() - 6 AS DATE) ORDER BY NEWID()), 0)"); // past 7 days
  if (equal(dataset, 0)) {
    dataset = CommonSQL.sqlQueryOne("SELECT ISNULL((SELECT TOP 1 [SierraTradeId] FROM [TradeExecution] "
    + "WHERE CAST([DateReceived] AS DATE) >= CAST(GETDATE() - 6 AS DATE) ORDER BY NEWID()), 0)");  
  }
  return dataset;
}

function sqlGetRandomPaymentId(){
  CommonSQL.sqlDatabaseHandler("sqldb-payments-" + aqString.ToLower(ProjectSuite.Variables.Environment));   
  var dataset = CommonSQL.sqlQueryOne("SELECT ISNULL((SELECT TOP 1 [FinastraPaymentId] FROM [Payment] WHERE [SubmittedById] = '"
    + ProjectSuite.Variables.ProfileUserOkta + "' AND CAST([SubmittedDate] AS DATE) >= CAST(GETDATE() - 6 AS DATE) "
    + "AND [FinastraPaymentId] IS NOT NULL ORDER BY NEWID()), 0)"); // past 7 days
  if (equal(dataset, 0)) {
    dataset = CommonSQL.sqlQueryOne("SELECT ISNULL((SELECT TOP 1 [FinastraPaymentId] FROM [Payment] "
    + "WHERE CAST([SubmittedDate] AS DATE) >= CAST(GETDATE() - 6 AS DATE) ORDER BY NEWID()), 0)");  
  }
  return dataset;
}

function sqlGetProfileAccountInfo() {
  CommonSQL.sqlDatabaseHandler("sqldb-entitlements-" + aqString.ToLower(ProjectSuite.Variables.Environment));
  var acctNames = CommonSQL.sqlQueryArray("SELECT [Alias] FROM [ProfileAccount] WHERE [ProfileId] IN (SELECT [ProfileId] FROM [Profile] "
    + "WHERE [Name] = '" + ProjectSuite.Variables.ProfileName + "')");
  var acctList = aqString.Trim(acctNames, aqString.stLeading);
  Log.Message("LOG: acctIds - " + acctList);
  return acctList;  
}