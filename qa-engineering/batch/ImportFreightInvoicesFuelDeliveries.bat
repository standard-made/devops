set targetserver=SQLSRVCLDeploy.rt.corp
set targetdbasename=Allegro_Staging_UAT
set datadir=D:\Data Refresh

rem freight invoices
osql -S%targetserver% -d%targetdbasename% -E -Q"DELETE FROM %targetdbasename%.dbo.Freight_Invoice_Header"
bcp "%targetdbasename%".dbo.Freight_Invoice_Header in "%datadir%\Freight_Invoice_Header.csv" -S %targetserver% -q -E -T -c -q -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"TRUNCATE TABLE %targetdbasename%.dbo.Freight_Invoice_Detail"
bcp "%targetdbasename%".dbo.Freight_Invoice_Detail in "%datadir%\Freight_Invoice_Detail.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"TRUNCATE TABLE %targetdbasename%.dbo.Freight_Invoice_Location"
bcp "%targetdbasename%".dbo.Freight_Invoice_Location in "%datadir%\Freight_Invoice_Location.csv" -S %targetserver% -T -q -E -T -c -k -t~ -r\n

osql -S%targetserver% -d%targetdbasename% -E -Q"TRUNCATE TABLE %targetdbasename%.dbo.Freight_Invoice_Stores"
bcp "%targetdbasename%".dbo.Freight_Invoice_Stores in "%datadir%\Freight_Invoice_Stores.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n

rem fuel deliveries
osql -S%targetserver% -d%targetdbasename% -E -Q"TRUNCATE TABLE %targetdbasename%.dbo.tbl_FuelAdmin_FlatDTNImport"
bcp "%targetdbasename%".dbo.tbl_FuelAdmin_FlatDTNImport in "%datadir%\Fuel_Deliveries.csv" -S %targetserver% -q -E -T -c -k -t~ -r\n