//USEUNIT Common
//USEUNIT Spreadsheets

/***************************************************************
Name: Orders
Description: Verifying RaceTrac's Online Orders platform.
Author: 8Kit
Date: 10/23/2020

Revision History:
01) 10/23/2020 kit: RandomOrders()
02) 11/12/2020 kit: GetRandomUser(), GetRandomStore(), GetRandomProduct()
03) 11/17/2020 kit: RunRandomOrders(), Orders.setTestEnvironmnet()
03) 12/04/2020 kit: Refactor for enhanced envt and runtime handling
***************************************************************/
function RandomOrdersUI()
{ 
  // Close all browsers
  var batchFile = Project.Path + "\\Stores\\Files\\Kill Browsers.bat";
  var objShell = Sys.OleObject("WScript.Shell");
  var i;
  var numOfRuns = aqConvert.StrToInt(ProjectSuite.Variables.numberOfOrders);
  objShell.Run("\"" + batchFile + "\"");
  Common.Wait(1);
  Sys.Refresh(); 
  
  // let user input determine envt & number of runs
  for(i = 0; i < numOfRuns; i++)
  {
    // Get random user, product, store and open web page 
    GetRandomUser();
    GetRandomProduct();
    if(ProjectSuite.Variables.environment == "PROD") 
    { 
      Common.GetStoreInfo(); 
    }
    if (Sys.WaitBrowser("chrome").Exists == false)
    {
      Browsers.Item(btChrome).Run(ProjectSuite.Variables.envtURL, 2500);
      Sys.Browser().BrowserWindow(0).Maximize();
    }
    let page = Sys.Browser("*").page("*"); 
   
    // Searches for the location control
    let location = page.Find("namePropStr", "Locations", 1000);
    if (location.Exists == false){
      Log.Warning("Object was not found.");
    }
    location.Click();
  
    // Find storeAddress variable in search
    let addressSearch = page.Section(0).Panel(0).Panel(0).Panel(0).Panel(0).Panel(0).Textbox("googlelocation");
    if (addressSearch.Exists == false){
      Log.Warning("Object was not found.");
    }
    addressSearch.SetText(ProjectSuite.Variables.storeAddress);
    addressSearch.Keys("[Enter]");
    //Common.Wait(2.5);
    //addressSearch.SetText(""); // clear for subsequent runs
  
    // Select storeAddress variable using first 5 characters to find store element
    let storeList = page.Section(0).Panel(0).Panel(0).Panel(0).Panel("radioGroup").Panel("store_" + ProjectSuite.Variables.storeNumber);
    if (storeList.Exists == false){
      Log.Warning("Object was not found.");
    }
    storeList.Click();
  
    // Select store
    let viewStore = storeList.Link("button" + ProjectSuite.Variables.storenumber);
    if (viewStore.Exists == false){
      Log.Warning("Object was not found.");
    }
    viewStore.Click();
    
//    // ERROR HANDLING FOR CLOSED STORES
//    page.Refresh(); 
//    if(page = ProjectSuite.Variables.envtURL + "Disabled?reason=*")
//    {
//      GetRandomStore(); // get new location
//      location.Click();
//      addressSearch.SetText(ProjectSuite.Variables.storeAddress);
//      addressSearch.Keys("[Enter]");
//      addressSearch.SetText(""); 
//      storeList.Click();
//      viewStore.Click(); 
//    }
  
    // Find product search and filter
    let productSearch = page.Section(0).Panel(0).Panel(1).Panel(0).SearchBox("productSearch");
    if (productSearch.Exists == false){
      Log.Warning("Object was not found.");
    }
    productSearch.SetText(ProjectSuite.Variables.product);
    productSearch.Keys("[Enter]");
    
    // Development environments require GoogleAds/Analystic APIs to fail before refreshing search results (thanks ITSec)
    if(ProjectSuite.Variables.environment == "DEV" || ProjectSuite.Variables.environment == "QA" || ProjectSuite.Variables.environment == "DEPLOY")
    {
      Common.Wait(15); // usually 10-15 second delay - max
    }
  
    // Open product details
    let productPropArray = new Array("ObjectLabel", "ObjectType");
    let productValuesArray = new Array(ProjectSuite.Variables.product + "*", "Button");
    let productButton = page.Find(productPropArray, productValuesArray, 1000);
    if(productButton.Exists == false){
      Log.Error("The object was not found.");
    }
    productButton.Click();
  
    // Add product to cart
    let orderPropArray = new Array("ObjectLabel", "ObjectType");
    let orderValuesArray = new Array("Add to Bag", "Button");
    let findButton = page.Section(1).Panel(0).Panel(0).Panel(0).Panel("productDetail").Find(orderPropArray, orderValuesArray, 1000);
    findButton.scrollIntoView();
    findButton.Click();
  
    // Click cart to review order
    let cart = page.Nav(0).Find("className", "shoppingBag", 5);
    cart.Click();
  
    // Comfirm checkout
    let main = page.Panel(0).Panel(0).Section(2).Panel(0).Panel(0).Panel(0).Panel(0);
    main.Panel(7).scrollIntoView();
    Common.Wait(.5);
    main.Panel(7).Panel(0).Link("instoreBtn").Click();
  
    // Fill out customer info and complete checkout              
    let phoneNumber = Common.getRandomInteger(4041000000, 4041999999);
    let insider = main.Form(0).Find("ObjectIdentifier", "insiderSubscription", 1000);
    let captcha = main.Form(0).Panel(8).Panel(0).Panel(0).Panel(0).Find("nodeName", "IFRAME", 1000);
    main.Form(0).Panel(1).Textbox("Customer_FirstName").SetText(ProjectSuite.Variables.firstName);
    main.Form(0).Panel(2).Textbox("Customer_LastName").SetText(ProjectSuite.Variables.lastName);
    main.Form(0).Panel(3).EmailInput("Customer_Email").SetText(ProjectSuite.Variables.email);
    main.Form(0).Panel(4).Textbox("Customer_PhoneNumber").SetText(phoneNumber);
    insider.Click(); //enabled by default
    
    // reCAPTCHA reminder on 1st run
    captcha.scrollIntoView();
    if(i == 0)
    {
      BuiltIn.ShowMessage("If you have not already done so, please verify reCAPTCHA manually for "
        + "the first attempt. Verification will be cached for subsequent runs.");  
    }
  
    // PRESS CHECKOUT TO COMPLETE ORDER
    captcha.Click(25, 35);
    Common.Wait(1);
    main.Form(0).SubmitButton("submitBtn").Click();
    
    // clear cookie/cache for subsequent runs
    Common.Wait(2.5);
    if(i == 0)
    {
      clearCookies();
      Browsers.Item(btChrome).Navigate(ProjectSuite.Variables.envtURL, 2500);
    }
  }
}
