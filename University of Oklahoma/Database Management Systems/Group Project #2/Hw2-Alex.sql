-- By Alexander Rodriguez
-- create tables 

create table performer(
  pid integer,
  pname varchar(10), -- 15
  years_of_experience integer,
  age integer,
  primary key(pid)
  )

create table director(
  did integer, 
  dname varchar(10), 
  earnings integer,
  primary key(did)
  )

create table movie(
  mname varchar(20), 
  genre varchar(10), 
  minutes integer, 
  release_year integer, 
  did integer,
  primary key(mname),
  foreign key(did) references director(did)
  )

--drop table acted
--drop table movie

create table acted(
  pid integer,
  mname varchar(20),
  foreign key (pid) references performer(pid),
  foreign key (mname) references movie(mname)
  )
  

-- insert values for all the tables

insert into performer (pid, pname, years_of_experience, age)
  select 1, 'Morgan', 48, 67 from dual
  union all select  2, 'Cruz', 14, 28 from dual
  union all select  3, 'Adams', 1, 16 from dual
  union all select  4, 'Perry', 18, 32 from dual
  union all select  5, 'Hanks', 36, 55 from dual
  union all select  6, 'Hanks', 15, 24 from dual
  union all select  7, 'Lewis', 13, 32 from dual

insert into director (did, dname, earnings)
  select 1, 'Parker', 580000 from dual
  union all select  2, 'Black', 2500000 from dual
  union all select  3, 'Black', 30000 from dual
  union all select  4, 'Stone', 820000 from dual

insert into movie (mname, genre, minutes, release_year, did)
  select 'Jurassic Park', 'Action' ,125 ,1984, 2 from dual
  union all select 'Shawshank Redemption', 'Drama', 105, 2001 ,2 from dual
  union all select 'Fight Club','Drama', 144, 2015, 2 from dual
  union all select 'The Departed' ,'Drama' ,130, 1969, 3 from dual
  union all select 'Back to the Future', 'Comedy' ,89, 2008, 3 from dual
  union all select 'The Lion King' ,'Animation', 97, 1990, 1 from dual
  union all select 'Alien', 'Sci-Fi', 115, 2006 ,3 from dual
  union all select 'Toy Story' ,'Animation' ,104, 1978, 1 from dual
  union all select 'Scarface', 'Drama', 124 ,2003 ,1 from dual
  union all select 'Up','Animation' ,111 ,1999 ,4 from dual

insert into acted (pid, mname)
  select 4, 'Fight Club' from dual
  union all select 5, 'Fight Club' from dual
  union all select 6, 'Shawshank Redemption' from dual
  union all select 4, 'Up' from dual
  union all select 5, 'Shawshank Redemption' from dual
  union all select 1, 'The Departed' from dual
  union all select 2, 'Fight Club' from dual
  union all select 3, 'Fight Club' from dual
  union all select 4, 'Alien' from dual


-- 1. Display all the data you store in the database to verify that you have 
-- populated the relations correctly.
select * from performer
select * from director
select * from movie
select * from acted

-- 2. Find the names of all performers with at least 20 years of experience 
-- who have acted in a movie directed by Black.
(select pname from performer where years_of_experience >= 20)
intersect
(select pname
  from performer, acted, movie, director
  where performer.pid = acted.pid and acted.mname = movie.mname
      and movie.did = director.did and director.dname = 'Black')

-- The one that is inside is:
select pname, performer.pid, acted.mname, director.did, director.dname
        from performer, acted, movie, director
        where performer.pid = acted.pid and acted.mname = movie.mname
        and movie.did = director.did and director.dname = 'Black'

-- 3. Find the age of the oldest performer who is either named “Hanks” or 
-- has acted in a movie named “The Departed”
select max(age)
from performer, acted, movie
where (performer.pid = acted.pid and acted.mname = 'The Departed') 
  or (performer.pname = 'Hanks')

-- 4. Find the names of all movies that are either a Comedy (genre = “Comedy”) 
-- or have had more than one performer act in them.
(select mname from movie where movie.genre = 'Comedy')
union
(select mname
  from (select acted.mname, performer.pname, performer.pid
      from performer, acted
      where performer.pid = acted.pid)
  group by mname
  having count(pid) > 1) -- count performer id
  
-- 5. Find the names of directors for whom the combined number of 
-- performers for all movies that they directed is more than one.
select dname
from (select director.did, director.dname, movie.mname
      from director, movie
      where movie.did = director.did)
group by did, dname -- group by id and name! because there are names repetead
having count(mname) > 1

-- 6. Find the genres for which exactly two directors direct a movie of that genre.
select genre
from (select distinct genre, did
      from movie)
group by genre
having count(did) = 2

-- 7. Find the names and pid's of all performers who have acted in two movies 
-- that have the same genre.
select pid, pname
from (select performer.pid, pname, genre
      from performer, acted, movie
      where performer.pid = acted.pid and acted.mname = movie.mname)
group by pid, pname
having count(distinct genre) = 2
-- result = 0

-- 8. For each genre, display the genre and the average length (minutes) of
-- movies for that genre.
select genre, avg(minutes)
from movie
group by genre

-- 9. Decrease the earnings of all directors who directed “Up” by 10%.
update director
set director.earnings = director.earnings * 1.10
where exists (
    select 1
    from movie
    where director.did = movie.did and movie.mname = 'Up')
-- Called correlated update?
-- http://stackoverflow.com/questions/7030699/oracle-sql-update-a-table-with-data-from-another-table

-- 10. Delete all movies released in the 70's and 80's (1970 <= release_year <= 1989).
delete from movie
where 1970 <= release_year and  release_year  <= 1989

