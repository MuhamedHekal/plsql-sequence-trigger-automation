CREATE OR REPLACE TYPE Table_Triggers AS TABLE OF varchar2(255);
/
CREATE OR REPLACE FUNCTION GET_TRIGGERS(P_TABLE_NAME VARCHAR2)
RETURN Table_Triggers
IS
   
    trigger_list Table_Triggers := Table_Triggers();

BEGIN

    SELECT TRIGGER_NAME
    BULK COLLECT INTO trigger_list
    FROM USER_TRIGGERS
    WHERE TABLE_NAME = P_TABLE_NAME;
    return trigger_list;
END;
/


DECLARE
    result Table_Triggers;
BEGIN
    result := GET_TRIGGERS('EMPLOYEES');
    FOR i IN 1 .. result.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Value ' || i || ': ' || result(i));
    END LOOP;
END;