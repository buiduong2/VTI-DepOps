#!/bin/bash
set -euo pipefail

## Cài đặt các package cần thiết
yum install -y nginx wget unzip

# Tải cài đặt source code
mkdir -p /tmp/quiz-game-source
cd /tmp/quiz-game-source

wget -O source.zip \
  https://github.com/buiduong2/F8-Javascript/archive/refs/heads/master.zip

unzip source.zip

# Triển khai website
mkdir -p /var/www/quiz-game
cp -r F8-Javascript-master/lession41/. /var/www/quiz-game/

# Xóa sourcode tạm
cd /
rm -rf /tmp/quiz-game-source

# Tạo cấu hình Nginx
cat <<'EOF' > /etc/nginx/conf.d/quiz-game.conf
server {
    listen 80;
    server_name _;

    root /var/www/quiz-game;
    index index.html;

    location / {
        try_files $uri $uri/ =404;
    }
}
EOF

# Kiểm tra nginx
nginx -t

# Khởi động và kích hoạt Nginx
systemctl enable --now nginx



