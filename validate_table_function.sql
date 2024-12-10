CREATE OR REPLACE FUNCTION VALIDATE_TABLE(pk_col_name OUT VARCHAR2, P_TABLE_NAME VARCHAR2)
RETURN BOOLEAN
IS
    number_of_pk_col number(2);
    pk_dt VARCHAR2(20);
    --pk_col_name VARCHAR2(30);

BEGIN

    SELECT count(1)
    INTO number_of_pk_col
    FROM ALL_CONS_COLUMNS
    WHERE TABLE_NAME = P_TABLE_NAME AND CONSTRAINT_NAME LIKE '%_PK';
    IF number_of_pk_col > 1 THEN 
        return FALSE ;
    END IF;

     -- Get the primary key column name
    SELECT COLUMN_NAME
    INTO pk_col_name
    FROM ALL_CONS_COLUMNS
    WHERE TABLE_NAME = P_TABLE_NAME AND CONSTRAINT_NAME LIKE '%_PK';
    

    -- Get the datatype of the primary key column
    SELECT DATA_TYPE
    INTO pk_dt
    FROM USER_TAB_COLS
    WHERE TABLE_NAME = P_TABLE_NAME AND COLUMN_NAME = pk_col_name;
    IF pk_dt = 'NUMBER' THEN 
        return TRUE ;
    ELSE
        RETURN FALSE;
    END IF;

    return TRUE;
   
END;


SELECT TABLE_NAME, VALIDATE_TABLE(TABLE_NAME)
from USER_TABLES;
