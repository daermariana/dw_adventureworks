with source_data as (
    select
        salesorderid
        , salesorderdetailid
        , orderqty
        , productid
        , specialofferid
        , unitprice
        , unitpricediscount
        , rowguid
        , modifieddate	
    from {{ source('Source_adventure','sales_salesorderdetail') }}
)

select *
from source_data