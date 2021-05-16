CREATE TABLE [sales].[ExchangeRate] (
    [CurrencyId]     INT           NOT NULL,
    [EffectiveDate]  DATE          NOT NULL,
    [BaseCurrencyId] INT           NOT NULL,
    [Rate]           REAL          NOT NULL,
    [Timestamp]      DATETIME2 (7) NOT NULL,
    [InsertedDate]   DATETIME2 (7) NOT NULL,
    CONSTRAINT [PK_ExchangeRate] PRIMARY KEY CLUSTERED ([CurrencyId] ASC, [EffectiveDate] ASC),
    FOREIGN KEY ([BaseCurrencyId]) REFERENCES [dim].[Currency] ([CurrencyId]),
    FOREIGN KEY ([CurrencyId]) REFERENCES [dim].[Currency] ([CurrencyId])
);

