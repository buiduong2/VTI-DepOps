#!/usr/bin/env bash
set -euo pipefail

HOSTNAME="homelab.local"
DOMAINS=(
  "chat.local.test"
  "auth.local.test"
  "chat-api.local.test"
)

START_MARKER="# BEGIN CHAT-SUPPORT"
END_MARKER="# END CHAT-SUPPORT"

# Phân giải IPv4 hiện tại của homelab
IP=$(getent ahostsv4 "$HOSTNAME" | awk 'NR == 1 {print $1}')

if [[ -z "$IP" ]]; then
  echo "Cannot resolve $HOSTNAME"
  exit 1
fi

echo "Resolved $HOSTNAME -> $IP"

# Sao lưu trước khi chỉnh sửa
sudo cp /etc/hosts /etc/hosts.bak

# Tạo bản cập nhật, loại bỏ block cũ nếu có
TMP_FILE=$(mktemp)
trap 'rm -f "$TMP_FILE"' EXIT

sudo awk -v start="$START_MARKER" -v end="$END_MARKER" '
  $0 == start { skip = 1; next }
  $0 == end { skip = 0; next }
  !skip { print }
' /etc/hosts > "$TMP_FILE"

{
  echo "$START_MARKER"
  for domain in "${DOMAINS[@]}"; do
    echo "$IP $domain"
  done
  echo "$END_MARKER"
} >> "$TMP_FILE"

sudo cp "$TMP_FILE" /etc/hosts

echo "Updated /etc/hosts successfully"
