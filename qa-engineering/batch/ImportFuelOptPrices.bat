set targetserver=SQLSRVCLDeploy.rt.corp
set targetdbasename=Allegro_FuelPurchaseOpDB_UAT
set datadir=D:\Data Refresh


osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.SymbolMappingDetail"
osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.SymbolMappingHeader"
bcp "%targetdbasename%".dbo.SymbolMappingHeader in "%datadir%\SymbolMappingHeader.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n
bcp "%targetdbasename%".dbo.SymbolMappingDetail in "%datadir%\SymbolMappingDetail.csv" -S %targetserver% -q -E -T -c -q -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.DeliveryForecastNewBuckets WHERE ForecastDateTime >= DATEADD(DAY, -10, GETDATE())"
bcp "%targetdbasename%".dbo.DeliveryForecastNewBuckets in "%datadir%\DeliveryForecastNewBuckets.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.MetroplexReplacementBasis"
osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.MetroplexReplacementCostAndTrendSettings"
bcp "%targetdbasename%".dbo.MetroplexReplacementCostAndTrendSettings in "%datadir%\MetroplexReplacementCostAndTrendSettings.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n
bcp "%targetdbasename%".dbo.MetroplexReplacementBasis in "%datadir%\MetroplexReplacementBasis.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.PriceInfo"
bcp "%targetdbasename%".dbo.PriceInfo in "%datadir%\PriceInfo.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.OPISBenchmark WHERE RackDate >= DATEADD(DAY, -10, GETDATE())"
bcp "%targetdbasename%".dbo.OPISBenchmark in "%datadir%\OPISBenchmark.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.OPISStandard WHERE DateDaily >= DATEADD(DAY, -10, GETDATE())"
bcp "%targetdbasename%".dbo.OPISStandard in "%datadir%\OPISStandard.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.OPISSupplierRackPrice WHERE RackDate >= DATEADD(DAY, -10, GETDATE())"
bcp "%targetdbasename%".dbo.OPISSupplierRackPrice in "%datadir%\OPISSupplierRackPrice.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.MetroplexTransferPrices WHERE DateTimeEffective >= DATEADD(DAY, -10, GETDATE())"
bcp "%targetdbasename%".dbo.MetroplexTransferPrices in "%datadir%\MetroplexTransferPrices.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.ForwardPriceValues"
bcp "%targetdbasename%".dbo.ForwardPriceValues in "%datadir%\ForwardPriceValues.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.ArgusPrices"
bcp "%targetdbasename%".dbo.ArgusPrices in "%datadir%\ArgusPrices.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename.ArgusPricesCategories
bcp "%targetdbasename%".dbo.ArgusPricesCategories in "%datadir%\ArgusPricesCategories.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.ArgusPricesQuotes"
bcp "%targetdbasename%".dbo.ArgusPricesQuotes in "%datadir%\ArgusPricesQuotes.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.PlattsPrices"
bcp "%targetdbasename%".dbo.PlattsPrices in "%datadir%\PlattsPrices.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"Delete from %targetdbasename%.dbo.OpisPrices"
bcp "%targetdbasename%".dbo.OpisPrices in "%datadir%\OpisPrices.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n