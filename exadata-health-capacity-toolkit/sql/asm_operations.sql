-- Current ASM operations (including rebalance activity)
-- Connect to the ASM instance.
SET PAGESIZE 200
SET LINESIZE 220
SET TRIMSPOOL ON
COLUMN operation FORMAT A16
COLUMN pass FORMAT A12
COLUMN state FORMAT A12
COLUMN error_code FORMAT A20

SELECT inst_id, group_number, operation, pass, state,
       power, actual, sofar, est_work, est_rate,
       est_minutes, error_code
FROM gv$asm_operation
ORDER BY inst_id, group_number;
