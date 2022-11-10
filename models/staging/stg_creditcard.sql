with source_data as (
    select 
        creditcardid
        , cardtype
        , cardnumber
        , modifieddate
    from {{ source('Source_adventure','sales_creditcard') }}
)

select *
from source_data