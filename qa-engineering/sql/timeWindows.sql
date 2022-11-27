


select * FROM HourlyTimeWindows h
where 1 = 1
and h.storeid IN (SELECT sm.StoreID FROM vStoreMarket sm WHERE sm.MarketID = 3)
AND h.TimeLoadFits < 24
--and h.StoreId = 2388
--and h.PumpGradeId = 8

update HourlyTimeWindows set TimeLoadFits = 36, TimeToStockOut = 48 where TimeLoadFits < 24 and storeid IN (SELECT sm.StoreID FROM vStoreMarket sm WHERE sm.MarketID = 3)

update HourlyTimeWindows set TimeLoadFits = 0, TimeToStockOut = 1, CurrentStickReading = 900
WHERE StoreID = 2388 AND PumpGradeId = 8
