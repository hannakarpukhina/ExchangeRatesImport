CREATE TABLE [stage2].[ExchangeRate] (
    [CurrencyId]     INT           NULL,
    [EffectiveDate]  DATE          NULL,
    [BaseCurrencyId] INT           NULL,
    [Rate]           REAL          NULL,
    [Timestamp]      DATETIME2 (7) NULL,
    [InsertedDate]   DATETIME2 (7) NULL,
    [ExecutionId]    BIGINT        NULL
);

