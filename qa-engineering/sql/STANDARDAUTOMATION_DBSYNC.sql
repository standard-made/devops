USE [StandardAutomation]
GO

ALTER TABLE cmedealsides ADD uomqty DECIMAL(16,4) NULL
GO
ALTER TABLE dbo.cmedealsides DROP CONSTRAINT pk_cmedealsides
GO
ALTER TABLE dbo.cmedealsides 
	ADD CONSTRAINT pk_cmedealsides 
	PRIMARY KEY (cmedealid, exchangedealid, tradereportid)
GO
ALTER TABLE viewname ADD FOREIGN KEY (viewgroup)
	REFERENCES viewgroup (viewgroup)
GO
IF EXISTS 
	(SELECT * FROM shipment WHERE shipmentstatus = '')
UPDATE shipment SET shipmentstatus = NULL
	WHERE shipmentstatus = ''
GO
ALTER TABLE shipment ADD CONSTRAINT ck_shipmentstatus 
	CHECK (shipmentstatus IN('INTANKTRANSFER','INTRANSITNOTTITLED'))
GO
ALTER TABLE shipment ADD CONSTRAINT ck_shipmenttype 
	CHECK (shipmenttype IN ('BOOKOUT','DISTRIBUTION','FOB','FRACTIONATION','PHYSICAL','PROCESS','TRANSFER'))
GO