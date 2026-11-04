# Oracle Exadata Health & Capacity Assessment Toolkit

A practical, read-only starter toolkit for collecting health and capacity indicators from Oracle Database, RAC, ASM, Grid Infrastructure, and Exadata storage cells.

> **Scope:** This toolkit collects diagnostic information. It does not change database, ASM, Grid Infrastructure, or cell configuration. Review every command and obtain operational approval before running it in production.

## Contents

| Path | Purpose |
|---|---|
| `sql/database_health.sql` | Database role, open mode, RAC instance state, invalid objects, tablespace capacity |
| `sql/asm_capacity.sql` | ASM disk group capacity and offline disk counts |
| `sql/asm_disk_health.sql` | ASM disk status and failure-group distribution |
| `sql/asm_operations.sql` | Current ASM operations/rebalance status |
| `scripts/collect_grid.sh` | Collects CRS, resource, and ASM command-line status |
| `scripts/collect_cell.sh` | Optional ExaCLI cell alert and cell status collection |
| `docs/assessment-template.md` | Standardized assessment report template |

## Requirements

- Oracle Database 19c or later (queries may need adjustment for other releases).
- SQL*Plus access with privileges to read the referenced dynamic performance and DBA views.
- For ASM SQL scripts: connect to the ASM instance with an appropriately privileged account.
- For Grid collection: run as the Grid Infrastructure owner or another account authorized to execute the listed `crsctl` and `asmcmd` commands.
- For cell collection: ExaCLI configured and authorized for the target cell. Cell commands are optional.

## Quick start

### 1. Database checks

Connect to the database as a suitably privileged read-only diagnostic account (or an approved DBA account), then run:

```bash
sqlplus -L / as sysdba @sql/database_health.sql
```

If using a non-local connection, use your organization's approved secure authentication method. Do not place passwords in scripts or command history.

### 2. ASM checks

Connect to the ASM instance, then run:

```bash
sqlplus -L / as sysasm @sql/asm_capacity.sql
sqlplus -L / as sysasm @sql/asm_disk_health.sql
sqlplus -L / as sysasm @sql/asm_operations.sql
```

### 3. Grid Infrastructure collection

Run from a Grid Infrastructure node:

```bash
chmod 750 scripts/collect_grid.sh
./scripts/collect_grid.sh
```

The script creates a timestamped output directory in the current working directory. Run it on each cluster node if node-local comparison is required.

### 4. Optional Exadata cell collection

Configure ExaCLI authentication according to Oracle's security guidance, then:

```bash
chmod 750 scripts/collect_cell.sh
./scripts/collect_cell.sh cell01.example.com
```

The script uses ExaCLI and saves command output. If your ExaCLI version or cell policy uses different command syntax, validate the commands manually and adjust the script.

## Interpreting results safely

- `USABLE_FILE_MB` is the ASM-reported usable capacity after redundancy considerations; do not use raw free space alone to make capacity decisions.
- A zero `REQUIRED_MIRROR_FREE_MB` value is not, by itself, proof that a disk group has no redundancy risk.
- `V$ASM_DISK` status values should be interpreted with disk group redundancy, failure groups, and the Exadata storage layout.
- An empty `GV$ASM_OPERATION` result means no operation was visible at collection time; it does not prove that a previous rebalance completed successfully.
- A database datafile or tablespace nearing capacity needs investigation of autoextend, max size, free extents, and storage headroom before action.
- Do not resize, drop, rebalance, or alter resources based solely on this report.

## Security and operational safeguards

- The SQL files are intended for read-only collection; they contain no DDL or DML.
- Run with least privilege and follow change-management procedures.
- Protect output files: they can contain hostnames, database names, storage identifiers, and infrastructure details.
- Sanitize outputs before publishing examples or attaching them to public contributions.
- Never commit credentials, wallet files, TNS secrets, customer identifiers, IP addresses, or production output.

## Suggested validation

Test in a non-production environment first. Compare the output with OEM, `crsctl`, `asmcmd`, ExaCLI, and the relevant Oracle documentation for your platform and release. Record the tested database version, Exadata generation, and tool versions in your assessment.

## Contribution

Issues and pull requests are welcome. Include the Oracle Database version, Grid Infrastructure version, Exadata generation, and sanitized error output when reporting a compatibility issue.
