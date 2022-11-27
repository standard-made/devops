**<h1> STANDARD: DATABASE CONNECTIONS </h1>**
![standard-automation.png](/src/standard-automation.png)



## <span style="color:#555555"><u> **OVERVIEW** </u></span>
TestComplete uses ADO (ActiveX Data Objects), which are used to establish a connection to the STANDARD data sources exposed through OLE DB and ODBC (currently we use OLEDB). In TestComplete, the ADO connection is established, the database connection string is provided (found in Azure key vault), the connection is opened, the provided SQL statement is executed, and the connection is closed. 



## <span style="color:#555555"><u> **POINTS OF CONTACT** </u></span>
When issues arise for any of the below mentioned areas, please contact the associated personnel for support and troubleshooting.

:taco: **QA Engineering:**<span style="color:gold"> kit@made.llc </span>



## <span style="color:#555555"><u> **CONNECTION STRINGS** </u></span>
See [SQL Server Connection Strings](https://www.connectionstrings.com/sql-server/) for more examples.



## <span style="color:#555555"><u> **EXAMPLE** </u></span>
Below is an example of how TestComplete connects to a data source using ADO and the OLE DB provider to access the specified database within the automation:
``` js
// executes sql statement without capturing results (ex:update)
function sqlQueryNone(query) {
  // set log and variables
  Log.Message("SQL Query: " + query);
  var AConnection, recSet;
  
  // create a connection object
  AConnection = ADO.CreateConnection();
  
  // specify the connection string
  AConnection.ConnectionString = "Provider=SQLNCLI11;"
    + "Server=tcp:" + ProjectSuite.Variables.dboDatabaseServer + ".database.windows.net;"
    + "Database=" + ProjectSuite.Variables.dboDatabase + ";"
    + "Uid=" + ProjectSuite.Variables.dboDatabaseUser + ";" 
    + "Pwd=" + ProjectSuite.Variables.dboDatabasePass.DecryptedValue + ";";
  
  // open the connection
  AConnection.Open();
  
  // execute a simple query
  recSet = AConnection.Execute(query);
  
  // close the connection
  AConnection.Close();
}
```
<span style="color:#A6A6A6"> NOTE: </span> The provider specified in the connection string = SQLNCLI11. This is the name for the SQL Native Client 11 OLE DB provider originally released with SQL Server 2012 and that comes pre-packaged with SQL Server Management Studio. The SQL Server Native Client OLE DB provider is a low-level COM API that is used for accessing data and is the current provider specified within the automation scripts - so it must be installed on the agent VM's when running tests through an Azure pipeline.