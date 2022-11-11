with 
    sales_order_detail as (
        select *		
        from {{ ref('stg_sales_orderdetail') }}
    )
    
    , sales_order_header as (
        select *
        from {{ ref('stg_sales_orderheader') }}
    )
    
    , joining as (
        select
            row_number() over (order by sales_order_detail.salesorderid) as salesorderdetail_sk -- auto-incremental surrogate key
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

        from sales_order_detail
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
    )

select *
from joining
