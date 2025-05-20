with ranking as (
    select 
        policy_num,
        state,
        claim_cost,
        fraud_score,
        percent_rank() over (
            partition by state 
            order by fraud_score
        ) as pct_rank
    from fraud_score
)

select
    policy_num,
    state,
    claim_cost,
    fraud_score
from ranking
where pct_rank >= 0.95
;
