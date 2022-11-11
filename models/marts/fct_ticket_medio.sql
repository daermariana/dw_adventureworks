with 
    products as (
        select
            product_sk
            , productid
        from {{ ref('dim_products') }}
    )

    , orderdetail_joined as (
        select
            orderdetail.salesorderdetailid
            , products.product_sk as product_fk
            , orderdetail.orderqty
            , orderdetail.specialofferid
            , orderdetail.unitprice
            , orderdetail.unitpricediscount
            , orderdetail.rowguid
            , orderdetail.modifieddate
        from {{ ref('stg_sales_orderdetail') }} as orderdetail
        left join products on orderdetail.productid = products.productid
    )

    select * 
    from orderdetail_joined
