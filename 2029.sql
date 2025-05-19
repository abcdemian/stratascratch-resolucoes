with events_by_user as (
    select 
        user_id,
        event_type, -- or event_id
        count(id) as qty,
        sum(count(id)) over (partition by user_id) as qty_total_events,
        round(count(id) / sum(count(id)) over (partition by user_id), 2) as pct
    from fact_events
    group by user_id, event_type
),

user_pool as (
    select
        user_id,
        sum(
            case 
                when event_type in (
                    'video call received', 
                    'video call sent', 
                    'voice call received', 
                    'voice call sent'
                    )
                    then pct
                else 0
            end
            ) as sum_pct_events_from_list
    from events_by_user
    group by 1
    having sum_pct_events_from_list >= 0.50
),

solution as (
    select
        fact_events.client_id,
        count(user_pool.user_id) as user_count
    from fact_events
    inner join user_pool
        on fact_events.user_id = user_pool.user_id
    order by 2 desc
    limit 1 
)

select client_id from solution;