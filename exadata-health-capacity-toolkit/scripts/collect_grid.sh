#!/usr/bin/env bash
# Read-only Grid Infrastructure status collection.
set -u

HOST="$(hostname -s 2>/dev/null || hostname)"
STAMP="$(date '+%Y%m%d_%H%M%S')"
OUTDIR="${1:-./exadata_grid_${HOST}_${STAMP}}"

if ! mkdir -p "$OUTDIR"; then
  echo "ERROR: Cannot create output directory: $OUTDIR" >&2
  exit 1
fi

STATUS_FILE="$OUTDIR/collection_status.txt"
: > "$STATUS_FILE"

run_check() {
  local name="$1"
  shift
  echo "Collecting: $name"
  if "$@" >"$OUTDIR/${name}.txt" 2>&1; then
    printf '%s: OK\n' "$name" >>"$STATUS_FILE"
  else
    rc=$?
    printf '%s: FAILED (exit %s)\n' "$name" "$rc" >>"$STATUS_FILE"
  fi
}

{
  echo "Host: $HOST"
  echo "Collected: $(date -Is 2>/dev/null || date)"
  echo "User: $(id)"
} > "$OUTDIR/host_info.txt"

run_check crs_check crsctl check cluster -all
run_check cluster_resources crsctl status resource -t
run_check asm_diskgroups asmcmd lsdg
run_check asm_clients asmcmd lsct

echo "Collection completed. Output: $OUTDIR"
echo "Review $STATUS_FILE for command status."
