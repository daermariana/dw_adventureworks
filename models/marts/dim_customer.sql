with 
    customer as (
        select *		
        from {{ ref('stg_customer') }}
    )
    
    , sales_order_detail as (
        select *
        from {{ ref('stg_sales_orderdetail') }}
    )
    
    , sales_order_header as (
        select *
        from {{ ref('stg_sales_orderheader') }}
    )

    , person as (
        select *
        from {{ ref('stg_person') }}
    )

    , joining as (
        select
            row_number() over (order by customer.customerid) as customer_sk -- auto-incremental surrogate key
            , concat(person.firstname,' ',person.middlename,' ',person.lastname) as name_customer
            , customer.customerid
            , customer.personid
            , customer.storeid					
            , customer.territoryid	
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.orderqty
            , sales_order_detail.productid
            , sales_order_detail.specialofferid
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount				
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
            , person.businessentityid					
            , person.persontype					
            , person.namestyle					
            , person.title					
            , person.firstname					
            , person.middlename					
            , person.lastname					
            , person.suffix					
            , person.emailpromotion					
            , person.additionalcontactinfo					
            , person.demographics

        from sales_order_detail
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join customer on sales_order_header.customerid = customer.customerid
        left join person on customer.personid = person.businessentityid
    )

select *
from joining