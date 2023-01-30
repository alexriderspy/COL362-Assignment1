with a as (select distinct playerid, playername from people where deathday is null and deathyear is null and deathmonth is null),
b as (select distinct playerid, playername from people where deathday is not null or deathyear is not null or deathmonth is not null)
select distinct playerid, playername, false as alive from people left outer join (awardsplayers union awardsmanagers) where awardid is null join a on a.playerid = people.playerid
union
select distinct playerid, playername, true as alive from people left outer join (awardsplayers union awardsmanagers) where awardid is null join b on b.playerid = people.playerid
;