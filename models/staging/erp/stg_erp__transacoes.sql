with
    fonte_transacoes as (
        select *
        from {{ source('erp', 'transacoes') }}
    )
    
    , renomeado as (
        select
            cast(cod_transacao as int) as pk_transacao
            , cast(num_conta as int) as fk_conta
            , cast(cod_transacao as int) as numero_transacao
            , try_cast(data_transacao as date) as data_transacao
            , try_cast(data_transacao as timestamp) as ts_transacao
            , nome_transacao
            , try_cast(valor_transacao as numeric(28,2)) as valor_transacao
        from fonte_transacoes
    )

    , com_tipo_transacao as (
        select
            pk_transacao
            , fk_conta
            , numero_transacao
            , data_transacao
            , ts_transacao
            , nome_transacao
            , case 
                when valor_transacao > 0 then 'Crédito'
                when valor_transacao < 0 then 'Débito'
                else null 
            end as tipo_transacao
            , valor_transacao
        from renomeado
    )

select *
from com_tipo_transacao