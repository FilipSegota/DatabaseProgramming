--FILIP SEGOTA MultipleSQLHomework

--PART1
--1.Find the names of sailors who have reserved boat number 103.
select distinct s.sid, s.sname
from sailors s, reserves r
where s.sid = r.sid and r.bid = 103
order by sid;

--2.Find the sids of sailors who have reserved a red boat.
select distinct s.sid
from sailors s, reserves r, boats b
where s.sid = r.sid and r.bid = b.bid and b.color = 'red'
order by sid;

--3.Find the names of sailors who have reserved a red boat.
select distinct s.sid, s.sname
from sailors s, reserves r, boats b
where s.sid = r.sid and r.bid = b.bid and b.color = 'red'
order by sid;

--4.Find the colors of boats reserved by Lubber.
select b.color
from sailors s, reserves r, boats b
where b.bid = r.bid and r.sid = s.sid and s.sname = 'Lubber';

--5.Find the names of sailors who have reserved at least one boat.
select distinct s.sid, s.sname
from sailors s, reserves r
where s.sid = r.sid
order by sid;

--6.Find the ages of sailors whose name begins and ends with B
--and has at least three characters.
select age
from sailors
where sname like 'B_%b';

--7.Find the names of sailors who have reserved a red or a green boat.
select distinct s.sid, s.sname
from sailors s, reserves r, boats b
where s.sid = r.sid and r.bid = b.bid and (b.color = 'red' or b.color='green')
order by sid;

--8.Find the names of sailors who have reserved both a red and a green boat.
select distinct s.sid, s.sname
from sailors s, reserves r, boats b
where s.sid = r.sid and r.bid = b.bid and b.color in ('red', 'green')
group by s.sid, s.sname
having count(distinct b.color) = 2
order by sid;

--9.Find the sids of all sailors who have reserved red boats but not green
--boats.
--This cannot be done with a join. Extra credit if you can explain why.
--(Don't give an sql for this -> skip if you are not doing extra credit)

--If sailor reserved any red boat, that will count him in, becuase
--without nested queries, we can't get right *group* of results
--used in 'in' clause. We can put 'not in('green')' but that will
--exclude him only once, if he reserved any other boats, that will
--automatically count him in and we don't want that

--10.Find all sids of sailors who have a rating of 10 or reserved boat 104.
select distinct s.sid
from sailors s, reserves r
where (s.sid = r.sid and r.bid = 104) or s.rating = 10
order by sid;

--PART2
--1.Find the names of sailors who have reserved boat 103.
select distinct sid, sname
from sailors s
where sid in (select sid
                from reserves
                where bid = 103)
order by sid;

--2.Find the names of sailors who have reserved a red boat.
select distinct sid, sname
from sailors
where sid in (select sid
                from reserves
                where bid in (
                select bid
                from boats
                where color = 'red'))
order by sid;

--3.Find the names of sailors who have not reserved a red boat.
select sid, sname
from sailors
where sid not in (select sid
                    from reserves
                    where sid in(
                    select sid
                    from reserves
                    where bid in(
                    select bid
                    from boats
                    where color = 'red')))
order by sid;
                    
--4.Find the names of sailors who have reserved both a red boat
--and a green boat.
select sid, sname
from sailors
where sid in (select sid
                from reserves
                where bid in(
                select bid
                from boats
                where color = 'red'))
and
    sid in (select sid
                from reserves
                where bid in(
                select bid
                from boats
                where color = 'green'))
order by sid;

--5.Find the names of sailors who have reserved a red boat but not agreen boat.
select sid, sname
from sailors
where sid in (select sid
                from reserves
                where bid in(
                select bid
                from boats
                where color = 'red'))
and
    sid not in (select sid
                from reserves
                where bid in(
                select bid
                from boats
                where color = 'green'))
order by sid;
                
--PART3
--1.Find the names of sailors who have reserved boat number 103.
select distinct sid, sname
from sailors s
where exists (select *
                from reserves r
                where r.sid = s.sid and
                bid = 103)
order by sid;
                
--PART4
--1.Find the names of sailors whose rating is better than
--some sailor called Horatio.
select distinct s1.sid, s1.sname
from sailors s1, sailors s2
where s2.sname = 'Horatio' and s1.rating > s2.rating
order by sid;

--2.Find the names of sailors whose rating is better than
--every sailor called Horatio.
select distinct s1.sid, s1.sname
from sailors s1, sailors s2
where s1.rating > (select max(rating)
                    from sailors
                    where sname = 'Horatio')
order by sid;
                    
--3.Find the names of sailors with the highest rating.
select distinct sid, sname, rating
from sailors
where rating = (select max(rating)
                from sailors)
order by sid;
                
--4.Find the names of sailors who have reserved all boats.
select distinct sid, sname
from sailors
where sid not in (select sid
                    from sailors, boats
                    where sid||bid not in (select sid||bid
                    from reserves))
order by sid;
                    
--5.Find the average age of all sailors.
select avg(age)
from sailors;

--6.Find the average age of all sailors with a rating of 10.
select avg(age)
from sailors
where rating = 10;

--7.Find the name and age of the oldest sailor.
select distinct sid, sname, age
from sailors
where age = (select max(age)
                from sailors)
order by sid;
            
--8.Find the names of sailors who are older than
--the oldest sailor with a rating of 10
select distinct sid, sname, age
from sailors
where age > (select max(age)
                from sailors
                where rating = 10)
order by sid;
            
--9.Find the age of the youngest sailor for each rating level
select rating, age
from sailors s
where age = (select min(age)
                from sailors
                where rating = s.rating)
group by rating, age
order by rating;

--10.Find the age of the youngest sailor who is eligible to vote
--(at least 18 years old) for each rating level with at least two sailors.
select rating, min(age)
from sailors
where age >= 18 and rating in (select rating
                                from sailors
                                group by rating
                                having count(*) >= 2)
group by rating
order by rating;

--11.Find the age of the youngest sailor who is eligible to vote
--(at least 18 years old) for each rating level with at least two such sailors.
select rating, age
from sailors s
where age >= 18 and age = (select min(age)
                            from sailors
                            where rating = s.rating
                            having count(*) > 1)
group by rating, age
order by rating;

--12.For each red boat, find the number of reservations for this boat.
select b.bid, count(r.bid)
from boats b, reserves r
where b.bid = r.bid and color = 'red'
group by b.bid
order by bid;

--13.Find the average age of sailors for each rating level
--that has at least two sailors.
select rating, avg(age)
from sailors
group by rating
having count(*) >= 2
order by rating;

--14.Find those ratings for which the average age of sailors is the minimum over all ratings.
select rating, avg(age)
from sailors
group by rating
having avg(age) = (select min(avg(age))
                    from sailors
                    group by rating)
order by rating;