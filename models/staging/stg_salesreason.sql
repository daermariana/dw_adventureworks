with source_data as (
    select 
        salesreasonid
        , "name" as reason
        , reasontype
        , modifieddate
    from {{ source('Source_adventure','sales_salesreason') }}
)

select *
from source_data