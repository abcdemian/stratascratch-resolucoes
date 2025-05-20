with host_popularity as (
    select 
        id,
        number_of_reviews,
        price,
        case
            when number_of_reviews = 0
                then 'New'
            when number_of_reviews >= 1
            and number_of_reviews <= 5
                then 'Rising'
            when number_of_reviews >= 6
            and number_of_reviews <= 15
                then 'Trending Up'
            when number_of_reviews >= 16
            and number_of_reviews <= 40
                then 'Popular'
            when number_of_reviews > 40
                then 'Hot'
        end as host_popularity
    from airbnb_host_searches
),

summaries as (
    select
        host_popularity,
        min(price) as min_price,
        avg(price) as avg_price,
        max(price) as max_price
    from host_popularity
    group by 1 
)

select * 
from summaries 
order by 2;
