USE [staging];
    execute('create view "dbo"."stg_customers__dbt_tmp" as
    with source as (
    select * from "staging"."dbo"."raw_customers"

),

renamed as (

    select
        id as customer_id,
        first_name,
        last_name

    from source

)

select * from renamed
    ');

