-- A) Marketing:


-- The marketing team wants to launch some campaigns, and they need your help with the following
-- Task 1 -
-- Rewarding Most Loyal Users:
--   People who have been using the platform for the longest time.Your Task: Find the 5 oldest users of the Instagram from the database provided
SELECT
username
FROM users
ORDER BY created_at ASC
LIMIT 5 ;


-- Task 2 –
-- Remind Inactive Users to Start Posting:
-- By sending them promotional emails to post their 1st photo.
-- Your Task: Find the users who have never posted a single photo on Instagram
SELECT u.username from users u
LEFT JOIN
photos p
ON
u.id = p.user_id
where p.id is null ;



-- Task 3 –
-- Declaring Contest Winner:
--  The team started a contest and the user who gets the most likes on a
-- single photo will win the contest now they wish to declare the winner.
--       Your Task: Identify the winner of the contest and provide their details to the team


WITH result AS
(
Select
p.id as photo_id ,
p.user_id ,
count(l.photo_id) as num_likes
from photos p
left join
likes l
on p.id = l.photo_id
group by 1 ,2
order by 3 desc
)
SELECT r.* , u.username , u.created_at
from result r
join
users u
on r.user_id = u.id
where r.num_likes = ( select max(r.num_likes) from result r ) ;




-- Task 4 –
-- Hashtag Researching:
-- A partner brand wants to know, which hashtags to use in the post to reach the most people on the platform.
--  Your Task: Identify and suggest the top 5 most commonly used hashtags on the platform

Select
t.tag_name ,
count(l.user_id) as num_likes
from
tags t
left join
photo_tags pt
on
t.id=pt.tag_id
left join
likes l
on
pt.photo_id = l.photo_id
group by 1
order by 2 desc
limit 5 ;


-- Task 5 –
--   Launch AD Campaign
--  The team wants to know, which day would be the best day to launch ADs.
--   Your Task: What day of the week do most users register on? Provide insights on when to schedule an ad campaign


select
dayofweek(created_at) as day_of_week ,
dayname(created_at) as day_name ,
count(id) as new_reg
from users
group by 1 ,2;





-- B) Investor Metrics:


--  Our investors want to know if Instagram is performing well and is not becoming redundant like Facebook, they want to assess the app on the following grounds
--   Task 1 –
--    User Engagement:
--    Are users still as active and post on Instagram or they are making fewer posts

--  Your Task: Provide how many times does average user posts on Instagram.Also, provide the total number of photos on Instagram/total number of users

SELECT
COUNT(p.id)/COUNT(u.id) AS user_engagement
FROM users u
LEFT JOIN
photos p
ON
u.id = p.user_id ; 


-- Task 2 –

-- Bots & Fake Accounts:
--   The investors want to know if the platform is crowded with fake and dummy accounts
--   Your Task: Provide data on users (bots) who have liked every single photo on the site (since any normal user would not be able to do this).


WITH result AS
(
SELECT u.id ,count(user_id) as num_likes FROM users u
LEFT JOIN
likes l
ON
u.id = l.user_id
group by 1
order by 2 desc
)
SELECT
COUNT(id) as fake_acount
from result
where num_likes = (select COUNT(DISTINCT photo_id) from likes) ;














