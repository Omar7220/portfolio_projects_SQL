--number of distinct clusbs in the dataset

select  distinct count (club) as number_of_clubs_in_dataset from details_player_info 

------------------------------
DELETE FROM details_player_info
WHERE foot IS NULL;
------------------------------

--number of players that has (right , left) foot 

select count(foot) as number_of_players , foot from details_player_info
group by foot

------------------------------
DELETE FROM details_player_info
WHERE player_agent IS NULL;
------------------------------

--the best player_agent 

select player_agent , count(player_agent) as number_of_playes from details_player_info 
where max_price > ( select  avg(max_price) from details_player_info )
group by player_agent 
order by count(player_agent) desc

--the league that has playesrs with the highest price

select league , sum(max_price) as max_price
from details_player_info
group by league 
order by  sum(max_price) desc
 
-- the player's shirt number that has the most price 

select shirt_nr , sum(max_price) as max_price from details_player_info
group by shirt_nr
order by sum(max_price) desc


--the precentage of the players that >> 30 years

SELECT
  CONCAT( round( (COUNT(CASE WHEN age > 30 THEN 1 END) * 100.0 / COUNT(*)) , 3 ) , '%' )AS percentage_of_players
FROM
    details_player_info;


-- the contract expiration dates after 1/1/2026
select CONCAT(name,full_name) ,contract_expires  
from details_player_info 
where contract_expires > '1/1/2026'




---Remove the null columns 
--ALTER TABLE personal_info
--DROP COLUMN F10 , F11 ,F12,F13,F14,F15


--join the two tables 
select * 
from personal_info pr_info
join details_player_info pd
  on pr_info.name = pd.name 
  and pr_info.age = pd.age



select place_of_birth , club 
from personal_info pr_info
join details_player_info pd
  on pr_info.name = pd.name 
  and pr_info.age = pd.age


create view club_birth as 
select place_of_birth , club 
from personal_info pr_info
join details_player_info pd
  on pr_info.name = pd.name 
  and pr_info.age = pd.age

