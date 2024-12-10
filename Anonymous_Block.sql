SET SERVEROUTPUT ON;
DECLARE
    CURSOR get_tables_cursor IS
        SELECT TABLE_NAME
        FROM user_tables;
        
    is_table_valid BOOLEAN ; 
    triggers Table_Triggers;
    trigger_sequence VARCHAR2(50);
    PK_col_name varchar(20);
    max_id number(10);
    TGR_sql VARCHAR2(5000);
    SEQ_sql VARCHAR2(2000);
BEGIN
    FOR table_rec IN get_tables_cursor LOOP 

    is_table_valid:= VALIDATE_TABLE(PK_col_name, table_rec.Table_name);
        IF is_table_valid = TRUE THEN
            -- drop any sequence paired with trigger for making identity primary key column
            triggers := GET_TRIGGERS(table_rec.Table_name);
            FOR i IN 1 .. triggers.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE('Table  : ' || table_rec.TABLE_NAME || ' has trigger : ' || triggers(i));
                trigger_sequence:= GET_SEQ(triggers(i));
                IF trigger_sequence is not NULL then 
                    DBMS_OUTPUT.PUT_LINE('Trigger  : ' || triggers(i)  || ' Paired with : ' || trigger_sequence);
                    EXECUTE IMMEDIATE 'DROP SEQUENCE ' || trigger_sequence;
                    DBMS_OUTPUT.PUT_LINE('Dropped sequence: '|| trigger_sequence);
                    DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
                END IF;
            END LOOP;
            -- Set sequence to start with max id + 1
            max_id := GET_MAX_ID(PK_col_name,table_rec.Table_name);
            DBMS_OUTPUT.PUT_LINE('TABLE ' || table_rec.TABLE_NAME || ' has maximum id: ' || max_id);
            DBMS_OUTPUT.PUT_LINE('----------------------------------------------------------');
            
            -- drop any sequence with the name [table_name]_SEQ before craation 
            -- these sequence does not paired with any triggers we drooped the paired trgr_seq earlier
            FOR SEQ IN (SELECT SEQUENCE_NAME 
                        FROM USER_SEQUENCES 
                        WHERE SEQUENCE_NAME = UPPER(table_rec.TABLE_NAME||'_SEQ')) LOOP

                EXECUTE IMMEDIATE 'DROP SEQUENCE ' ||table_rec.TABLE_NAME || '_SEQ';
                DBMS_OUTPUT.PUT_LINE('Dropped sequence: ' || SEQ.SEQUENCE_NAME);
                END LOOP;


            -- Create the sequence
            SEQ_sql := 'CREATE SEQUENCE HR.' || table_rec.TABLE_NAME || '_SEQ ' ||
                        'START WITH ' || (max_id + 1) || ' ' ||
                        'MAXVALUE 999999999999999999999999999 ' ||
                        'NOCYCLE CACHE 20';
            EXECUTE IMMEDIATE SEQ_sql;
            DBMS_OUTPUT.PUT_LINE('SEQUENCE ' || table_rec.TABLE_NAME || '_SEQ CREATED WITH START VALUE: ' || (max_id + 1));

             -- Create the trigger
            TGR_sql := 'CREATE OR REPLACE TRIGGER HR.' || table_rec.TABLE_NAME || '_TGR ' ||
                        'BEFORE INSERT ON HR.' || table_rec.TABLE_NAME || ' ' ||
                        'REFERENCING NEW AS New OLD AS Old ' ||
                        'FOR EACH ROW BEGIN ' ||
                        ':new.' || PK_col_name || ' := ' || table_rec.TABLE_NAME || '_SEQ.NEXTVAL; END;';
            EXECUTE IMMEDIATE TGR_sql;
            DBMS_OUTPUT.PUT_LINE('TRIGGER : ' || table_rec.TABLE_NAME || '_TGR CREATED ON TABLE ' || table_rec.TABLE_NAME || ' AND PAIRED WITH : '||table_rec.TABLE_NAME || '_SEQ');
            
            DBMS_OUTPUT.PUT_LINE('Now the ' || PK_col_name || ' column in the table ' || table_rec.TABLE_NAME || ' acts as an identity column.');
            DBMS_OUTPUT.PUT_LINE('********************************************************************************************************************');
          



        ELSE 
            DBMS_OUTPUT.PUT_LINE('Invalid Table : ' || table_rec.TABLE_NAME);
            DBMS_OUTPUT.PUT_LINE('COMPOSITE PK OR NOT NUMBER PK');
            DBMS_OUTPUT.PUT_LINE('********************************************************************************************************************');
        END IF;
    END LOOP;
END;