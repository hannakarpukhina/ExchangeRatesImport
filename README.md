# ExchangeRatesImport
ETL process to download exchange rates figures from [_exchangeratesapi.io_](https://exchangeratesapi.io/documentation/) and ingest them into SQL Server database.
![SSIS_run](https://user-images.githubusercontent.com/83240320/119403063-b4a99280-bcd5-11eb-8a06-1f7e6626fcf6.gif)

## Database
<img width="527" alt="DataBaseSchema" src="https://user-images.githubusercontent.com/83240320/119405701-96459600-bcd9-11eb-9ec5-38c45e2ebb27.PNG">

To create required database structure deploy project _ExchangeRatesDatabase_.

## ETL
* To use the database created above specify coresponding db path in _DW_ connection manager.
* To enable data import specify your api key in __APIKey__ parameter of _Stage1ExtractExchangeRates.dtsx_ package.

Entry point - _Main.dtsx_.

### Main
Generates ExecutionId value and executes all the packages.

ExecutionId - ETL run instance identifier. It contains current date by default, can be overeaden by @[$Package::ExecutionId]
```
@[User::ExecutionId] = @[$Package::ExecutionId] != 0? @[$Package::ExecutionId]  : -1 * (DT_I8) REPLACE(REPLACE(REPLACE(REPLACE(SUBSTRING((DT_WSTR, 30)GETDATE() ,1,21),"-","")," ",""),":",""),".","")
```
<img width="280" alt="Main" src="https://user-images.githubusercontent.com/83240320/119407706-824f6380-bcdc-11eb-8406-b77bef5edb23.PNG">

### Stage1ExtractExchangeRates
Downloads JSON file from exchangeratesapi.io, parses it and inserts the data into stage1 table. 
* APIKey - your exchangeratesapi.io key.
* AsOfDate - exchange rate effective date. Default value is 'latest'. To override specify needed date in 'YYYY-MM-DD' format.
<img width="200" alt="Stage1ExtractExchaneRates" src="https://user-images.githubusercontent.com/83240320/119408352-76b06c80-bcdd-11eb-9e0a-487d6a41d93c.PNG">

### Stage2TransformExchangeRates
Normalization data from JSON format and insert one into stage2 tables.

<img width="201" alt="Stage1ExtractExchangeRatesDataFlow" src="https://user-images.githubusercontent.com/83240320/119410262-7a91be00-bce0-11eb-8a28-704c419030ca.PNG">

### Stage3LoadExchangeRate
Inserts transformed data into target tables.
<img width="329" alt="Stage3LoadExchangeRates" src="https://user-images.githubusercontent.com/83240320/119411726-c6456700-bce2-11eb-86da-6e89507be996.PNG">

### ClearStaging
Cleans old data from stage1 and stage2.
<img width="149" alt="ClearStaging" src="https://user-images.githubusercontent.com/83240320/119411901-102e4d00-bce3-11eb-965d-a60e65868c37.PNG">



