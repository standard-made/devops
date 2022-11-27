/*******************************************************************************************************************/
/* DELETE MASTER ***************************************************************************************************/
/*******************************************************************************************************************/

/* BATCH DELETING DBAUDIT *****************************/
/******************************************************/
WHILE (1=1)
BEGIN
    DELETE TOP (10000) FROM dbaudit 
    WHERE CAST(auditdate AS DATE) < CAST(GETDATE()-1 AS DATE)
    IF @@ROWCOUNT < 1 BREAK
END


/* BATCH DELETING VALUATIONDETAIL *********************/
/******************************************************/
SELECT 'Starting' --sets @@ROWCOUNT
WHILE @@ROWCOUNT <> 0
    DELETE TOP (10000) FROM valuationdetail 
	WHERE CAST(valuetime AS DATE) < CAST(GETDATE()-1 AS DATE)


/* BATCH DELETING GRIDLOG *****************************/
/******************************************************/
WHILE (1=1)
BEGIN
    DELETE TOP (10000) FROM gridlog
    WHERE CAST(eventtime AS DATE) < CAST(GETDATE()-1 AS DATE)
    IF @@ROWCOUNT < 1 BREAK
END