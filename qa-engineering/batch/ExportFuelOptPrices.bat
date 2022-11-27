set datadir=D:\Data Refresh

bcp "SELECT * FROM FuelPurchaseOpDb.dbo.SymbolMappingHeader" queryout "%datadir%\SymbolMappingHeader.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.SymbolMappingDetail WHERE SymbolMappingHeader_Id IN (SELECT Id FROM FuelPurchaseOpDb.dbo.SymbolMappingHeader WHERE Active = 1)" queryout "%datadir%\SymbolMappingDetail.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.DeliveryForecastNewBuckets WHERE ForecastDateTime >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\DeliveryForecastNewBuckets.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.MetroplexReplacementCostAndTrendSettings" queryout "%datadir%\MetroplexReplacementCostAndTrendSettings.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.MetroplexReplacementBasis" queryout "%datadir%\MetroplexReplacementBasis.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.PriceInfo" queryout "%datadir%\PriceInfo.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.OPISBenchmark WHERE RackDate >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\OPISBenchmark.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.OPISStandard WHERE DateDaily >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\OPISStandard.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.OPISSupplierRackPrice WHERE RackDate >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\OPISSupplierRackPrice.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.MetroplexTransferPrices WHERE DateTimeEffective >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\MetroplexTransferPrices.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.ForwardPriceValues WHERE TradeDate >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\ForwardPriceValues.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.ArgusPrices WHERE Date >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\ArgusPrices.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.ArgusPricesCategories" queryout "%datadir%\ArgusPricesCategories.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.ArgusPricesQuotes" queryout "%datadir%\ArgusPricesQuotes.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.PlattsPrices WHERE PriceDate >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\PlattsPrices.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM FuelPurchaseOpDb.dbo.OpisPrices WHERE PriceDate >= DATEADD(DAY, -10, GETDATE())" queryout "%datadir%\OpisPrices.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n