with 
    city as (
        select
            address_sk
            , addressid
        from {{ ref('dim_city') }}
    )

    , creditcard as (
        select
            creditcard_sk
            , creditcardid
        from {{ ref('dim_creditcard') }}
    )

    , customer as (
        select
            customer_sk
            , customerid
        from {{ ref('dim_customer') }}
    )

    , orderdate as (
        select
            salesorder_sk
            , salesorderid
        from {{ ref('dim_orderdate') }}
    )

    , products as (
        select
            product_sk
            , productid
        from {{ ref('dim_products') }}
    )

    , salesreason as (
        select
            salesreason_sk
            , salesreasonid
        from {{ ref('dim_salesreason') }}
    )

    , stateprovince as (
        select
            stateprovince_sk
            , stateprovinceid
        from {{ ref('dim_state') }}
    )

    , statuscode as (
        select
            salesorderdetail_sk
            , salesorderid
        from {{ ref('dim_status') }}
    )


    , orders as (
        select
            orders.salesorderid
            , orders.salesorderdetailid
            , orders.orderqty
            , products.product_sk as product_fk
            , orders.specialofferid
            , orders.unitprice
            , orders.unitpricediscount
            , orders.rowguid
            , orders.modifieddate
            from {{ ref('stg_sales_orderdetail') }} as orders
            left join products on orders.productid = products.productid
            
    )

    select *
    from orders
    

