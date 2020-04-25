--------------------------------------------------------
--  File created - Sunday-October-16-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Procedure INSERT_MOVIE
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "MCKI4978"."INSERT_MOVIE" 
(
  MNAME IN VARCHAR2 -- User inputs Movie Name
, GENRE IN VARCHAR2 -- movie Genre
, RY IN INTEGER     -- release year
, DID IN INTEGER    -- Director of movie
) 

AS 
nMin INTEGER; -- Estimated movie time

-- This function estimates the legth of the movie
-- It tries to look at other movies of the same genre
-- then takes the average of all movies after a given year.
FUNCTION estimate_mlength(nGen in VARCHAR2, nRY in INTEGER) 
  RETURN INTEGER
  AS
  eMin INTEGER;
  cnt INTEGER;
  avgMin INTEGER;
  CURSOR cnt_cur is 
    SELECT count(*) FROM MOVIE
    WHERE GENRE = nGen AND RELEASE_YEAR > nRY-5;
  CURSOR avg_cur is 
    SELECT avg(Minutes) FROM MOVIE
    WHERE GENRE = nGen AND RELEASE_YEAR > nRY-5;

  BEGIN
    OPEN cnt_cur;
    FETCH cnt_cur INTO cnt;
    CLOSE cnt_cur;
    OPEN avg_cur;
    FETCH avg_cur INTO avgMin;
    CLOSE avg_cur;
    IF cnt = 0
    THEN
      eMin := 120;
    ELSE
      eMin := avgMin;
    END IF;
    RETURN eMin;
  END estimate_mlength;
BEGIN
  nMin := estimate_mlength(GENRE, RY);
  DBMS_OUTPUT.PUT_LINE('Inserting Movie: ' || Mname);
  INSERT INTO Movie VALUES (Mname, Genre, nMin, RY, DID);
  DBMS_OUTPUT.PUT_LINE('-----------------------');
  DBMS_OUTPUT.PUT_LINE('MName:' || '  ' ||  'Genre' || '  '|| 'Minutes' || '  '|| 'Release Year' || '  '|| 'DID');
  FOR movie_ IN (SELECT Mname AS Mn, Genre as Ge, Minutes as Mi, Release_Year as RY, DID FROM MOVIE)
  LOOP
    DBMS_OUTPUT.PUT_LINE(movie_.Mn || '  ' ||  movie_.Ge || '  '|| movie_.Mi || '  '|| movie_.RY || '  '|| movie_.DID);
  END LOOP;
END INSERT_MOVIE;

/
