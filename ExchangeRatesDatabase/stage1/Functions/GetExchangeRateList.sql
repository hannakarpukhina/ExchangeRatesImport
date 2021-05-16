CREATE FUNCTION stage1.GetExchangeRateList ( @ExecutionId BIGINT)

RETURNS TABLE

AS 
RETURN

SELECT 
	 [timestamp]
	,[base]
	,[date]
	,[Currency]
	,[Rate]
	,[ExecutionID]
FROM (
		SELECT 
			 CAST(DATEADD(S, CAST(JSON_VALUE(FileBody, '$.timestamp') AS BIGINT), '1970-01-01') AS DATETIME2) AS [timestamp]
			,CAST(JSON_VALUE(FileBody, '$.base') AS CHAR(3)) AS base
			,CAST(JSON_VALUE(FileBody, '$.date') AS DATE) AS [date]
			,CAST([key] AS CHAR(3)) COLLATE SQL_Latin1_General_CP1_CI_AS AS Currency 
			,CAST([Value] AS REAL) AS Rate
			,[ExecutionID]
			,ROW_NUMBER() OVER( 
								PARTITION BY CAST(JSON_VALUE(FileBody, '$.date') AS DATE), CAST([key] AS CHAR(3)) 
								ORDER BY JSON_VALUE(FileBody, '$.timestamp') DESC) AS LatestRate
		FROM stage1.exchangeratesapi
			CROSS APPLY OPENJSON(JSON_QUERY(filebody,'$.rates'))
		WHERE [ExecutionId] = @ExecutionId
	) AS exchangeratesapi
WHERE LatestRate = 1