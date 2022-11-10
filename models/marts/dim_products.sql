with 
    products as (
        select *		
        from {{ ref('stg_production_product') }}
    )

    , sales_order_detail as (
        select *
        from {{ ref('stg_sales_orderdetail') }}
    )

    , joining as (
        select
            row_number() over (order by products.productid) as product_sk -- auto-incremental surrogate key
            , products.productid
            , products.productmodelid
            , products.productsubcategoryid
            , products.name_product
            , products.productnumber
            , products.safetystocklevel
            , products.reorderpoint
            , products.standardcost	
            , products.listprice
            , products.daystomanufacture
            , products.class
            , products.sellstartdate
            , products.sellenddate
            , products.discontinueddate
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.specialofferid
            , sales_order_detail.orderqty
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount
			
        from sales_order_detail 
        left join products on products.productid = sales_order_detail.productid 
    )

select *
from joining