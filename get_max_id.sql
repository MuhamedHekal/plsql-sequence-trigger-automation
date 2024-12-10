CREATE OR REPLACE FUNCTION GET_MAX_ID(P_pk_col VARCHAR2 , table_name VARCHAR2)
return NUMBER
IS

    max_id number(10);
BEGIN
        EXECUTE IMMEDIATE 'SELECT MAX(' || P_pk_col || ') FROM ' || table_name
        INTO max_id;
        RETURN max_id;
END;


SELECT GET_MAX('Employee_id','EMPLOYEES')
from dual;