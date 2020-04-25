--DROP TABLE Performer PURGE;
--DROP TABLE Director PURGE;
--DROP TABLE Movie PURGE;
--DROP TABLE Acted PURGE;

CREATE TABLE Performer (
  pid INTEGER PRIMARY KEY,
  pname VARCHAR2(35),
  years_of_experience NUMBER(2),
  age INTEGER 
);
  
INSERT INTO Performer VALUES (1, 'Morgan', 48, 67);
INSERT INTO Performer VALUES (2, 'Cruz', 14, 28);
INSERT INTO Performer VALUES (3, 'Adams', 1, 16);
INSERT INTO Performer VALUES (4, 'Perry', 18, 32);
INSERT INTO Performer VALUES (5, 'Hanks', 36, 55);
INSERT INTO Performer VALUES (6, 'Hanks', 15, 24);
INSERT INTO Performer VALUES (7, 'Lewis', 13, 32);


CREATE TABLE Director (
  did INTEGER PRIMARY KEY,
  dname VARCHAR2(35),
  earnings INTEGER
);

INSERT INTO Director VALUES (1, 'Parker', 580000);
INSERT INTO Director VALUES (2, 'Black', 2500000);
INSERT INTO Director VALUES (3, 'Black', 30000);
INSERT INTO Director VALUES (4, 'Stone', 820000);


CREATE TABLE Movie (
  mname VARCHAR2(35) PRIMARY KEY,
  genre VARCHAR2(15),
  minutes INTEGER,
  release_year INTEGER,
  did INTEGER,
  FOREIGN KEY (did) REFERENCES Director
);

INSERT INTO Movie VALUES ('Jurassic Park', 'Action', 125, 1984, 2);
INSERT INTO Movie VALUES ('Shawshank Redemption', 'Drama', 105, 2001, 2);
INSERT INTO Movie VALUES ('Fight Club', 'Drama', 144, 2015, 2);
INSERT INTO Movie VALUES ('The Departed', 'Drama', 130, 1969, 3);
INSERT INTO Movie VALUES ('Back to the Future', 'Comedy', 89, 2008, 3);
INSERT INTO Movie VALUES ('The Lion King', 'Animation', 97, 1990, 1);
INSERT INTO Movie VALUES ('Alien', 'Sci-Fi', 115, 2006, 3);
INSERT INTO Movie VALUES ('Toy Story', 'Animation', 104, 1978, 1);
INSERT INTO Movie VALUES ('Scarface', 'Drama', 124, 2003, 1);
INSERT INTO Movie VALUES ('Up', 'Animation', 111, 1999, 4);



CREATE TABLE Acted (
  pid INTEGER,
  mname VARCHAR2(35),
  PRIMARY KEY (pid, mname),
  FOREIGN KEY (pid) REFERENCES Performer
);

INSERT INTO Acted VALUES (4, 'Fight Club');
INSERT INTO Acted VALUES (5, 'Fight Club');
INSERT INTO Acted VALUES (6, 'Shawshank Redemption');
INSERT INTO Acted VALUES (4, 'Up');
INSERT INTO Acted VALUES (5, 'Shawshank Redemption');
INSERT INTO Acted VALUES (1, 'The Departed');
INSERT INTO Acted VALUES (2, 'Fight Club');
INSERT INTO Acted VALUES (3, 'Fight Club');
INSERT INTO Acted VALUES (4, 'Alien');

-- 1 --
-- Display all the data you store in the database to verify that you have 
-- populated the relations correctly.

SELECT * FROM Performer;
SELECT * FROM Director;
SELECT * FROM Movie;
SELECT * FROM Acted;

-- 2 --
-- Find the names of all performers with at least 20 years of experience who 
-- have acted in a movie directed by Black.

SELECT DISTINCT Pe.Pname FROM DIRECTOR Di, Movie Mo, Acted Ac, Performer Pe 
WHERE Di.DID = Mo.DID and Mo.MNAME = Ac.MNAME and Pe.PID = Ac.PID and Pe.YEARS_OF_EXPERIENCE >= 20 and Di.dname = 'Black';


--select distinct pname
--from Performer, DIRECTOR, MOVIE, ACTED
--where Performer.YEARS_OF_EXPERIENCE > 20 and
--     Performer.pid = Acted.pid and
--     Acted.mname = Movie.mname and
--     Movie.did = Director.did and
--     Director.dname = 'Black';
     
--(select pname from performer where years_of_experience >= 20)
--intersect
--(select pname
--  from performer, acted, movie, director
--  where performer.pid = acted.pid and acted.mname = movie.mname
--      and movie.did = director.did and director.dname = 'Black');
      
-- 3 --
-- Find the age of the oldest performer who is either named â€œHanksâ€? or has acted 
-- in a movie named â€œThe Departedâ€?.

