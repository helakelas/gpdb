--
-- boolean.source
--
-- $Header: /cvsroot/pgsql/src/test/regress/sql/boolean.sql,v 1.5 1997/12/01 02:45:59 thomas Exp $
--

--
-- sanity check - if this fails go insane!
--
SELECT 1 AS one;


-- ******************testing built-in type bool********************

-- check bool type-casting as well as and, or, not in qualifications--

SELECT 't'::bool AS true;

SELECT 'f'::bool AS false;

SELECT 't'::bool or 'f'::bool AS true;

SELECT 't'::bool and 'f'::bool AS false;

SELECT not 'f'::bool AS true;

SELECT 't'::bool = 'f'::bool AS false;

SELECT 't'::bool <> 'f'::bool AS true;


CREATE TABLE BOOLTBL1 (f1 bool);

INSERT INTO BOOLTBL1 (f1) VALUES ('t'::bool);

INSERT INTO BOOLTBL1 (f1) VALUES ('True'::bool);

INSERT INTO BOOLTBL1 (f1) VALUES ('true'::bool);


-- BOOLTBL1 should be full of true's at this point 
SELECT '' AS t_3, BOOLTBL1.*;


SELECT '' AS t_3, BOOLTBL1.*
   FROM BOOLTBL1
   WHERE f1 = 'true'::bool;


SELECT '' AS t_3, BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 <> 'false'::bool;

SELECT '' AS zero, BOOLTBL1.*
   FROM BOOLTBL1
   WHERE booleq('false'::bool, f1);

INSERT INTO BOOLTBL1 (f1) VALUES ('f'::bool);

SELECT '' AS f_1, BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 = 'false'::bool;


CREATE TABLE BOOLTBL2 (f1 bool);

INSERT INTO BOOLTBL2 (f1) VALUES ('f'::bool);

INSERT INTO BOOLTBL2 (f1) VALUES ('false'::bool);

INSERT INTO BOOLTBL2 (f1) VALUES ('False'::bool);

INSERT INTO BOOLTBL2 (f1) VALUES ('FALSE'::bool);

-- This is now an invalid expression
-- For pre-v6.3 this evaluated to false - thomas 1997-10-23
INSERT INTO BOOLTBL2 (f1) 
   VALUES ('XXX'::bool);  

-- BOOLTBL2 should be full of false's at this point 
SELECT '' AS f_4, BOOLTBL2.*;


SELECT '' AS tf_12, BOOLTBL1.*, BOOLTBL2.*
   WHERE BOOLTBL2.f1 <> BOOLTBL1.f1;


SELECT '' AS tf_12, BOOLTBL1.*, BOOLTBL2.*
   WHERE boolne(BOOLTBL2.f1,BOOLTBL1.f1);


SELECT '' AS ff_4, BOOLTBL1.*, BOOLTBL2.*
   WHERE BOOLTBL2.f1 = BOOLTBL1.f1 and BOOLTBL1.f1 = 'false'::bool;


SELECT '' AS tf_12_ff_4, BOOLTBL1.*, BOOLTBL2.*
   WHERE BOOLTBL2.f1 = BOOLTBL1.f1 or BOOLTBL1.f1 = 'true'::bool
   ORDER BY BOOLTBL1.f1, BOOLTBL2.f1;

--
-- SQL92 syntax - thomas 1997-11-30
--

SELECT '' AS "True", BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 IS TRUE;

SELECT '' AS "Not False", BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 IS NOT FALSE;

SELECT '' AS "False", BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 IS FALSE;

SELECT '' AS "Not True", BOOLTBL1.* 
   FROM BOOLTBL1
   WHERE f1 IS NOT TRUE;

--
-- Clean up
-- Many tables are retained by the regression test, but these do not seem
--  particularly useful so just get rid of them for now.
--  - thomas 1997-11-30
--

DROP TABLE  BOOLTBL1;

DROP TABLE  BOOLTBL2;
