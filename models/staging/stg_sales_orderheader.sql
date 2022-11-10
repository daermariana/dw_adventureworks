with source_data as (
    select
        salesorderid
        , customerid					
        , shiptoaddressid					
        , billtoaddressid
        , "shipmethod" as shipmethodid
        , creditcardid		
        , orderdate					
        , duedate					
        , shipdate					
        , "status" as statuscode
        , onlineorderflag
        , purchaseordernumber
        , subtotal
        , taxamt
        , freight
        , totaldue
        , rowguid
        , modifieddate 
    from {{ source('Source_adventure','sales_salesorderheader') }}
)

select *
from source_data