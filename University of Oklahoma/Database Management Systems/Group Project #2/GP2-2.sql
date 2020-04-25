-- 1
select * from Performer;
select * from Director;
select * from Movie;
select * from Acted;

-- 2
select distinct pname
from Performer, DIRECTOR, MOVIE, ACTED
where Performer.YEARS_OF_EXPERIENCE > 20 and
      Performer.pid = Acted.pid and
      Acted.mname = Movie.mname and
      Movie.did = Director.did and
      Director.dname = 'Black';
 
-- 3      
select max(age) 
from PERFORMER natural join Acted
where pname = 'Hanks' or
      Acted.mname = 'The Departed';
      
-- 4
select mname 
from Acted 
group by mname 
having count(mname) > 1 
  union  
select Movie.mname 
from Movie
where genre = 'Comedy';

-- 5
select dname, did
from Director
where did in
        (select did 
        from Movie natural join Acted 
        group by did 
        having count(pid) > 1);
        
-- 6 ---- wrong answer
select distinct M1.genre
from Movie M1, Movie M2
where M1.genre = M2.genre and M1.did <> M2.did;

-- 7 ---- wrong answer
select pid, pname 
from Performer
where pid in
      (select A1.pid
      from Acted A1, Acted A2, Movie M1, Movie M2
      where A1.pid = A2.pid and
            A1.mname <> A2.mname and
            ((A1.mname = M1.mname or A2.Mname = M1.mname) and
            (A1.mname = M2.mname or A2.Mname = M2.mname)) and 
            M1.mname <> M2.mname and
            M1.genre <> M2.genre);
      
-- 8
select genre, avg(minutes) as avg_length
from Movie
group by genre;

-- 9
select *
from Director
where did in
      (select did 
      from Movie
      where mname = 'Up');

-- 10
select *
from Movie
where release_year between 1970 and 1989;




