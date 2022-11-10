/*consta erro no "address": Unexpected string literal "address" at [62:19]*/

with 
    sales_order_detail as (
        select *		
        from {{ ref('stg_sales_orderdetail') }}
    )
    
    , sales_order_header as (
        select *
        from {{ ref('stg_sales_orderheader') }}
    )

    , person_address as (
        select *
        from {{ ref('stg_person_address') }}
    )
    
    , joining as (
        select
            row_number() over (order by person_address.addressid) as address_sk -- auto-incremental surrogate key
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.orderqty
            , sales_order_detail.productid
            , sales_order_detail.specialofferid
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount
            , sales_order_header.customerid					
            , sales_order_header.shiptoaddressid					
            , sales_order_header.billtoaddressid
            , sales_order_header.shipmethodid		
            , sales_order_header.orderdate					
            , sales_order_header.duedate					
            , sales_order_header.shipdate					
            , sales_order_header.statuscode
            , sales_order_header.subtotal
            , sales_order_header.taxamt
            , sales_order_header.freight
            , sales_order_header.totaldue
            , person_address.addressid		
            , person_address.addressline1	
            , person_address.addressline2	
            , person_address.city
            , person_address.stateprovinceid
            , person_address.postalcode	
            , person_address.spatiallocation	

        from sales_order_detail
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join person_address on sales_order_header.shiptoaddressid = person_address.addressid
    )

select *
from joining