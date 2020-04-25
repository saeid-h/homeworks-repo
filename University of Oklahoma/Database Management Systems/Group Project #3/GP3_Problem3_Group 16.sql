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

--------------------------------------------------------
-- ANONYMOUS BLOCK TO CALL THE INSERT_MOVIE PROCEDURE --
--------------------------------------------------------

SELECT * FROM MOVIE;

SET SERVEROUTPUT ON;
-- Have to cut this out in order to show the table in the output file
DECLARE
  MNAME VARCHAR2(200);
  GENRE VARCHAR2(200);
  RY NUMBER;
  DID NUMBER;
BEGIN

  MNAME := 'BIG MOUNTAIN';
  GENRE := 'Comedy';
  RY := 1985;
  DID := 2;

  INSERT_MOVIE(
    MNAME => MNAME,
    GENRE => GENRE,
    RY => RY,
    DID => DID
  );
  
  MNAME := 'Rocky Horror Picture Show';
  GENRE := 'Horror';
  RY := 1992;
  DID := 1;

  INSERT_MOVIE(
    MNAME => MNAME,
    GENRE => GENRE,
    RY => RY,
    DID => DID
  );
  
END;


--------------------------------------------------------
--  DDL for Procedure DISPLAY_PERFORMERS
--------------------------------------------------------
set define off;

  CREATE OR REPLACE EDITIONABLE PROCEDURE "MCKI4978"."DISPLAY_PERFORMERS" AS 
BEGIN
  -- First, we loop through each performer and display their basic bio-data
  FOR perf IN (SELECT PID, PNAME, AGE, YEARS_OF_EXPERIENCE as YOE FROM PERFORMER)
  LOOP
    DBMS_OUTPUT.PUT_LINE('Performer Name: ' || perf.PNAME);
    DBMS_OUTPUT.PUT_LINE('Performer AGE: ' || perf.AGE);
    DBMS_OUTPUT.PUT_LINE('Performer YOE: ' || perf.YOE);
    DBMS_OUTPUT.PUT_LINE('Acted In:');
    -- Then we loop through and attach all the movies they have been in.
    FOR acted_ IN (SELECT MNAME FROM PERFORMER Pe, Acted Ac WHERE Pe.PID = Ac.PID AND Pe.PID = perf.PID)
    LOOP
      DBMS_OUTPUT.PUT_LINE('              ' || acted_.MNAME);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('------------------------');
  END LOOP;

END DISPLAY_PERFORMERS;

/

--------------------------------------------------------
-- ANONYMOUS BLOCK TO CALL DISPLAY_PERFORMERS PROCEDURE --
--------------------------------------------------------

SET SERVEROUTPUT ON;
BEGIN
  DISPLAY_PERFORMERS();
--rollback; 
END;