with
    intervalo_de_datas as (
        {{ 
            dbt_utils.date_spine(
                datepart="day",
                start_date="cast('2010-01-01' as date)",
                end_date="cast('2023-12-31' as date)"
            )
        }}
    )

    , criar_colunas as (
        select
            row_number() over(order by date_day asc) as pk_data
            , cast(date_day as date) as data_completa
            , extract(year from date_day) as ano
            , extract(month from date_day) as mes
            , extract(day from date_day) as dia
            , extract(quarter from date_day) as trimestre
            , dayofweek(date_day) as dia_da_semana
            , case 
                when dayofweek(date_day) in (1, 7) then true
                else false
            end as is_weekend
        from intervalo_de_datas
    )

select *
from criar_colunas