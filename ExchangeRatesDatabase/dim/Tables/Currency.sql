CREATE TABLE [dim].[Currency] (
    [CurrencyId]       INT            IDENTITY (1, 1) NOT NULL,
    [CurrencyCodeISO3] CHAR (3)       NOT NULL,
    [CurrencyCodeISO2] CHAR (2)       NULL,
    [StartDate]        DATETIME2 (7)  NOT NULL,
    [CountryName]      VARCHAR (1000) NULL,
    CONSTRAINT [PR_Currency] PRIMARY KEY CLUSTERED ([CurrencyId] ASC)
);

