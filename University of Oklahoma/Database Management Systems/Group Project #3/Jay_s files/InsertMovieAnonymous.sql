
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



