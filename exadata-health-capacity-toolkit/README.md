# Oracle Exadata Health & Capacity Assessment Toolkit

A read-only diagnostic toolkit for assessing Oracle Exadata environments, covering Oracle Database, RAC, ASM, Grid Infrastructure, AWR, and storage capacity.

The toolkit provides SQL and shell scripts to collect health indicators, identify potential risks, analyze storage utilization, and support proactive database administration.

## Objectives

- Assess Oracle Database and RAC health.
- Monitor ASM disk group capacity and disk status.
- Analyze ASM failure groups and quorum disks.
- Review ASM rebalance operations.
- Analyze AWR retention and snapshot history.
- Identify SYSAUX component space consumption.
- Collect Grid Infrastructure and Exadata cell information.

## Repository Structure

```text
Oracle-Exadata-Health-Capacity-Toolkit/
│
├── docs/
│   └── assessment-template.md
│
├── scripts/
│   ├── collect_cell.sh
│   └── collect_grid.sh
│
├── sql/
│   ├── database_health.sql
│   ├── asm_capacity.sql
│   ├── asm_disk_health.sql
│   ├── asm_operations.sql
│   ├── asm_quorum_disk_health.sql
│   ├── awr_retention_analysis.sql
│   └── sysaux_analysis.sql
│
├── .gitignore
└── README.md
```

## SQL Modules

| Script | Description |
|---|---|
| database_health.sql | Database role, RAC instance status, invalid objects, tablespace capacity and datafile autoextend |
| asm_capacity.sql | ASM disk group capacity, redundancy and usable free space |
| asm_disk_health.sql | ASM disk status and failure-group distribution |
| asm_operations.sql | Current ASM operations and rebalance monitoring |
| asm_quorum_disk_health.sql | ASM quorum disk membership and health |
| awr_retention_analysis.sql | AWR retention, snapshot history and database incarnation analysis |
| sysaux_analysis.sql | SYSAUX component space consumption |

## Shell Scripts

- **collect_grid.sh** – Collects Grid Infrastructure cluster status, CRS resources and ASM information.
- **collect_cell.sh** – Optional ExaCLI-based storage cell information collection.

## Requirements

- Oracle Database 19c or later.
- Oracle RAC / ASM environment for cluster and storage checks.
- SQL*Plus access with appropriate diagnostic privileges.
- Grid Infrastructure access for shell-based collection.
- ExaCLI access for optional storage cell collection.

## Execution

Connect to the database:

```bash
sqlplus / as sysdba
```

Execute database health checks:

```sql
@sql/database_health.sql
```

Connect to ASM:

```bash
sqlplus / as sysasm
```

Execute ASM checks:

```sql
@sql/asm_capacity.sql
@sql/asm_disk_health.sql
@sql/asm_operations.sql
@sql/asm_quorum_disk_health.sql
```

Execute AWR and SYSAUX checks from an appropriately privileged database connection:

```sql
@sql/awr_retention_analysis.sql
@sql/sysaux_analysis.sql
```

For Grid Infrastructure collection:

```bash
chmod 750 scripts/collect_grid.sh
./scripts/collect_grid.sh
```

For optional storage cell collection:

```bash
chmod 750 scripts/collect_cell.sh
./scripts/collect_cell.sh cell01.example.com
```

Validate ExaCLI command compatibility with your installed release before execution.

## Validation Environment

Initial validation performed in:

- Oracle Database: 19c
- Platform: Oracle Exadata Cloud Service
- Architecture: 4-node RAC
- ASM redundancy: HIGH
- Disk groups: DATAC2 and RECOC2

Validated areas include database status, RAC instances, ASM capacity, disk health, failure-group distribution, quorum disks, ASM operations, AWR history and SYSAUX usage.

## Safety and Best Practices

- Scripts are intended for read-only diagnostic collection.
- Use appropriately privileged accounts.
- Validate scripts in non-production environments before production execution.
- Do not perform storage resizing, disk removal, ASM rebalance or AWR cleanup based solely on collected output.
- Sanitize all collected information before sharing publicly.
- Never publish production credentials, wallet files, hostnames, IP addresses or sensitive database information.

## Future Enhancements

- Exadata storage cell health and alert analysis.
- Physical disk and grid disk monitoring.
- Flash cache health assessment.
- Capacity trend analysis.
- Automated health scoring.
- Consolidated assessment reports.

## Contributions

Suggestions, improvements and contributions are welcome. Please include sanitized error messages and relevant Oracle version details when reporting issues.
