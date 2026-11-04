-- Oracle SYSAUX Tablespace Component Analysis
-- Read-only diagnostic script

SET PAGESIZE 200
SET LINESIZE 180

COLUMN occupant_name FORMAT A35

SELECT occupant_name,
       ROUND(space_usage_kbytes/1024,2) used_mb
FROM v$sysaux_occupants
ORDER BY space_usage_kbytes DESC;
