#!/usr/bin/env bash
set -euo pipefail

INPUT="$(cat)"
COMMAND="$(printf '%s' "$INPUT" | jq -r '.tool_input.command // ""')"

if [[ "$COMMAND" =~ (^|[[:space:]])git[[:space:]]+commit([[:space:]]|$) ]] || \
   [[ "$COMMAND" =~ (^|[[:space:]])git[[:space:]]+push([[:space:]]|$) ]] || \
   [[ "$COMMAND" =~ (^|[[:space:]])migrate([[:space:]]|$) ]] || \
   [[ "$COMMAND" =~ db:migrate ]] || \
   [[ "$COMMAND" =~ prisma:migrate ]]; then
  jq -n '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: "commit, push e migrate estao bloqueados."
    }
  }'
else
  exit 0
fi
