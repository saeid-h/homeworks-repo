--------------------------------------------------------
--  File created - Tuesday-November-15-2016   
--------------------------------------------------------
--------------------------------------------------------
--  DDL for Table ACCIDENT
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."ACCIDENT" 
   (	"ACCIDENT_ID" NUMBER, 
	"PID" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table ACCIDENT_RECORD
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."ACCIDENT_RECORD" 
   (	"ACCIDENT_ID" NUMBER, 
	"ACCIDENT_DATE" DATE, 
	"WORK_DAYS" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table ACCOUNTS
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."ACCOUNTS" 
   (	"ACC_ID" NUMBER, 
	"ACC_DATE" DATE, 
	"COST" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table COMPLAIN
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."COMPLAIN" 
   (	"COMP_ID" NUMBER, 
	"P_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table COMPLAIN_LIST
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."COMPLAIN_LIST" 
   (	"COMP_ID" NUMBER, 
	"COMP_DATE" DATE, 
	"DESCRIPTION" VARCHAR2(200 BYTE), 
	"TREATMENT" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table CUSTOMER
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."CUSTOMER" 
   (	"C_NAME" VARCHAR2(20 BYTE), 
	"ADDRESS" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table EMPLOYEE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."EMPLOYEE" 
   (	"NAME" VARCHAR2(20 BYTE), 
	"ADDRESS" VARCHAR2(50 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table P1_ACCOUNT
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."P1_ACCOUNT" 
   (	"ACC_NO" NUMBER, 
	"PID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table P2_ACCOUNT
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."P2_ACCOUNT" 
   (	"ACC_NO" NUMBER, 
	"PID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table P3_ACCOUNT
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."P3_ACCOUNT" 
   (	"ACC_NO" NUMBER, 
	"PID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PRODUCE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PRODUCE" 
   (	"PID" NUMBER, 
	"NAME" VARCHAR2(20 BYTE), 
	"SPEND_TIME" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PRODUCT
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PRODUCT" 
   (	"PID" NUMBER, 
	"REPAIRER_NAME" VARCHAR2(20 BYTE), 
	"PRODUCTION_TIME" NUMBER, 
	"PRODUCER_NAME" VARCHAR2(20 BYTE), 
	"QC_NAME" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PRODUCT1
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PRODUCT1" 
   (	"PID" NUMBER, 
	"P_SIZE" VARCHAR2(20 BYTE), 
	"SOFTWARE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PRODUCT2
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PRODUCT2" 
   (	"PID" NUMBER, 
	"P_SIZE" VARCHAR2(20 BYTE), 
	"COLOR" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PRODUCT3
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PRODUCT3" 
   (	"PID" NUMBER, 
	"P_SIZE" VARCHAR2(20 BYTE), 
	"WEIGHT" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table PURCHASE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."PURCHASE" 
   (	"PID" NUMBER, 
	"NAME" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table QC_CHECK
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."QC_CHECK" 
   (	"PID" NUMBER, 
	"NAME" VARCHAR2(20 BYTE), 
	"QC_CERTIFICATE_ID" NUMBER
   ) SEGMENT CREATION DEFERRED 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table QC_STAFF
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."QC_STAFF" 
   (	"E_NAME" VARCHAR2(20 BYTE), 
	"TYPE_CHECK" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table REF_COMPLAIN
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."REF_COMPLAIN" 
   (	"TREATMENT" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table REF_DEGREE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."REF_DEGREE" 
   (	"DEGREE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table REF_P1_SIZE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."REF_P1_SIZE" 
   (	"P1_SIZE" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table REF_QC_TYPE
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."REF_QC_TYPE" 
   (	"TYPE" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table TECH_STAFF
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."TECH_STAFF" 
   (	"E_NAME" VARCHAR2(20 BYTE), 
	"EDUCATION" VARCHAR2(20 BYTE), 
	"POSITION" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Table WORKER
--------------------------------------------------------

  CREATE TABLE "HOSS5825"."WORKER" 
   (	"E_NAME" VARCHAR2(20 BYTE), 
	"MAX_PRODUCTION" NUMBER
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 
 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
REM INSERTING into HOSS5825.ACCIDENT
SET DEFINE OFF;
REM INSERTING into HOSS5825.ACCIDENT_RECORD
SET DEFINE OFF;
REM INSERTING into HOSS5825.ACCOUNTS
SET DEFINE OFF;
REM INSERTING into HOSS5825.COMPLAIN
SET DEFINE OFF;
REM INSERTING into HOSS5825.COMPLAIN_LIST
SET DEFINE OFF;
REM INSERTING into HOSS5825.CUSTOMER
SET DEFINE OFF;
REM INSERTING into HOSS5825.EMPLOYEE
SET DEFINE OFF;
REM INSERTING into HOSS5825.P1_ACCOUNT
SET DEFINE OFF;
REM INSERTING into HOSS5825.P2_ACCOUNT
SET DEFINE OFF;
REM INSERTING into HOSS5825.P3_ACCOUNT
SET DEFINE OFF;
REM INSERTING into HOSS5825.PRODUCE
SET DEFINE OFF;
REM INSERTING into HOSS5825.PRODUCT
SET DEFINE OFF;
REM INSERTING into HOSS5825.PRODUCT1
SET DEFINE OFF;
REM INSERTING into HOSS5825.PRODUCT2
SET DEFINE OFF;
REM INSERTING into HOSS5825.PRODUCT3
SET DEFINE OFF;
REM INSERTING into HOSS5825.PURCHASE
SET DEFINE OFF;
REM INSERTING into HOSS5825.QC_CHECK
SET DEFINE OFF;
REM INSERTING into HOSS5825.QC_STAFF
SET DEFINE OFF;
REM INSERTING into HOSS5825.REF_COMPLAIN
SET DEFINE OFF;
Insert into HOSS5825.REF_COMPLAIN (TREATMENT) values ('Exchange');
Insert into HOSS5825.REF_COMPLAIN (TREATMENT) values ('Money Back');
REM INSERTING into HOSS5825.REF_DEGREE
SET DEFINE OFF;
Insert into HOSS5825.REF_DEGREE (DEGREE) values ('BS');
Insert into HOSS5825.REF_DEGREE (DEGREE) values ('MS');
Insert into HOSS5825.REF_DEGREE (DEGREE) values ('PhD');
REM INSERTING into HOSS5825.REF_P1_SIZE
SET DEFINE OFF;
Insert into HOSS5825.REF_P1_SIZE (P1_SIZE) values ('Large');
Insert into HOSS5825.REF_P1_SIZE (P1_SIZE) values ('Medium');
Insert into HOSS5825.REF_P1_SIZE (P1_SIZE) values ('Small');
REM INSERTING into HOSS5825.REF_QC_TYPE
SET DEFINE OFF;
Insert into HOSS5825.REF_QC_TYPE (TYPE) values (1);
Insert into HOSS5825.REF_QC_TYPE (TYPE) values (2);
Insert into HOSS5825.REF_QC_TYPE (TYPE) values (3);
REM INSERTING into HOSS5825.TECH_STAFF
SET DEFINE OFF;
REM INSERTING into HOSS5825.WORKER
SET DEFINE OFF;
--------------------------------------------------------
--  DDL for Index ACCIDENT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."ACCIDENT_PK" ON "HOSS5825"."ACCIDENT" ("ACCIDENT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index ACCIDENT_RECORD_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."ACCIDENT_RECORD_PK" ON "HOSS5825"."ACCIDENT_RECORD" ("ACCIDENT_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index ACCOUNTS_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."ACCOUNTS_PK" ON "HOSS5825"."ACCOUNTS" ("ACC_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index COMPLAIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."COMPLAIN_PK" ON "HOSS5825"."COMPLAIN" ("COMP_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index COMPLAIN_LIST_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."COMPLAIN_LIST_PK" ON "HOSS5825"."COMPLAIN_LIST" ("COMP_ID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index CUSTOMER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."CUSTOMER_PK" ON "HOSS5825"."CUSTOMER" ("C_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index EMPLOYEES_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."EMPLOYEES_PK" ON "HOSS5825"."EMPLOYEE" ("NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P1_ACCOUNT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P1_ACCOUNT_PK" ON "HOSS5825"."P1_ACCOUNT" ("ACC_NO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P1_ACCOUNT_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P1_ACCOUNT_UK1" ON "HOSS5825"."P1_ACCOUNT" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P2_ACCOUNT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P2_ACCOUNT_PK" ON "HOSS5825"."P2_ACCOUNT" ("ACC_NO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P2_ACCOUNT_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P2_ACCOUNT_UK1" ON "HOSS5825"."P2_ACCOUNT" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P3_ACCOUNT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P3_ACCOUNT_PK" ON "HOSS5825"."P3_ACCOUNT" ("ACC_NO") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index P3_ACCOUNT_UK1
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."P3_ACCOUNT_UK1" ON "HOSS5825"."P3_ACCOUNT" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PRODUCE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PRODUCE_PK" ON "HOSS5825"."PRODUCE" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PRODUCT_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PRODUCT_PK" ON "HOSS5825"."PRODUCT" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PRODUCT1_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PRODUCT1_PK" ON "HOSS5825"."PRODUCT1" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PRODUCT2_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PRODUCT2_PK" ON "HOSS5825"."PRODUCT2" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PRODUCT3_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PRODUCT3_PK" ON "HOSS5825"."PRODUCT3" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index PURCHASE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."PURCHASE_PK" ON "HOSS5825"."PURCHASE" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index QC_CHECK_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."QC_CHECK_PK" ON "HOSS5825"."QC_CHECK" ("PID") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index QC_STAFF_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."QC_STAFF_PK" ON "HOSS5825"."QC_STAFF" ("E_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index REF_COMPLAIN_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."REF_COMPLAIN_PK" ON "HOSS5825"."REF_COMPLAIN" ("TREATMENT") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index REF_DEGREE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."REF_DEGREE_PK" ON "HOSS5825"."REF_DEGREE" ("DEGREE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index REF_P1_SIZE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."REF_P1_SIZE_PK" ON "HOSS5825"."REF_P1_SIZE" ("P1_SIZE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index REF_QC_TYPE_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."REF_QC_TYPE_PK" ON "HOSS5825"."REF_QC_TYPE" ("TYPE") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index TESCH_STAFF_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."TESCH_STAFF_PK" ON "HOSS5825"."TECH_STAFF" ("E_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  DDL for Index WORKER_PK
--------------------------------------------------------

  CREATE UNIQUE INDEX "HOSS5825"."WORKER_PK" ON "HOSS5825"."WORKER" ("E_NAME") 
  PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825" ;
--------------------------------------------------------
--  Constraints for Table ACCIDENT
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."ACCIDENT" ADD CONSTRAINT "ACCIDENT_PK" PRIMARY KEY ("ACCIDENT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."ACCIDENT" MODIFY ("ACCIDENT_ID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACCIDENT" MODIFY ("PID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ACCIDENT_RECORD
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."ACCIDENT_RECORD" ADD CONSTRAINT "ACCIDENT_RECORD_PK" PRIMARY KEY ("ACCIDENT_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."ACCIDENT_RECORD" MODIFY ("ACCIDENT_ID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACCIDENT_RECORD" MODIFY ("ACCIDENT_DATE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table ACCOUNTS
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."ACCOUNTS" ADD CONSTRAINT "ACCOUNTS_PK" PRIMARY KEY ("ACC_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."ACCOUNTS" MODIFY ("ACC_ID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACCOUNTS" MODIFY ("ACC_DATE" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."ACCOUNTS" MODIFY ("COST" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table COMPLAIN
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."COMPLAIN" ADD CONSTRAINT "COMPLAIN_PK" PRIMARY KEY ("COMP_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."COMPLAIN" MODIFY ("COMP_ID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."COMPLAIN" MODIFY ("P_ID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table COMPLAIN_LIST
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."COMPLAIN_LIST" ADD CONSTRAINT "COMPLAIN_LIST_PK" PRIMARY KEY ("COMP_ID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."COMPLAIN_LIST" MODIFY ("COMP_ID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."COMPLAIN_LIST" MODIFY ("COMP_DATE" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."COMPLAIN_LIST" MODIFY ("TREATMENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table CUSTOMER
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."CUSTOMER" ADD CONSTRAINT "CUSTOMER_PK" PRIMARY KEY ("C_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."CUSTOMER" MODIFY ("C_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table EMPLOYEE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."EMPLOYEE" ADD CONSTRAINT "EMPLOYEES_PK" PRIMARY KEY ("NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."EMPLOYEE" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table P1_ACCOUNT
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."P1_ACCOUNT" ADD CONSTRAINT "P1_ACCOUNT_PK" PRIMARY KEY ("ACC_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P1_ACCOUNT" ADD CONSTRAINT "P1_ACCOUNT_UK1" UNIQUE ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P1_ACCOUNT" MODIFY ("ACC_NO" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."P1_ACCOUNT" MODIFY ("PID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table P2_ACCOUNT
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."P2_ACCOUNT" ADD CONSTRAINT "P2_ACCOUNT_PK" PRIMARY KEY ("ACC_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P2_ACCOUNT" ADD CONSTRAINT "P2_ACCOUNT_UK1" UNIQUE ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P2_ACCOUNT" MODIFY ("ACC_NO" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."P2_ACCOUNT" MODIFY ("PID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table P3_ACCOUNT
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."P3_ACCOUNT" ADD CONSTRAINT "P3_ACCOUNT_PK" PRIMARY KEY ("ACC_NO")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P3_ACCOUNT" ADD CONSTRAINT "P3_ACCOUNT_UK1" UNIQUE ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."P3_ACCOUNT" MODIFY ("ACC_NO" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."P3_ACCOUNT" MODIFY ("PID" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PRODUCE" ADD CONSTRAINT "PRODUCE_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PRODUCE" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCE" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCT
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PRODUCT" ADD CONSTRAINT "PRODUCT_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PRODUCT" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT" MODIFY ("PRODUCER_NAME" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT" MODIFY ("QC_NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCT1
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PRODUCT1" ADD CONSTRAINT "PRODUCT1_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PRODUCT1" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT1" MODIFY ("P_SIZE" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT1" MODIFY ("SOFTWARE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCT2
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PRODUCT2" ADD CONSTRAINT "PRODUCT2_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PRODUCT2" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT2" MODIFY ("P_SIZE" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT2" MODIFY ("COLOR" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PRODUCT3
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PRODUCT3" ADD CONSTRAINT "PRODUCT3_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PRODUCT3" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT3" MODIFY ("P_SIZE" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PRODUCT3" MODIFY ("WEIGHT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table PURCHASE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."PURCHASE" ADD CONSTRAINT "PURCHASE_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."PURCHASE" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."PURCHASE" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table QC_CHECK
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."QC_CHECK" ADD CONSTRAINT "QC_CHECK_PK" PRIMARY KEY ("PID")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."QC_CHECK" MODIFY ("PID" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."QC_CHECK" MODIFY ("NAME" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table QC_STAFF
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."QC_STAFF" ADD CONSTRAINT "QC_STAFF_PK" PRIMARY KEY ("E_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."QC_STAFF" MODIFY ("E_NAME" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."QC_STAFF" MODIFY ("TYPE_CHECK" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REF_COMPLAIN
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."REF_COMPLAIN" ADD CONSTRAINT "REF_COMPLAIN_PK" PRIMARY KEY ("TREATMENT")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."REF_COMPLAIN" MODIFY ("TREATMENT" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REF_DEGREE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."REF_DEGREE" ADD CONSTRAINT "REF_DEGREE_PK" PRIMARY KEY ("DEGREE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."REF_DEGREE" MODIFY ("DEGREE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REF_P1_SIZE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."REF_P1_SIZE" ADD CONSTRAINT "REF_P1_SIZE_PK" PRIMARY KEY ("P1_SIZE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."REF_P1_SIZE" MODIFY ("P1_SIZE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table REF_QC_TYPE
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."REF_QC_TYPE" ADD CONSTRAINT "REF_QC_TYPE_PK" PRIMARY KEY ("TYPE")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
  ALTER TABLE "HOSS5825"."REF_QC_TYPE" MODIFY ("TYPE" NOT NULL ENABLE);
--------------------------------------------------------
--  Constraints for Table TECH_STAFF
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."TECH_STAFF" MODIFY ("E_NAME" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."TECH_STAFF" ADD CONSTRAINT "TECH_STAFF_PK" PRIMARY KEY ("E_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 COMPUTE STATISTICS 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;
--------------------------------------------------------
--  Constraints for Table WORKER
--------------------------------------------------------

  ALTER TABLE "HOSS5825"."WORKER" MODIFY ("E_NAME" NOT NULL ENABLE);
  ALTER TABLE "HOSS5825"."WORKER" ADD CONSTRAINT "WORKER_PK" PRIMARY KEY ("E_NAME")
  USING INDEX PCTFREE 10 INITRANS 2 MAXTRANS 255 
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "HOSS5825"  ENABLE;