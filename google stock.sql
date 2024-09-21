-- performance of google stock over time
select 
    strftime('%Y', `date`) as year,
    avg(`close`) as avg_close_price,
    sum(`volume`) as total_volume
from 
    goog
group by 
    year
order by 
    year asc;

-- volatility analysis for stock traders
select 
    `date`,
    (`high` - `low`) / `low` * 100 as price_fluctuation_percent
from 
    goog
where 
    (`high` - `low`) / `low` * 100 > 5
order by 
    price_fluctuation_percent desc;

-- dividend and stock split information
select 
    `date`, 
    `divCash`, 
    `splitFactor`
from 
    goog
where 
    `divCash` > 0 or `splitFactor` > 1
order by 
    `date` asc;

-- adjusted stock prices
select 
    `date`, 
    `adjClose` as adjusted_close_price, 
    `adjVolume` as adjusted_volume
from 
    goog
order by 
    `date` asc;

-- identify peak trading volumes
select 
    `date`, 
    `volume`
from 
    goog
where 
    `volume` = (select max(`volume`) from goog)
order by 
    `date` asc;

-- price momentum analysis
select 
    `date`, 
    avg(`close`) over (order by `date` rows between 19 preceding and current row) as `20_day_moving_avg`,
    avg(`close`) over (order by `date` rows between 49 preceding and current row) as `50_day_moving_avg`
from 
    goog
order by 
    `date` asc;

-- top performing days by price increase
select 
    `date`, 
    (`close` - `open`) / `open` * 100 as price_change_percent
from 
    goog
where 
    (`close` - `open`) / `open` * 100 > 5
order by 
    price_change_percent desc;

-- identify low trading volume days
select 
    `date`, 
    `volume`
from 
    goog
where 
    `volume` < (select avg(`volume`) from goog) * 0.5
order by 
    `volume` asc;

-- price and volume correlation analysis
select 
    `date`, 
    `close`, 
    `volume`
from 
    goog
where 
    `volume` = (select max(`volume`) from goog) or `volume` = (select min(`volume`) from goog)
order by 
    `date` asc;

-- post-split stock performance analysis
select 
    `date`, 
    `close`
from 
    goog
where 
    `splitFactor` > 1
order by 
    `date` asc;

-- moving average convergence divergence (macd)
with macd_calc as (
    select 
        `date`,
        avg(`close`) over (order by `date` rows between 11 preceding and current row) as `12_day_ema`,
        avg(`close`) over (order by `date` rows between 25 preceding and current row) as `26_day_ema`
    from 
        goog
)
select 
    `date`, 
    (`12_day_ema` - `26_day_ema`) as macd
from 
    macd_calc
order by 
    `date` asc;


