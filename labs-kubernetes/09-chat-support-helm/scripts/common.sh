
#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

NAMESPACE="${NAMESPACE:-default}"
EXPECTED_CONTEXT="${EXPECTED_CONTEXT:-kind-chat-support}"

log() {
  printf '\n==> %s\n' "$1"
}

fail() {
  echo "ERROR: $*" >&2
  exit 1
}

require_file() {
  [[ -f "$ROOT_DIR/$1" ]] || fail "Missing file: $1"
}

require_command() {
  command -v "$1" >/dev/null 2>&1 ||
    fail "Command not found: $1"
}
