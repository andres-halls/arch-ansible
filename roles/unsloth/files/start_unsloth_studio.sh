#!/bin/bash

INSTANCE="${1:-}"

if [[ -z "$INSTANCE" ]]; then
  exec unsloth studio -H 0.0.0.0 -p 8888
  exit 0
fi

ARGS_FILE="/etc/unsloth/${INSTANCE}.conf"

if [[ ! -f "$ARGS_FILE" ]]; then
  echo "File not found: $ARGS_FILE" >&2
  exit 1
fi

mapfile -t args < "$ARGS_FILE"
exec unsloth studio run -H 0.0.0.0 -p 8888 ${args[@]}
