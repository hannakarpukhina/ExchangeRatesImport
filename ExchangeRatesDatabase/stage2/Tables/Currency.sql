CREATE TABLE [stage2].[Currency] (
    [CurrencyId]       INT            NULL,
    [CurrencyCodeISO3] CHAR (3)       NULL,
    [CurrencyCodeISO2] CHAR (2)       NULL,
    [StartDate]        DATETIME2 (7)  NULL,
    [CountryName]      VARCHAR (1000) NULL,
    [ExecutionId]      BIGINT         NULL
);

