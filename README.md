# Automated Sequence and Trigger Management in Oracle PL/SQL

## Overview

This project automates the creation and management of **sequence-trigger pairs** for all tables in an Oracle database schema. The sequences are set to start with the current maximum value of the primary key in each table (`max_id + 1`), ensuring seamless identity column functionality.

The solution dynamically drops and recreates sequences and triggers in a loop using PL/SQL. The logic considers various scenarios, including:
- Handling existing triggers and sequences.
- Ignoring tables with composite primary keys or non-numeric primary keys.

---

## Features

1. **Dynamic SQL Execution:** 
   - DDL statements are executed dynamically within PL/SQL blocks.

2. **Automated Sequence-Trigger Pair Management:**
   - Sequences and triggers are dropped and recreated dynamically for all valid tables in the schema.
   - Sequences start with `max_id + 1` of the primary key column.

3. **Validation Mechanism:** 
   - Composite or non-numeric primary keys are ignored.

4. **Reusable Functions and Procedures:**
   - Modularized code with helper functions and procedures for easy maintenance and debugging.

---

## Project Files

| **File Name**                | **Description**                                                                                  |
|------------------------------|--------------------------------------------------------------------------------------------------|
| `Anonymous_block.sql`        | Main PL/SQL script that performs the sequence and trigger creation in a loop for all tables.     |
| `Check_seq.sql`              | Validates the existence of a sequence in the schema.                                             |
| `get_max_id.sql`             | Returns the maximum ID value from the primary key column of a table.                            |
| `GET_SEQUENCE.sql`           | Retrieves the sequence name associated with a trigger.                                          |
| `GET_triggers.sql`           | Returns all triggers associated with a table.                                                   |
| `Validate_table_function.sql`| Validates whether a table has a numeric single-column primary key.                              |

---

## Installation and Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/MuhamedHekal/plsql-sequence-trigger-automation.git
2.	Connect to the Oracle database using your preferred client (e.g., SQL*Plus, SQL Developer).

3.	Run the provided .sql files in the following order to set up the necessary functions and procedures:
    ```
	1-  Validate_table_function.sql
	2-  Check_seq.sql
	3-  GET_triggers.sql
	4-  GET_SEQUENCE.sql
	5-  get_max_id.sql
4.	Execute Anonymous_block.sql to automate the creation and management of sequences and triggers.

---
## How It Works

1.	Cursor Iteration: The main script iterates over all tables in the schema using a cursor (user_tables).

2.	Table Validation: The VALIDATE_TABLE function ensures the table has a single numeric primary key.
3.	Trigger Management:
	- Existing triggers are retrieved and paired sequences are dropped using GET_triggers and GET_SEQUENCE.
4.	Sequence Management:
    - Checks for sequences using USER_SEQUENCES and drops them if found.
	- Creates new sequences starting at max_id + 1 using dynamic SQL.
5.	Trigger Creation:
	- A new trigger is created dynamically to auto-increment the primary key column using the sequence.
6.	Output Logging:
	- Outputs detailed logs to the console, including actions performed on each table.

---
## Example Execution Output
```
Table  : EMPLOYEES has trigger : EMPLOYEES_TRG
Trigger  : EMPLOYEES_TRG Paired with : EMPLOYEES_SEQ
Dropped sequence: EMPLOYEES_SEQ
----------------------------------------------------------
TABLE EMPLOYEES has maximum id: 102
----------------------------------------------------------
SEQUENCE EMPLOYEES_SEQ CREATED WITH START VALUE: 103
TRIGGER : EMPLOYEES_TGR CREATED ON TABLE EMPLOYEES AND PAIRED WITH : EMPLOYEES_SEQ
Now the EMP_ID column in the table EMPLOYEES acts as an identity column.
********************************************************************************************************************
```
------
## Key Assumptions and Constraints
- **Primary Key:** Only single numeric primary keys are supported. Composite and non-numeric keys are ignored.
- **Increment By:** All sequences are incremented by 1.
- **Schema-Specific:** The solution assumes sequences and triggers are being created for all tables in the same schema.

