-- ASM Quorum Disk Health Assessment
-- Read-only diagnostic script

SET PAGESIZE 200
SET LINESIZE 220

COLUMN diskgroup_name FORMAT A18
COLUMN disk_name FORMAT A30
COLUMN failgroup FORMAT A25
COLUMN path FORMAT A65
COLUMN header_status FORMAT A15
COLUMN mode_status FORMAT A12
COLUMN state FORMAT A12

SELECT g.name diskgroup_name,
       d.name disk_name,
       d.failgroup,
       d.path,
       d.header_status,
       d.mode_status,
       d.state,
       d.total_mb,
       d.free_mb
FROM v$asm_disk d
JOIN v$asm_diskgroup g
  ON g.group_number = d.group_number
WHERE d.failgroup LIKE 'PROD_SVJUR%'
ORDER BY g.name, d.failgroup;
