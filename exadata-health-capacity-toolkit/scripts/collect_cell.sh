#!/usr/bin/env bash
# Optional, read-only ExaCLI collection for one storage cell.
# ExaCLI authentication must already be configured securely.
set -u

CELL="${1:-}"
if [[ -z "$CELL" ]]; then
  echo "Usage: $0 <cell-hostname>"
  exit 2
fi

STAMP="$(date '+%Y%m%d_%H%M%S')"
OUTDIR="./exadata_cell_${CELL}_${STAMP}"
mkdir -p "$OUTDIR" || exit 1
STATUS_FILE="$OUTDIR/collection_status.txt"
: > "$STATUS_FILE"

run_exacli() {
  local name="$1"
  shift
  echo "Collecting: $name"
  if exacli -c "$CELL" "$@" >"$OUTDIR/${name}.txt" 2>&1; then
    printf '%s: OK\n' "$name" >>"$STATUS_FILE"
  else
    rc=$?
    printf '%s: FAILED (exit %s)\n' "$name" "$rc" >>"$STATUS_FILE"
  fi
}

echo "Cell: $CELL" > "$OUTDIR/cell_info.txt"
echo "Collected: $(date)" >> "$OUTDIR/cell_info.txt"

# Validate command availability and syntax against the installed ExaCLI release.
run_exacli cell_attributes list cell attributes
run_exacli cell_alert_history list alerthistory
run_exacli cell_physical_disks list physicaldisk
run_exacli cell_luns list lun

echo "Collection completed. Output: $OUTDIR"
echo "Review $STATUS_FILE; unsupported commands may need release-specific adjustment."
