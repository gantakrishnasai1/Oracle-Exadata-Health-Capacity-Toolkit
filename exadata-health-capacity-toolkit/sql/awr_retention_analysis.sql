-- Oracle AWR Retention and Snapshot Analysis
-- Oracle Database 19c
-- Read-only diagnostic script

SET PAGESIZE 200
SET LINESIZE 220
SET TRIMSPOOL ON
SET VERIFY OFF
COLUMN snap_interval FORMAT A25
COLUMN retention FORMAT A25
COLUMN topnsql FORMAT A15

PROMPT === AWR CONFIGURATION ===

SELECT dbid,
       snap_interval,
       retention,
       topnsql
FROM dba_hist_wr_control;

PROMPT === SNAPSHOT HISTORY BY DBID AND INSTANCE ===

SELECT dbid,
       instance_number,
       COUNT(*) snapshot_count,
       MIN(begin_interval_time) oldest_snapshot,
       MAX(end_interval_time) latest_snapshot
FROM dba_hist_snapshot
GROUP BY dbid, instance_number
ORDER BY dbid, instance_number;

PROMPT === DATABASE INCARNATION HISTORY ===

SELECT incarnation#,
       resetlogs_time,
       resetlogs_change#,
       prior_resetlogs_time,
       status
FROM v$database_incarnation
ORDER BY incarnation#;

PROMPT === SYSAUX AWR SPACE USAGE ===

SELECT occupant_name,
       ROUND(space_usage_kbytes/1024,2) used_mb
FROM v$sysaux_occupants
WHERE occupant_name LIKE '%AWR%'
ORDER BY used_mb DESC;

PROMPT === END AWR ANALYSIS ===
