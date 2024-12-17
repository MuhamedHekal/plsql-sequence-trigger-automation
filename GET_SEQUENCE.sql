CREATE OR REPLACE FUNCTION GET_SEQ(P_TRIGGER_NAME VARCHAR2)
RETURN VARCHAR2
IS
    v_sequence_name VARCHAR2(50);
BEGIN

    SELECT REGEXP_SUBSTR(UPPER(TEXT), '[A-Z0-9_]+\.NEXTVAL', 1, 1)
    INTO v_sequence_name
    FROM USER_SOURCE
    WHERE NAME = P_TRIGGER_NAME
    AND UPPER(TEXT) LIKE '%.NEXTVAL%';
    IF v_sequence_name IS NOT NULL THEN
        v_sequence_name := REGEXP_SUBSTR(v_sequence_name, '[A-Z0-9_]+', 1, 1);
        select SEQUENCE_NAME
        into v_sequence_name
        from user_sequences
        where SEQUENCE_NAME = v_sequence_name;
        IF v_sequence_name IS NOT NULL then
            RETURN v_sequence_name;
        ELSE
            return '';
        END if;
    END IF ;
    EXCEPTION
        when NO_DATA_FOUND then
            DBMS_OUTPUT.PUT_LINE('NO Sequence exist for trigger :' || P_TRIGGER_NAME);
            RETURN '';
END;
/


DECLARE
    result VARCHAR2(20);
BEGIN
    result:= GET_SEQ('SECURE_EMPLOYEES');
    DBMS_OUTPUT.PUT_LINE('the seq is ' || result);
END;
