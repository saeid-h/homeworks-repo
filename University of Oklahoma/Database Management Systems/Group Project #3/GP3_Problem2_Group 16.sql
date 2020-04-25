
/* This is a procedure that created for option 1 command in Group Projec #3.
   Inputs are performer's ID, name and age. The years of experices would be 
   estimated based on the performers' experience in the range of -/+10 of 
   given performer. */
   
create or replace PROCEDURE INSERT_OPTION_1 
(
  PID_ IN NUMBER 
, PNAME_ IN VARCHAR2 
, AGE_ IN NUMBER 
) AS

EXP NUMBER;

/* SQL query to get the average years of experience for given age range . */
CURSOR ns_cur IS 
SELECT avg(years_of_experience)
FROM Performer
WHERE AGE between (AGE_-10) and (AGE_+10);

BEGIN
  /* Using SQL query. */
  OPEN ns_cur; 
  FETCH ns_cur INTO EXP; 
  CLOSE ns_cur;

  /* Check if we had any data from database. */
  IF EXP = 0 THEN
    EXP := AGE_ - 18;
  END IF;
  /* Check if years of experiene value is negative. */
  IF EXP < 0 THEN
    EXP := 0;
  END IF;
  /* Check if years of experience value is greater than age. */
  IF EXP > AGE_ THEN
    EXP := AGE_;
  END IF;
  
  /* insert data into database. */          
  INSERT INTO Performer(PID, PNAME, YEARS_OF_EXPERIENCE, AGE) 
  VALUES(PID_, PNAME_, EXP, AGE_);
  
END INSERT_OPTION_1;


/* ------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------- */
/* ------------------------------------------------------------------------------------------- */



/* This is a procedure that created for option 2 command in Group Projec #3.
   Inputs are performer's ID, name and age as well as direcor's ID. 
   The years of experices would be estimated based on the average of performers' 
   age who acted inthe given director's movies. */
   
create or replace PROCEDURE INSERT_OPTION_2 
(
  PID_ IN NUMBER 
, PNAME_ IN VARCHAR2 
, AGE_ IN NUMBER 
, DID_ IN NUMBER 
) AS 

EXP NUMBER;
TEMP_DID NUMBER;

/* SQL query to get the average years of experience for given director ID. */
CURSOR ns_cur IS 
SELECT DID, AVG(UNIQUE(PERFORMER.YEARS_OF_EXPERIENCE))
FROM (PERFORMER
  INNER JOIN ACTED ON
  PERFORMER.PID = ACTED.PID)
  INNER JOIN MOVIE ON
  ACTED.MNAME = MOVIE.MNAME
  WHERE DID = DID_
  GROUP BY DID;

BEGIN
  /* Using SQL query. */
  OPEN ns_cur; 
  FETCH ns_cur INTO TEMP_DID, EXP; 
  CLOSE ns_cur;
  
  /* Check if we had any data from database. */
  IF EXP = 0 THEN
    EXP := AGE_ - 18;
  END IF;
  /* Check if years of experiene value is negative. */
  IF EXP < 0 THEN
    EXP := 0;
  END IF;
  /* Check if years of experience value is greater than age. */
  IF EXP > AGE_ THEN
    EXP := AGE_;
  END IF;
            
  /* insert data into database. */          
  INSERT INTO Performer(PID, PNAME, YEARS_OF_EXPERIENCE, AGE) 
  VALUES(PID_, PNAME_, EXP, AGE_);
  
END INSERT_OPTION_2;




