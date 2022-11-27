//Purpose: Returns an object with all essential PO data
function GetPurchaseOrderInfo(purchaseOrderNumber)
{

  //Query SQL for the load plan data
  var query = "SELECT " +
                "lphr.PurchaseOrderNumber, lps.LoadPlanStatusName, lphr.RevisionNumber, c.RegionalCarrierName, " +
                "d.DriverName, lphr.PlannedDateTime, lphr.IntendedPickupDateTime, lphr.DeliveredDateTime, si.StationName, " +
                "rpg.Name, vtrg.RawGradeName, lpdr.RawGradeGallons, vtrg.VendorName, vtrg.TerminalName, lpdr.Price " +
              "FROM LoadPlanHeaderResponses lphr " +
              "JOIN LoadPlanstatus lps ON lphr.LoadPlanStatus = lps.LoadPlanStatusId " +
              "JOIN vDispatchHistoryDispatcherMaxRevision dhdmr ON lphr.PurchaseOrderNumber = dhdmr.PurchaseOrderNumber " +
                "AND lphr.RevisionNumber = dhdmr.RevisionNumber " +
              "JOIN vCarrier c ON lphr.CarrierID = c.RegionalCarrierID " +
              "JOIN vDriver d ON lphr.DriverID = d.UserName " +
              "JOIN LoadPlanDetailResponses lpdr ON lphr.LoadPlanHeaderResponseID = lpdr.LoadPlanHeaderResponse_LoadPlanHeaderResponseID " +
              "JOIN vStationInformations si ON lpdr.StationNumber = si.StationNumber " +
              "JOIN ReportingPumpGrade rpg ON lpdr.PumpGradeID = rpg.PumpGradeID " +
              "JOIN vVendorTerminalRawGrade vtrg ON lpdr.RawGradeID = vtrg.RawGradeID " +
                "AND lpdr.VendorID = vtrg.VendorID " +
                "AND lpdr.TerminalID = vtrg.TerminalID " +
              "WHERE lphr.PurchaseOrderNumber = " + purchaseOrderNumber;
  var queryResult;

  //Create New Connection to SQL Server   
  AConnection = ADO.CreateConnection();
  AConnection.Open ("Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;"+ ProjectSuite.Variables.Database + ProjectSuite.Variables.Server);
  Cmd = ADO.CreateCommand();
  Cmd.ActiveConnection = AConnection;
  Cmd.CommandType = adCmdText;
  Cmd.CommandText = query;
  recSet = Cmd.Execute();
  
  //Create array variables from later user in generating the object
  var purchaseOrderNumber = purchaseOrderNumber;
  var status = recSet.Fields("LoadPlanStatusName").Value;
  var latestRevision = recSet.Fields("RevisionNumber").Value;
  var carrier = recSet.Fields("RegionalCarrierName").Value;
  var driver = recSet.Fields("DriverName").Value;
  var planTime = recSet.Fields("PlannedDateTime").Value;
  var intendedPickup = recSet.Fields("IntendedPickupDateTime").Value;
  var deliveryDate = recSet.Fields("DeliveredDateTime").Value;
  var stationName = [];
  var pumpGradeName = [];
  var rawGradeName = [];
  var gallons = [];
  var vendorName = [];
  var terminalName = [];
  var price = [];
  
  //Loop through the record set to retrieve detail records
  recSet.MoveFirst();
  while (recSet.EOF == false){
    stationName.push(recSet.Fields("StationName").Value);
    pumpGradeName.push(recSet.Fields("Name").Value);
    rawGradeName.push(recSet.Fields("RawGradeName").Value);
    gallons.push(ManageActions["formatNumber"](recSet.Fields("RawGradeGallons").Value));
    vendorName.push(recSet.Fields("VendorName").Value);
    terminalName.push(aqString.Trim(recSet.Fields("TerminalName").Value, 2));
    price.push((recSet.Fields("Price").Value).toFixed(6));
    recSet.MoveNext();
  }

  //Create purchaseOrder object
  var purchaseOrder = {
    purchaseOrderNumber: purchaseOrderNumber,
    loadPlanStatus: status,
    revision: latestRevision,
    carrier: carrier,
    driver: driver,
    planTime: planTime,
    intendedPickup: intendedPickup,
    deliveryDate: deliveryDate,
    stationName: stationName,
    pumpGrade: pumpGradeName,
    rawGrade: rawGradeName,
    gallons: gallons,
    vendor: vendorName,
    terminal: terminalName,
    price: price
  };
  
  return purchaseOrder;
  
}



//This function returns actual distance between store to terminal for given Id's
//Input Param : StoreId="52"
//Input Param :TerminalId="82"
function GetDistanceByStoreTerminalId(StoreId,TerminalId)
{

  var distance = null;
  //Log.Checkpoint("GetDistanceByStoreTerminalId() Info","Driver={SQL Server};" + ProjectSuite.Variables.Server + ProjectSuite.Variables.Database + ProjectSuite.Variables.Login) //####
  var compQuery = "SELECT dst.Distance FROM DistanceStoreTerminal dst WHERE dst.TerminalId = "+TerminalId+" AND dst.StoreId ="+StoreId;
  AConnection = ADO.CreateConnection();
  //AConnection.Open ("Driver={SQL Server};" + ProjectSuite.Variables.Server + ProjectSuite.Variables.Database + ProjectSuite.Variables.Login);
  AConnection.Open ("Provider=SQLOLEDB.1;Integrated Security=SSPI;Persist Security Info=False;"+ ProjectSuite.Variables.Database + ProjectSuite.Variables.Server);
  Cmd = ADO.CreateCommand();
  Cmd.ActiveConnection = AConnection;
  Cmd.CommandType = adCmdText;
  Cmd.CommandText = compQuery;
  var compSet = Cmd.Execute();
  if(compSet.RecordCount > 0)
  {
      distance = compSet.Fields(0).Value;
      Log.Message("Distance between Store to Terminal is ==> "+ distance);
  }
  else
  {
      Log.Message("No data found in GetStoreTerminalDistanceById for StoreId : "+StoreId+" And TerminalId : "+ TerminalId);
  }
  return distance; 

}