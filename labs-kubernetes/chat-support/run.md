# Chat Support — Kubernetes Homelab

Triển khai Chat Support trên Kind Kubernetes với Nginx, Envoy Ingress và HTTPS.

## Prerequisites

Docker, Docker Compose, Kind, kubectl, cloud-provider-kind, mkcert.

## First-time Setup

### 1. Clone & Configure

```bash
git clone <repository-url>
cd chat-support
```

Chuẩn bị các file môi trường:

```text
config/auth.env
config/chat.env
config/chat-ui.env
```

### 2. Create Cluster

```bash
./script/create-cluster.sh
kubectl config use-context kind-chat-support
```

### 3. Generate TLS Certificates

```bash
mkdir -p proxy/certs

mkcert \
  -cert-file proxy/certs/chat-support.pem \
  -key-file proxy/certs/chat-support-key.pem \
  chat.local.test auth.local.test chat-api.local.test
```

TLS Secret được tạo thông qua Kustomize `secretGenerator` trong `kustomization.yaml`.

### 4. Load Images & Deploy

```bash
./script/load-images.sh
kubectl apply -k .
```

Lưu ý: `load-images.sh` yêu cầu các Docker images ứng dụng đã có trên máy host và PostgreSQL image đã được pull.

### 5. Start Ingress Controller

Chạy ở terminal riêng:

```bash
sudo cloud-provider-kind
```

### 6. Start Reverse Proxy

Sau khi Envoy được tạo:

```bash
./script/start-proxy.sh

docker compose -f proxy/docker-compose.yaml up -d --force-recreate
```

### 7. Configure Laptop

Trên laptop, chạy script `setup-hosts.sh` từ bản clone của repository:

```bash
./script/setup-hosts.sh
```

Cài đặt `rootCA.pem` của mkcert từ homelab vào trust store của laptop để trình duyệt tin cậy HTTPS.

## Access

- Chat UI: https://chat.local.test
- Auth Server: https://auth.local.test
- Chat API: https://chat-api.local.test

## Start Again

Khi Kind cluster đã tồn tại:

```bash
kubectl config use-context kind-chat-support
sudo cloud-provider-kind
```

Ở terminal khác:

```bash
./script/start-proxy.sh
cd proxy
docker compose up -d
```

Chỉ chạy `cloud-provider-kind` nếu tiến trình chưa hoạt động.

## Cleanup

```bash
cd proxy
docker compose down
```

Xóa cluster khi không cần dữ liệu nữa:

```bash
./script/delete-cluster.sh
```

**Notes**

- Không commit `.env`, TLS private keys hoặc `rootCA-key.pem`.
- Chat Backend sử dụng `JAVA_TOOL_OPTIONS=-Duser.timezone=Asia/Ho_Chi_Minh` để tương thích với code cũ.
- Nếu Nginx không nhận cấu hình mới, chạy `docker compose up -d --force-recreate`.
- Đảm bảo `kustomization.yaml` đã khai báo TLS `secretGenerator` trước khi chạy `kubectl apply -k .`.