--SELECT max(age) AS Oldest_Performer FROM DIRECTOR Di, Movie Mo, Acted Ac, Performer Pe 
--WHERE Di.DID = Mo.DID and Mo.MNAME = Ac.MNAME and Pe.PID = Ac.PID and (Pe.Pname = 'Hanks' or Mo.Mname = 'The Departed');

select max(age) As Oldest
from PERFORMER natural join Acted
where pname = 'Hanks' or
      Acted.mname = 'The Departed';

--select max(age)
--from performer, acted, movie
--where (performer.pid = acted.pid and acted.mname = 'The Departed') 
--  or (performer.pname = 'Hanks');

-- 4 --
-- Find the names of all movies that are either a Comedy (genre = â€œComedyâ€?) or 
-- have had more than one performer act in them.

--SELECT Mo.Mname 
--From
--Movie Mo
--LEFT JOIN
--  (SELECT Mo.Mname as Nme, count(*) As CNT 
--  FROM Movie Mo, Acted Ac, Performer Pe 
--  WHERE Mo.Mname = Ac.Mname and Ac.PID = Pe.PID 
--  group by Mo.Mname) Ct 
--ON Mo.Mname = Ct.Nme
--WHERE Mo.Genre = 'Comedy' or Ct.CNT > 1;

--select mname 
--from Acted 
--group by mname 
--having count(mname) > 1 
--  union  
--select Movie.mname 
--from Movie
--where genre = 'Comedy';

(select mname from movie where movie.genre = 'Comedy')
union
(select mname
  from (select acted.mname, performer.pname, performer.pid
      from performer, acted
      where performer.pid = acted.pid)
  group by mname
  having count(pid) > 1);


-- 5 --
-- Find the names of directors for whom the combined number of performers for 
-- all movies that they directed is more than one.

--SELECT Di.Dname
--FROM
--  (SELECT Dname, Mname 
--  FROM DIRECTOR Di, MOVIE Mo
--  WHERE Di.DID = Mo.DID) Di
--LEFT JOIN
--  (SELECT Mo.Mname, count(Pe.Pname) as CNT
--  FROM Movie Mo, Acted Ac, Performer Pe
--  WHERE Mo.Mname = Ac.Mname and Ac.PID = Pe.PID
--  GROUP By Mo.Mname) Ct
--ON Di.Mname = Ct.Mname
--WHERE Ct.CNT > 1;


select dname, did
from Director
where did in
        (select did 
        from Movie natural join Acted 
        group by did 
        having count(pid) > 1);


--select dname
--from (select director.did, director.dname, movie.mname
--      from director, movie
--      where movie.did = director.did)
--group by did, dname -- group by id and name! because there are names repetead
--having count(mname) > 1;

-- 6 --
-- Find the genres for which exactly two directors direct a movie of that genre.

select genre
from (select distinct genre, did
      from movie)
group by genre
having count(did) = 2;

-- 7 -- 
-- Find the names and pid's of all performers who have acted in two movies that 
-- have the same genre. 8. For each genre, display the genre and the average 
-- length (minutes) of movies for that genre.
SELECT Pe.Pname, Pe.PID
FROM Performer Pe
LEFT JOIN
  (SELECT Pe.PID, Mo.Genre, count(*) as CNT
  FROM Acted Ac, Performer Pe, Movie Mo
  WHERE Ac.PID = Pe.PID and Ac.Mname = Mo.Mname
  GROUP BY Mo.Genre, Pe.PID) Ct
ON Pe.PID = Ct.PID
WHERE Ct.CNT >= 2;


-- 8 -- 
SELECT Mo.Genre, avg(Mo.Minutes) as Avg_Length
FROM Movie Mo
GROUP BY Mo.Genre;


-- select genre, avg(minutes) as avg_length
-- from Movie
-- group by genre;

-- select genre, avg(minutes)
-- from movie
-- group by genre;

-- 9 --
-- Decrease the earnings of all directors who directed â€œUpâ€? by 10%.

update director
set director.earnings = director.earnings * 1.10
where exists (
    select 1
    from movie
    where director.did = movie.did and movie.mname = 'Up');

-- 10 --
-- Delete all movies released in the 70's and 80's 
-- (1970 <= release_year <= 1989).

-- DELETE FROM Movie
-- WHERE release_year >= 1970 AND release_year <= 1989;

DELETE
from Movie
where release_year between 1970 and 1989;

-- delete from movie
-- where 1970 <= release_year and  release_year  <= 1989;



-- ============== TRYING SOME QUERIES ========================

SELECT AVG(YEARS_OF_EXPERIENCE)
      FROM PERFORMER
      WHERE 70 < AGE; -- GIVES YOU NULL