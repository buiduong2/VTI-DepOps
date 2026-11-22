# Chat Support — Kubernetes Homelab

## 1. Overview

Triển khai ứng dụng Chat Support lên Kubernetes (Kind).

**Stack:** Spring Boot, React Router SSR, PostgreSQL, Kind, Kustomize, Nginx, Envoy (`cloud-provider-kind`), mkcert.

**Kiến trúc:**

```text
Browser
  → Nginx (HTTPS)
  → Envoy / Ingress (HTTPS)
  → Services
      ├── Auth Server
      ├── Chat Backend
      ├── Chat UI
      └── PostgreSQL (PVC)
```

## 2. Technical Decisions

### PostgreSQL

- Sử dụng Deployment + PVC với StorageClass `standard`.
- SQL khởi tạo được mount qua ConfigMap.
- `/docker-entrypoint-initdb.d` chỉ chạy khi thư mục dữ liệu chưa được khởi tạo.
- Thay đổi SQL sau khi DB đã tồn tại phải dùng migration hoặc reset dữ liệu lab.

### Auth & Database Startup

**Chiến lược: Fail Fast**

- Ứng dụng cũ cần PostgreSQL khi khởi động, không hỗ trợ trì hoãn phần khởi tạo DB.
- Kubernetes không có `depends_on` tương đương Docker Compose.
- Nếu PostgreSQL chưa sẵn sàng, Auth có thể khởi động thất bại và được Kubernetes restart theo cơ chế backoff.
- Nếu PostgreSQL mất kết nối sau khi Auth đã chạy, HikariCP có thể loại bỏ connection hỏng và tạo connection mới khi DB phục hồi.
- Không cần tự viết scheduler để reconnect DB.

Lưu ý: HikariCP không đảm bảo mọi request đang thực hiện sẽ thành công trong thời gian DB mất kết nối.

### Configuration

- Kustomize quản lý Deployment, Service, ConfigMap và Secret.
- React Router SSR sử dụng runtime environment configuration.
- TLS sử dụng mkcert và Kubernetes TLS Secret.
- Chat Backend cũ dùng `LocalDateTime`; cấu hình JVM timezone `Asia/Ho_Chi_Minh` để tương thích.

## 3. Problems Encountered

| Vấn đề | Nguyên nhân / Giải pháp |
|---|---|
| PostgreSQL không chạy lại SQL | PVC đã chứa dữ liệu |
| Auth khởi động trước PostgreSQL | Chấp nhận fail fast và Kubernetes restart |
| OAuth2/CORS lỗi qua proxy | Nginx → Envoy phải sử dụng HTTPS |
| Nginx reload nhưng cấu hình không đổi | Bind mount file cũ; recreate container |
| Nginx không khởi động | Envoy chưa có alias `chat-ingress` |
| Axios Network Error | Laptop chưa tin cậy mkcert CA |
| OAuth2 trả 400 | Cấu hình redirect URI không khớp |
| Typing indicator không hiển thị | Timestamp `LocalDateTime` lệch timezone 7 giờ |

## 4. Quick Start

```bash
# Create cluster
./script/create-cluster.sh

# Load images
./script/load-images.sh

# Deploy resources
kubectl apply -k .

# Start ingress controller (separate terminal)
sudo cloud-provider-kind

# Connect Envoy to proxy network
./script/start-proxy.sh

# Start Nginx
cd proxy
docker compose up -d
```

Trước khi deploy lần đầu, cần chuẩn bị `config/*.env`, tạo certificate bằng mkcert và cấu hình TLS Secret trong Kustomize.

Trên laptop, chạy `script/setup-hosts.sh` và cài root CA của mkcert.

## 5. Remaining Work

- [ ] Resource Requests & Limits
- [ ] Startup / Readiness / Liveness Probes
- [ ] Helm Chart
- [ ] AWS deployment
- [ ] Hoàn thiện tài liệu bàn giao AWS
