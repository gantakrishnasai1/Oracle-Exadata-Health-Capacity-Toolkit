-- ASM disk state and failure-group distribution
-- Connect to the ASM instance.
SET PAGESIZE 300
SET LINESIZE 240
SET TRIMSPOOL ON
COLUMN diskgroup_name FORMAT A20
COLUMN failgroup FORMAT A35
COLUMN mount_status FORMAT A14
COLUMN header_status FORMAT A14
COLUMN mode_status FORMAT A12
COLUMN state FORMAT A12

PROMPT === DISK STATUS COUNTS ===
SELECT g.name diskgroup_name,
       d.mount_status,
       d.header_status,
       d.mode_status,
       d.state,
       COUNT(*) disk_count
FROM v$asm_disk_stat d
JOIN v$asm_diskgroup_stat g
  ON g.group_number = d.group_number
GROUP BY g.name, d.mount_status, d.header_status,
         d.mode_status, d.state
ORDER BY g.name, d.mount_status, d.header_status, d.state;

PROMPT === FAILURE GROUP CAPACITY DISTRIBUTION ===
SELECT g.name diskgroup_name,
       d.failgroup,
       d.mount_status,
       d.header_status,
       d.mode_status,
       d.state,
       COUNT(*) disk_count,
       ROUND(SUM(d.total_mb)/1024, 2) total_gb,
       ROUND(SUM(d.free_mb)/1024, 2) free_gb
FROM v$asm_disk_stat d
JOIN v$asm_diskgroup_stat g
  ON g.group_number = d.group_number
GROUP BY g.name, d.failgroup, d.mount_status,
         d.header_status, d.mode_status, d.state
ORDER BY g.name, d.failgroup;
