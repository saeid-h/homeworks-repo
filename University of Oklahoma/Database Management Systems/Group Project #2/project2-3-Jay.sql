-- 2) Movie Database: Given a relational database that consists of the following relations:
-- Performer (pid: integer, pname: string, years_of_experience: integer, age: integer) 
-- Movie (mname: string,genre: string, minutes: integer, release_year: integer, did: integer)
-- Acted (pid: integer, mname: string)
-- Director (did: integer, dname: string, earnings: real)

-- a) Create the relations.

CREATE TABLE Employee (
  empid INTEGER PRIMARY KEY,
  empname VARCHAR2(35),
  address VARCHAR2(35),
  salary INTEGER,
  DOB DATE,
  gender VARCHAR2(1)
);
  
INSERT INTO Employee VALUES (111, 'Sharon Carter', '123 Alpha St',50000, TO_DATE('19770412', 'YYYYMMDD'), 'F');
INSERT INTO Employee VALUES (112, 'Bucky Barns', '123 Bravo St',50000, TO_DATE('19810702', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (113, 'Peter Parker', '123 Charlie St',50000, TO_DATE('19910719', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (114, 'Xander Cage', '123 Delta St',50000, TO_DATE('19850320', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (115, 'Steve Rodger', '123 Epsilon St',50000, TO_DATE('19800101', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (116, 'Tony Stark', '123 Foxtrot St',50000, TO_DATE('19750227', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (117, 'Natasha Romanoff', '123 Golf St',50000, TO_DATE('19830908', 'YYYYMMDD'), 'F');
INSERT INTO Employee VALUES (118, 'Nick Fury', '123 Hotel St',50000, TO_DATE('19810629', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (119, 'Scott Lang', '123 India St',50000, TO_DATE('19760122', 'YYYYMMDD'), 'M');
INSERT INTO Employee VALUES (110, 'Wanda Maximoff', '123 Juliet St',50000, TO_DATE('19881202', 'YYYYMMDD'), 'F');

CREATE TABLE Employee_Phone (
  EMPID INTEGER,
  phone_number VARCHAR2(15),
  PRIMARY KEY (empid, phone_number),
  FOREIGN KEY (EMPID) REFERENCES EMPLOYEE
);

INSERT INTO Employee_Phone VALUES (111,'555-111-1213');
INSERT INTO Employee_Phone VALUES (112,'555-111-1214');
INSERT INTO Employee_Phone VALUES (113,'555-111-1215');
INSERT INTO Employee_Phone VALUES (114,'555-111-1216');
INSERT INTO Employee_Phone VALUES (115,'555-111-1217');
INSERT INTO Employee_Phone VALUES (116,'555-111-1218');
INSERT INTO Employee_Phone VALUES (117,'555-111-1219');
INSERT INTO Employee_Phone VALUES (118,'555-111-1220');
INSERT INTO Employee_Phone VALUES (119,'555-111-1222');
INSERT INTO Employee_Phone VALUES (110,'555-111-1221');
INSERT INTO Employee_Phone VALUES (115,'555-111-2222');
INSERT INTO Employee_Phone VALUES (118,'555-111-3333');


CREATE TABLE Performer (
  EMPID INTEGER,
  PRIMARY KEY (EMPID),
  FOREIGN KEY (EMPID) REFERENCES Employee
);

INSERT INTO Performer VALUES(112);
INSERT INTO Performer VALUES(115);
INSERT INTO Performer VALUES(119);
INSERT INTO Performer VALUES(117);

CREATE TABLE Role_Type (
  EMPID INTEGER,
  P_ROLES VARCHAR2(25),
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, P_ROLES, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Performer,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);


INSERT INTO Role_Type VALUES (112, 'Supporting Actor','Sharknado', 2001);
INSERT INTO Role_Type VALUES (112, 'Leading Actor','Sharknado 2', 2005);
INSERT INTO Role_Type VALUES (112, 'Leading Actor','Shrek', 2003);
INSERT INTO Role_Type VALUES (115, 'Supporting Actor','Avengers', 2010);
INSERT INTO Role_Type VALUES (117, 'Leading Actor','Happy Gilmore', 1999);
INSERT INTO Role_Type VALUES (119, 'Supporting Actor','Halloween', 1984);

CREATE TABLE Performer_Awards (
  EMPID INTEGER,
  AWARD_NAME VARCHAR2(25),
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, AWARD_NAME, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Performer,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);

INSERT INTO Performer_Awards VALUES (112, 'Academy Award', 'Sharknado', 2001);
INSERT INTO Performer_Awards VALUES (117, 'Academy Award', 'Happy Gilmore', 1999);
INSERT INTO Performer_Awards VALUES (112, 'MTV Movie Award', 'Sharknado 2', 2005);

CREATE TABLE Crew (
  EMPID INTEGER,
  JOB_TITLE VARCHAR2(25),
  EXPERTISE VARCHAR2(25),
  PRIMARY KEY (EMPID),
  FOREIGN KEY (EMPID) REFERENCES Employee
);

INSERT INTO Crew VALUES(111, 'Grip 1', 'Getting Coffee');
INSERT INTO Crew VALUES(118, 'Electrician', 'Set wiring');

CREATE TABLE Director (
  EMPID INTEGER,
  PROF_ORGANIZATION VARCHAR2(25),
  PRIMARY KEY (EMPID),
  FOREIGN KEY (EMPID) REFERENCES Employee
);

CREATE TABLE Director_Awards (
  EMPID INTEGER,
  AWARD_NAME VARCHAR2(25),
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, AWARD_NAME, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Director,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);

INSERT INTO Director VALUES(110, 'AARP');
INSERT INTO Director VALUES(116, 'NALP');

INSERT INTO Director_Awards VALUES (110, 'Academy Award', 'Sharknado', 2001);
INSERT INTO Director_Awards VALUES (116, 'Academy Award', 'Avengers', 2010);


CREATE TABLE Producer (
  EMPID INTEGER,
  PRANK VARCHAR2(25),
  PPOSITION VARCHAR2(25),
  PRIMARY KEY (EMPID),
  FOREIGN KEY (EMPID) REFERENCES Employee
);

INSERT INTO Producer VALUES(113, 'Executive', 'On Set');
INSERT INTO Producer VALUES(114, 'Associate', 'Digital');

CREATE TABLE Movie (
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  DESIRED_RATING VARCHAR(5),
  GENRE VARCHAR2(15),
  BUDGET INTEGER,
  PRIM_LANGUAGE VARCHAR2(15),
  PRIMARY KEY (MNAME, REL_YEAR)
);

INSERT INTO Movie VALUES ('Sharknado', 2001, 'NC-17', 'Action', 25000000, 'English');
INSERT INTO Movie VALUES ('Sharknado 2', 2005, 'NC-17', 'Action', 50000000, 'English');
INSERT INTO Movie VALUES ('Avengers', 2010, 'PG-13', 'Action', 100000000, 'English');
INSERT INTO Movie VALUES ('Happy Gilmore', 1999, 'PG', 'Comedy', 5000000, 'German');
INSERT INTO Movie VALUES ('Halloween', 1984, 'R', 'Suspense', 2500000, 'Japanese');
INSERT INTO Movie VALUES ('Shrek', 2003, 'G', 'Animation', 99000000, 'German');

CREATE TABLE Casting (
  EMPID INTEGER,
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Performer,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);

INSERT INTO Casting VALUES (112, 'Sharknado', 2001);
INSERT INTO Casting VALUES (112, 'Sharknado 2', 2005);
INSERT INTO Casting VALUES (112, 'Shrek', 2003);
INSERT INTO Casting VALUES (115, 'Avengers', 2010);
INSERT INTO Casting VALUES (117, 'Happy Gilmore', 1999);
INSERT INTO Casting VALUES (119, 'Halloween', 1984);

CREATE TABLE Assigned (
  EMPID INTEGER,
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Crew,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);

INSERT INTO Assigned VALUES (111, 'Sharknado', 2001);
INSERT INTO Assigned VALUES (111, 'Sharknado 2', 2005);
INSERT INTO Assigned VALUES (111, 'Avengers', 2010);
INSERT INTO Assigned VALUES (118, 'Avengers', 2010);
INSERT INTO Assigned VALUES (118, 'Happy Gilmore', 1999);
INSERT INTO Assigned VALUES (118, 'Halloween', 1984);
INSERT INTO Assigned VALUES (118, 'Sharknado', 2001);

CREATE TABLE Attached (
  EMPID INTEGER,
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Director,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie

);

INSERT INTO Attached VALUES(110, 'Sharknado', 2001);
INSERT INTO Attached VALUES(116, 'Avengers', 2010);

CREATE TABLE Coordinates (
  EMPID INTEGER,
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (EMPID, MNAME, REL_YEAR),
  FOREIGN KEY (EMPID) REFERENCES Producer,
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie
);

INSERT INTO Coordinates VALUES(113, 'Sharknado', 2001);
INSERT INTO Coordinates VALUES(114, 'Sharknado', 2001);
INSERT INTO Coordinates VALUES(113, 'Shrek', 2003);
INSERT INTO Coordinates VALUES(114, 'Shrek', 2003);
INSERT INTO Coordinates VALUES(113, 'Avengers', 2010);
INSERT INTO Coordinates VALUES(114, 'Happy Gilmore', 1999);

CREATE TABLE Filming_Location (
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  COUNTRY VARCHAR2(25),
  CITY VARCHAR2(25),
  PRIMARY KEY (MNAME, REL_YEAR),
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie

);

INSERT INTO Filming_Location VALUES ('Sharknado', 2001, 'Australia', 'Sydney');
INSERT INTO Filming_Location VALUES ('Sharknado 2', 2005, 'Phillipines', 'Manila');
INSERT INTO Filming_Location VALUES ('Avengers', 2010, 'England', 'London');
INSERT INTO Filming_Location VALUES ('Happy Gilmore', 1999, 'Germany', 'Frankfurt');
INSERT INTO Filming_Location VALUES ('Halloween', 1984,'Japan', 'Tokyo');
INSERT INTO Filming_Location VALUES ('Shrek', 2003, 'Germany', 'Munich');

CREATE TABLE Agreement (
  AGREEID INTEGER,
  START_DATE DATE,
  END_DATE DATE,
  AMOUNT INTEGER,
  PRIMARY KEY (AGREEID)
);

INSERT INTO Agreement VALUES (1, TO_DATE('19990101', 'YYYYMMDD'), TO_DATE('20000101', 'YYYYMMDD'), 5000000);
INSERT INTO Agreement VALUES (2, TO_DATE('20030101', 'YYYYMMDD'), TO_DATE('20050101', 'YYYYMMDD'), 1000000);
INSERT INTO Agreement VALUES (3, TO_DATE('20010101', 'YYYYMMDD'), TO_DATE('20030101', 'YYYYMMDD'), 999999);
INSERT INTO Agreement VALUES (4, TO_DATE('19830101', 'YYYYMMDD'), TO_DATE('19830601', 'YYYYMMDD'), 25000);

CREATE TABLE Signed (
  AGREEID INTEGER,
  MNAME VARCHAR2(25),
  REL_YEAR INTEGER,
  PRIMARY KEY (AGREEID, MNAME, REL_YEAR),
  FOREIGN KEY (MNAME, REL_YEAR) REFERENCES Movie,
  FOREIGN KEY (AGREEID) REFERENCES Agreement
);

INSERT INTO Signed VALUES (1,'Sharknado', 2001);
INSERT INTO Signed VALUES (2,'Avengers', 2010);
INSERT INTO Signed VALUES (3,'Happy Gilmore', 1999);
INSERT INTO Signed VALUES (4,'Shrek', 2003);

CREATE TABLE Service (
  AGREEID INTEGER,
  STYPE VARCHAR2(15),
  REQUIREMENTS VARCHAR2(75),
  PRIMARY KEY (AGREEID, STYPE, REQUIREMENTS),
  FOREIGN KEY (AGREEID) REFERENCES Agreement
);

INSERT INTO Service VALUES (1, 'Cleaning', 'Daily trash collection and clean up');
INSERT INTO Service VALUES (2, 'Security', '5 Armed police to control entry and exit');
INSERT INTO Service VALUES (3, 'Cleaning', 'Weekly trash collection');
INSERT INTO Service VALUES (4, 'Cleaning', 'Set teardown and disposal');


SELECT *
FROM Employee;

SELECT *
FROM Employee Emp, Performer Pe 
WHERE Emp.empid = Pe.empid;

SELECT *
FROM Employee Emp, Performer Pe, Role_Type Rt
WHERE Emp.empid = Pe.empid and Rt.empid = Pe.empid;

SELECT *
FROM Employee Emp, Crew Cr 
WHERE Emp.empid = Cr.empid;

SELECT *
FROM Employee Emp, Crew Cr
WHERE Emp.empid = Cr.empid;

SELECT *
FROM Employee Emp, Director Di 
WHERE Emp.empid = Di.empid;

SELECT *
FROM Employee Emp, Director Di, Director_Awards Da
WHERE Emp.empid = Di.empid and Da;

SELECT *
FROM Employee Emp, Producer Pr 
WHERE Emp.empid = Pr.empid;

SELECT Mo.Mname, Emp.empname, Da.award_name
FROM Employee Emp, Movie Mo, Director Di, Attached Atc, Director_Awards Da
WHERE Mo.Mname = Atc.Mname and Atc.empid = Di.empid and Di.empid = Da.empid and Emp.empid = Di.empid;

SELECT *
FROM Movie Mo, Performer Pe, Casting Ca
WHERE Mo.Mname = Ca.Mname and Ca.empid = Pe.empid;

SELECT Emp.emppname as Emp_Name, Ep.Phone_Number as Phone_Number
FROM Employee Emp, Employee_Phone Ep
WHERE emp.empid = ep.empid

SELECT *
FROM Movie;
