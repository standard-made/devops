set datadir=D:\Data Refresh

rem freight invoices
bcp "SELECT * FROM Staging.dbo.Freight_Invoice_Header WHERE LastUpdated >= CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101)" queryout "%datadir%\Freight_Invoice_Header.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM Staging.dbo.Freight_Invoice_Detail WHERE RTControlNum IN (SELECT RTControlNum FROM Staging.dbo.Freight_Invoice_Header WHERE LastUpdated >= CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101))" queryout "%datadir%\Freight_Invoice_Detail.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM Staging.dbo.Freight_Invoice_Location WHERE RTControlNum IN (SELECT RTControlNum FROM Staging.dbo.Freight_Invoice_Header WHERE LastUpdated >= CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101))" queryout "%datadir%\Freight_Invoice_Location.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n
bcp "SELECT * FROM Staging.dbo.Freight_Invoice_Stores WHERE RTControlNum IN (SELECT RTControlNum FROM Staging.dbo.Freight_Invoice_Header WHERE LastUpdated >= CONVERT(VARCHAR(10),DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101))" queryout "%datadir%\Freight_Invoice_Stores.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n

rem fuel deliveries
bcp "SELECT * FROM Staging.dbo.tbl_FuelAdmin_FlatDTNImport WHERE StartLoadDate >= CONVERT(DATE,DATEADD(m,-1,DATEADD(mm, DATEDIFF(m,0,GETDATE()), 0)), 101)" queryout "%datadir%\Fuel_Deliveries.csv" -Sfuelsqlsrvcl.rt.corp -T -c -k -t~ -r\n