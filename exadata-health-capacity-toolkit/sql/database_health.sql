-- Oracle Database / RAC health snapshot
-- Read-only. Run connected to the database with appropriate catalog privileges.
SET PAGESIZE 200
SET LINESIZE 240
SET TRIMSPOOL ON
SET FEEDBACK ON
SET VERIFY OFF
SET TAB OFF

COLUMN name FORMAT A18
COLUMN db_unique_name FORMAT A30
COLUMN database_role FORMAT A18
COLUMN open_mode FORMAT A18
COLUMN instance_name FORMAT A18
COLUMN host_name FORMAT A35
COLUMN status FORMAT A12
COLUMN database_status FORMAT A18
COLUMN tablespace_name FORMAT A28

PROMPT === DATABASE ===
SELECT name, db_unique_name, database_role, open_mode, log_mode, cdb
FROM v$database;

PROMPT === RAC INSTANCES ===
SELECT inst_id, instance_name, host_name, version, status,
       database_status, active_state
FROM gv$instance
ORDER BY inst_id;

PROMPT === INVALID NON-SYSTEM OBJECTS ===
SELECT owner, object_type, COUNT(*) AS invalid_count
FROM dba_objects
WHERE status = 'INVALID'
  AND owner NOT IN ('SYS', 'SYSTEM')
GROUP BY owner, object_type
ORDER BY owner, object_type;

PROMPT === PERMANENT TABLESPACE CAPACITY ===
SELECT df.tablespace_name,
       ROUND(df.total_mb, 2) total_mb,
       ROUND(NVL(fs.free_mb, 0), 2) free_mb,
       ROUND(df.total_mb - NVL(fs.free_mb, 0), 2) used_mb,
       ROUND(100 * (df.total_mb - NVL(fs.free_mb, 0)) /
             NULLIF(df.total_mb, 0), 2) used_pct
FROM ( SELECT tablespace_name, SUM(bytes)/1024/1024 total_mb
       FROM dba_data_files GROUP BY tablespace_name ) df
LEFT JOIN
     ( SELECT tablespace_name, SUM(bytes)/1024/1024 free_mb
       FROM dba_free_space GROUP BY tablespace_name ) fs
ON fs.tablespace_name = df.tablespace_name
ORDER BY used_pct DESC NULLS LAST;

PROMPT === DATAFILE AUTOEXTEND / MAX SIZE ===
SELECT tablespace_name, file_id, file_name,
       autoextensible,
       ROUND(bytes/1024/1024) current_mb,
       ROUND(maxbytes/1024/1024) max_mb
FROM dba_data_files
ORDER BY tablespace_name, file_id;

PROMPT === END DATABASE HEALTH ===
