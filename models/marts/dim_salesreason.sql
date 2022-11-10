with 
    salesreason as (
        select *		
        from {{ ref('stg_salesreason') }}
    )
    
    , sales_order_detail as (
        select *
        from {{ ref('stg_sales_orderdetail') }}
    )
    
    , sales_orderheader_salesreason as (
        select *
        from {{ ref('stg_sales_orderheadersalesreason') }}
    )

    , joining as (
        select
            row_number() over (order by salesreason.salesreasonid) as salesreason_sk -- auto-incremental surrogate key
            , salesreason.salesreasonid
            , salesreason.reason
            , salesreason.reasontype
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.orderqty
            , sales_order_detail.productid
            , sales_order_detail.specialofferid
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount

        from sales_order_detail
        left join sales_orderheader_salesreason on sales_order_detail.salesorderid = sales_orderheader_salesreason.salesorderid
        left join salesreason on sales_orderheader_salesreason.salesreasonid = salesreason.salesreasonid
    )

select *
from joining