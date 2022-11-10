with source_data as (
    select 
        stateprovinceid					
        , stateprovincecode					
        , countryregioncode					
        , isonlystateprovinceflag			
        , "name" as name_stateprovince					
        , territoryid					
        , rowguid					
        , modifieddate				
    from {{ source('Source_adventure','person_stateprovince') }}
)

select *
from source_data