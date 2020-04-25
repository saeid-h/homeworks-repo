--------------------------------------------------------
--  File created - Sunday-October-16-2016   
--------------------------------------------------------
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
