USE [StoreHierarchy]
GO

	BEGIN 
		SET NOCOUNT ON; 
		BEGIN TRANSACTION [Tran]
		BEGIN TRY

			IF(OBJECT_ID('tempdb..#amenities') IS NOT NULL)
			BEGIN
				DROP TABLE #amenities
			END

			IF(OBJECT_ID('tempdb..#fuelPumpTypes') IS NOT NULL)
			BEGIN
				DROP TABLE #fuelPumpTypes
			END

			IF(OBJECT_ID('tempdb..#timeZones') IS NOT NULL)
			BEGIN
				DROP TABLE #timeZones
			END

			CREATE TABLE #amenities
			(
				[StoreName] VARCHAR(250) NULL,
				[StoreNo] INT NULL,
				[FoodProgram] BIT NULL,
				[SwirlWorld] BIT NULL,
				[E85] BIT NULL,
				[E0] BIT NULL,
				[WiFi] BIT NULL,
				[Seating] BIT NULL,
				[Open] BIT NULL
			)

			CREATE TABLE #fuelPumpTypes
			(
				StationNumber INT NOT NULL,
				PumpGradeId INT NOT NULL
			)

			INSERT INTO [#amenities](StoreName, StoreNo, FoodProgram, SwirlWorld, WiFi, Seating, [Open])
			EXEC [SAPDW1].[RadiantReporting].[dbo].[spGetAmenitiesAndStoreStatus]

			DECLARE @CurrentStoreNo INT, @E85 BIT, @E0 BIT

			SELECT @CurrentStoreNo = MIN(s.StoreNum)
			FROM [dbo].[Stores] s
			WHERE
				1 = 1
				AND s.StoreNum <> 9910

			INSERT INTO #fuelPumpTypes(StationNumber, PumpGradeId)
			SELECT StationNumber, PumpGradeId
			FROM [FOPSCNDEPCL].[FuelPurchaseOpDb].[dbo].[vStationPumpGradeInformations] v (NOLOCK)
			WHERE
				1 = 1
				AND (v.Deactivated IS NULL OR v.Deactivated <> 1)

			-- Store Time Zones
			SELECT
				s.Site_ID
				, s.Site_TimeZone_ID
			INTO #timeZones
			FROM [PDI_DB1].PDICompany_218_01.dbo.Sites s

			WHILE (@CurrentStoreNo IS NOT NULL)
			BEGIN
				IF((SELECT TOP 1 t.StationNumber FROM #fuelPumpTypes t WHERE t.StationNumber = @CurrentStoreNo) IS NOT NULL)
				BEGIN
					SELECT @E0 = CASE WHEN (SELECT TOP 1 t.StationNumber FROM #fuelPumpTypes t WHERE t.StationNumber = @CurrentStoreNo AND t.PumpGradeId = 7) IS NOT NULL THEN 1 ELSE 0 END;
					SELECT @E85 = CASE WHEN (SELECT TOP 1 t.StationNumber FROM #fuelPumpTypes t WHERE t.StationNumber = @CurrentStoreNo AND t.PumpGradeId = 8) IS NOT NULL THEN 1 ELSE 0 END;
				END
				ELSE
				BEGIN
					SELECT @E85 = 0,
						   @E0 = 0
				END

				IF ((SELECT COUNT(si.StoreNumber) FROM [dbo].[StoreInfo] si WITH (NOLOCK) WHERE si.StoreNumber = @CurrentStoreNo) > 0)
				BEGIN
					UPDATE [dbo].[StoreInfo]  
					SET 
						StoreNumber = a.StoreNo,
						StoreName = a.StoreName,
						Address1 = s.Address1,
						Address2 = s.Address2,
						City = s.City,
						State = s.State,
						ZipCode = s.ZipCode,
						TimeZone = tz.Site_TimeZone_ID,
						Latitude = s.Latitude,
						Longitude = s.Longitude,
						E85 = @E85,
						E0 = @E0,
						WiFi = a.Wifi,
						IndoorSeating = a.Seating,
						OutdoorSeating = a.Seating,
						SwirlWorld = a.SwirlWorld,
						FoodProgram = CAST(a.FoodProgram AS VARCHAR(1)),
						IsStoreOpen = CAST(CASE WHEN s.Active = 1 AND a.[Open] = 1 THEN 1 ELSE 0 END AS BIT)
					FROM
					(SELECT TOP 1 * FROM dbo.Stores s2 WHERE s2.StoreNum = @CurrentStoreNo ORDER BY s2.Active DESC, s2.LastModOn DESC) s
					JOIN [#amenities] a ON s.StoreNum = a.StoreNo
					JOIN #timeZones tz ON tz.Site_ID = s.StoreNum
					WHERE
						1 = 1
						AND s.StoreNum = @CurrentStoreNo
						AND StoreNumber = @CurrentStoreNo
						AND a.StoreNo = @CurrentStoreNo
				END
				ELSE
				BEGIN
					INSERT INTO [dbo].[StoreInfo] 
					(
						StoreNumber, 
						StoreName, 
						Address1, 
						Address2, 
						City, 
						State, 
						ZipCode,
						TimeZone,
						Latitude, 
						Longitude, 
						FoodProgram, 
						SwirlWorld, 
						IndoorSeating, 
						OutdoorSeating, 
						E85, 
						E0, 
						WiFi, 
						IsStoreOpen
					)
					SELECT 
						a.StoreNo, 
						a.StoreName, 
						Address1, 
						Address2, 
						City, 
						State, 
						ZipCode,
						tz.Site_TimeZone_ID,
						Latitude, 
						Longitude, 
						CAST(a.FoodProgram AS VARCHAR(1)),
						a.SwirlWorld, 
						a.Seating, 
						a.Seating, 
						@E85, 
						@E0, 
						a.WiFi, 
						a.[Open]
					FROM [dbo].[Stores] s
					JOIN [#amenities] a ON s.StoreNum = a.StoreNo
					JOIN #timeZones tz ON tz.Site_ID = s.StoreNum
					WHERE
						1 = 1
						AND StoreNum = @CurrentStoreNo
						AND StoreNo = @CurrentStoreNo
						AND s.Active = 1
				END

				SELECT @CurrentStoreNo = MIN(s.StoreNum)
				FROM [dbo].[Stores] s
				WHERE
					1 = 1
					AND s.StoreNum > @CurrentStoreNo
					AND s.StoreNum <> 9910
			END
			COMMIT TRANSACTION [Tran]
			SELECT @@ROWCOUNT;
		END TRY
		BEGIN CATCH
			ROLLBACK TRANSACTION [Tran];
			DECLARE @ErrorMessage NVARCHAR(4000);
			DECLARE @ErrorSeverity INT;
			DECLARE @ErrorState INT;

			SELECT @ErrorMessage = ERROR_MESSAGE(),
				   @ErrorSeverity = ERROR_SEVERITY(),
				   @ErrorState = ERROR_STATE();

			RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
		END CATCH  
	END