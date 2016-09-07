use FauxMeter
go
set transaction isolation level read uncommitted
go
set deadlock_priority low
go

-- select top 10 * from dbo.MeterReadings order by LoadDate  desc

-- select count(*) from dbo.MeterReadings where LoadDate > '2016-08-28 14:38:00.6200000'
select 
* 
-- count(*) 
from dbo.MeterReadings where LoadDate > cast(getdate() as date) 

--select top (200) * from dbo.MeterReadings where LoadDate > '2016-08-28 14:38:00.6200000'
-- delete from dbo.MeterReadings
-- delete from dbo.MeterReadings where LoadDate > cast(getdate() as date)

-- truncate table dbo.MeterReadings


/*
12:16 - 3:29
9:16 - 0:29
8:47 
select 8*60+47

select 9721955/ 527.0

*/