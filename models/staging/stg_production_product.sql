with source_data as (
    select
        productid
        , productsubcategoryid
        , productmodelid
        , "name" as name_product
        , productnumber
        , safetystocklevel
        , reorderpoint
        , standardcost					
        , listprice
        , daystomanufacture
        , class
        , sellstartdate
        , sellenddate
        , discontinueddate
        , rowguid					
        , modifieddate
    from {{ source('Source_adventure','production_product') }}
)

select *
from source_data