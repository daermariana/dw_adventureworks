with source_data as (
    select
        salesorderid
        , salesreasonid
        , modifieddate
    from {{ source('Source_adventure','sales_salesorderheadersalesreason') }}
)

select *
from source_data