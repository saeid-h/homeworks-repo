--------------------------------------------------------
--  File created - Friday-September-30-2016   
--------------------------------------------------------
DROP TABLE "HOSS5825"."ACTED" cascade constraints;
DROP TABLE "HOSS5825"."DIRECTOR" cascade constraints;
DROP TABLE "HOSS5825"."MOVIE" cascade constraints;
DROP TABLE "HOSS5825"."PERFORMER" cascade constraints;
--------------------------------------------------------
--  DDL for Table ACTED
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."ACTED" 
   (	"PID" NUMBER(*,0), 
	"MNAME" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table DIRECTOR
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."DIRECTOR" 
   (	"DID" NUMBER(*,0), 
	"DNAME" VARCHAR2(20 BYTE), 
	"EARNINGS" FLOAT(63)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table MOVIE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."MOVIE" 
   (	"MNAME" VARCHAR2(20 BYTE), 
	"GENRE" VARCHAR2(20 BYTE), 
	"MINUTES" NUMBER(*,0), 
	"RELEASE_YEAR" NUMBER, 
	"DID" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PERFORMER
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PERFORMER" 
   (	"PID" NUMBER(*,0), 
	"PNAME" VARCHAR2(20 BYTE), 
	"YEARS_OF_EXPERIENCE" NUMBER(*,0), 
	"AGE" NUMBER(*,0)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
REM INSERTING into HOSS5825.ACTED
SET DEFINE OFF;
Insert into HOSS5825.ACTED (PID,MNAME) values (4,'Fight Club');
Insert into HOSS5825.ACTED (PID,MNAME) values (5,'Fight Club');
Insert into HOSS5825.ACTED (PID,MNAME) values (6,'Shawshank Redemption');
Insert into HOSS5825.ACTED (PID,MNAME) values (4,'Up');
Insert into HOSS5825.ACTED (PID,MNAME) values (5,'Shawshank Redemption');
Insert into HOSS5825.ACTED (PID,MNAME) values (1,'The Departed');
Insert into HOSS5825.ACTED (PID,MNAME) values (2,'Fight Club');
Insert into HOSS5825.ACTED (PID,MNAME) values (3,'Fight Club');
Insert into HOSS5825.ACTED (PID,MNAME) values (4,'Alien');
REM INSERTING into HOSS5825.DIRECTOR
SET DEFINE OFF;
Insert into HOSS5825.DIRECTOR (DID,DNAME,EARNINGS) values (1,'Parker',580000);
Insert into HOSS5825.DIRECTOR (DID,DNAME,EARNINGS) values (2,'Black',2500000);
Insert into HOSS5825.DIRECTOR (DID,DNAME,EARNINGS) values (3,'Black',30000);
Insert into HOSS5825.DIRECTOR (DID,DNAME,EARNINGS) values (4,'Stone',820000);
REM INSERTING into HOSS5825.MOVIE
SET DEFINE OFF;
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Jurasic Park','Action',125,1984,2);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Shawshank Redemption','Drama',105,2001,2);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Fight Club','Drama',144,2015,2);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('The Departed','Drama',130,1969,3);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Back to the Future','Comedy',89,2008,3);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('The Lion King','Animation',97,1990,1);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Alien','Sci-Fi',115,2006,3);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Toy Story','Animation',104,1978,1);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Scarface','Drama',124,2003,1);
Insert into HOSS5825.MOVIE (MNAME,GENRE,MINUTES,RELEASE_YEAR,DID) values ('Up','Animation',111,1999,4);
REM INSERTING into HOSS5825.PERFORMER
SET DEFINE OFF;
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (1,'Morgan',48,67);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (2,'Cruz',14,28);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (3,'Adams',1,16);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (4,'Perry',18,32);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (5,'Hanks',36,55);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (6,'Hanks',15,24);
Insert into HOSS5825.PERFORMER (PID,PNAME,YEARS_OF_EXPERIENCE,AGE) values (7,'Lewis',13,32);
--------------------------------------------------------
--  DDL for Index DIRECTOR_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."DIRECTOR_PK" ON "HOSS5825"."DIRECTOR" ("DID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index MOVIE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."MOVIE_PK" ON "HOSS5825"."MOVIE" ("MNAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PERFORMER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PERFORMER_PK" ON "HOSS5825"."PERFORMER" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  Constraints for Table ACTED
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."ACTED" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACTED" MODIFY ("MNAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table DIRECTOR
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."DIRECTOR" ADD CONSTRAINT "DIRECTOR_PK" PRIMARY KEY ("DID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."DIRECTOR" MODIFY ("DID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table MOVIE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."MOVIE" ADD CONSTRAINT "MOVIE_PK" PRIMARY KEY ("MNAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."MOVIE" MODIFY ("MNAME" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."MOVIE" MODIFY ("DID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PERFORMER
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PERFORMER" ADD CONSTRAINT "PERFORMER_CHK1" CHECK (Years_of_experience < age) ENABLE;
  ALTER TABLE "HOSS5825"."PERFORMER" ADD CONSTRAINT "PERFORMER_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PERFORMER" MODIFY ("PID" NOT NULL ENABLE);
  
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


