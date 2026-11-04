-- ASM disk group capacity snapshot
-- Connect to the ASM instance using an appropriately privileged account.
SET PAGESIZE 200
SET LINESIZE 220
SET TRIMSPOOL ON
COLUMN name FORMAT A20
COLUMN type FORMAT A12
COLUMN state FORMAT A12

SELECT name,
       state,
       type,
       ROUND(total_mb/1024, 2) total_gb,
       ROUND(free_mb/1024, 2) raw_free_gb,
       ROUND(required_mirror_free_mb/1024, 2) required_mirror_free_gb,
       ROUND(usable_file_mb/1024, 2) usable_file_gb,
       offline_disks
FROM v$asm_diskgroup_stat
ORDER BY name;
