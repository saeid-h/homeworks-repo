--------------------------------------------------------
--  File created - Friday-September-30-2016   
--------------------------------------------------------
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
--------------------------------------------------------
--  Constraints for Table ACTED
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."ACTED" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACTED" MODIFY ("MNAME" NOT NULL ENABLE);
