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
            , creditcard_id
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


    , product_joined as (
        select
            products.product_sk as product_fk
            , products.productmodelid
            , products.productsubcategoryid
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.specialofferid
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
            , sales_order_detail.orderqty
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount

        from {{ ref('stg_production_product') }} as product
        left join products on products.productid = sales_order_detail.productid 
    )

    , sales_creditcard_joined as (
        select
            creditcard.creditcard_sk as creditcard_fk
            , creditcard.cardtype
            , creditcard.cardnumber
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

        from {{ ref('stg_creditcard') }} as sales_creditcard
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join creditcard on sales_order_header.creditcardid = creditcard.creditcardid
    )

    , salesreason_joined as (
        select
            salesreason.salesreason_sk as salesreason_fk
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.productid
            , sales_order_detail.specialofferid
            , salesreason.reason
            , salesreason.reasontype
            , sales_order_detail.orderqty
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount

        from {{ ref('stg_salesreason') }} as salesreason
        left join sales_orderheader_salesreason on sales_order_detail.salesorderid = sales_orderheader_salesreason.salesorderid
        left join salesreason on sales_orderheader_salesreason.salesreasonid = salesreason.salesreasonid
    )

    , customer_joined as (
        select
            name_customer
            , customer.customer_sk as customer_fk
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

        from {{ ref('stg_customer') }} as customer
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join customer on sales_order_header.customerid = customer.customerid
        left join person on customer.personid = person.businessentityid
    )

    , statuscode_joined as (
        select
            sales_order_detail.salesorderdetail_sk as salesorderdetail_fk
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

        from {{ ref('stg_sales_orderheader') }} as statuscode
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
    )

    , address_joined as (
        select
            person_address.address_sk as address_fk
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
            , person_address.addressline1   
            , person_address.addressline2   
            , person_address.city
            , person_address.stateprovinceid
            , person_address.postalcode 
            , person_address.spatiallocation    

        from {{ ref('stg_person_address') }} as person_address
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join person_address on sales_order_header.shiptoaddressid = person_address.addressid
    )

    , state_province_joined as (
        select
            state_province.stateprovince_sk as stateprovince_fk           
            , state_province.stateprovincecode                  
            , state_province.countryregioncode                  
            , state_province.isonlystateprovinceflag            
            , state_province.name_stateprovince                 
            , state_province.territoryid                            
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
            , person_address.postalcode 
            , person_address.spatiallocation

        from {{ ref('stg_stateprovince') }} as state_province
        left join sales_order_header on sales_order_detail.salesorderid = sales_order_header.salesorderid
        left join person_address on sales_order_header.shiptoaddressid = person_address.addressid
        left join state_province on person_address.stateprovinceid = state_province.stateprovinceid
    )

    , total_negociado as (
        select
            product_fk
            , creditcard_fk
            , address_fk
            , salesreason_fk
            , customer_fk
            , stateprovince_fk  
            , products.productmodelid
            , products.productsubcategoryid
            , sales_order_detail.salesorderid
            , sales_order_detail.salesorderdetailid
            , sales_order_detail.specialofferid
            , sales_order_header.customerid                 
            , sales_order_header.shiptoaddressid                    
            , sales_order_header.billtoaddressid
            , sales_order_header.shipmethodid
            , person.businessentityid
            , state_province.territoryid
            , person_address.stateprovinceid
            , customer.personid
            , customer.storeid                  
            , customer.territoryid
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
            , sales_order_detail.orderqty
            , sales_order_detail.unitprice
            , sales_order_detail.unitpricediscount
            , creditcard.cardtype
            , creditcard.cardnumber 
            , sales_order_header.orderdate                  
            , sales_order_header.duedate                    
            , sales_order_header.shipdate                   
            , sales_order_header.statuscode
            , sales_order_header.subtotal
            , sales_order_header.taxamt
            , sales_order_header.freight
            , sales_order_header.totaldue               
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
            , person_address.addressline1   
            , person_address.addressline2   
            , person_address.city
            , person_address.postalcode 
            , person_address.spatiallocation                
            , state_province.stateprovincecode                  
            , state_province.countryregioncode                  
            , state_province.isonlystateprovinceflag            
            , state_province.name_stateprovince                 
            , salesreason.reason
            , salesreason.reasontype
            , name_customer
            , sum (sales_order_detail.unitprice) as total_negociado
            , avg (sales_order_detail.unitprice) as ticket_médio

        from product_joined as product
        left join sales_creditcard_joined on sales_creditcard_joined.salesorderdetailid = product_joined.salesorderdetail_fk
	    left join salesreason_joined on salesreason_joined.salesreasonid = salesreason_joined.salesreason_fk
        left join customer_joined on sales_creditcard_joined.customerid = customer_joined.customer_fk
        left join statuscode_joined on customer_joined.salesorderdetailid = statuscode_joined.salesorderdetail_fk
        left join address_joined on statuscode_joined.shiptoaddressid = address_joined.address_fk
        left join state_province_joined on address_joined.stateprovinceid = statuscode_joined.stateprovince_fk
        
    )

    select *
    from total_negociado
    

