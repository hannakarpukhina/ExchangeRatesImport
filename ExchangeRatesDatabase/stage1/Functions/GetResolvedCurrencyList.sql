CREATE FUNCTION stage1.GetResolvedCurrencyList ( @ExecutionId BIGINT)

RETURNS TABLE

AS 
RETURN

WITH LastIdentity
AS (
	SELECT DISTINCT
			CAST([key] AS CHAR(3)) COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency
		,ExecutionID
		,CAST(DATEADD(S, CAST(JSON_VALUE(FileBody, '$.timestamp') AS BIGINT), '1970-01-01') AS DATE) AS [timestamp]
		,ROW_NUMBER() OVER( 
								PARTITION BY CAST([key] AS CHAR(3)) 
								ORDER BY JSON_VALUE(FileBody, '$.timestamp')) AS Latesttimestamp
	FROM stage1.exchangeratesapi 
		CROSS APPLY OPENJSON(JSON_QUERY(filebody,'$.rates'))
	WHERE ExecutionId = @ExecutionId
)
SELECT 
	 dim.CurrencyId
	,c.Currency AS CurrencyCodeISO3
	,c.ExecutionID
	,c.[timestamp]
FROM LastIdentity AS c
	INNER JOIN dim.Currency AS dim ON dim.CurrencyCodeISO3 = c.Currency
WHERE Latesttimestamp = 1
UNION ALL
SELECT 
	 ROW_NUMBER() OVER(ORDER BY c.Currency) + (SELECT IDENT_CURRENT('dim.Currency') - 1) AS IdentityId
	,c.Currency AS CurrencyCodeISO3
	,c.ExecutionID
	,c.[timestamp]
FROM LastIdentity AS c
	LEFT OUTER JOIN dim.Currency AS dim ON dim.CurrencyCodeISO3 = c.Currency
WHERE dim.CurrencyId IS NULL
	AND Latesttimestamp = 1 