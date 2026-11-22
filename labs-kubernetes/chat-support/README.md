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

### Resource Requests & Limits

**Measurement:** Sử dụng `docker stats` trên Docker Compose để đo khi Idle và sau khi thực hiện các thao tác chat.

| Service | Idle Memory | Observed Memory |
|---|---:|---:|
| Auth | 425.2 MiB | 434.8 MiB |
| Chat Backend | 368.7 MiB | 379.6 MiB |
| Chat UI | 102.7 MiB | 103.5 MiB |
| PostgreSQL | 59.21 MiB | 59.79 MiB |

**Decision:**
- Memory Request dựa trên mức RAM ổn định, có dự phòng.
- Memory Limit cao hơn mức RAM quan sát được để tránh OOM.
- CPU Request/Limit sử dụng giá trị thử nghiệm do chưa đo được CPU peak.
- Cần xác nhận lại trên Kubernetes vì số liệu Docker Compose không hoàn toàn tương đương.

**Status:** Initial sizing — chưa phải production benchmark.ker Compose chỉ là cơ sở ước lượng ban đầu, không đại diện hoàn toàn cho tải production.

### Health Checks & Kubernetes Probes

**Decision:** Bổ sung hai endpoint `/internal/health/live` và `/internal/health/ready` cho Auth Server, Chat Backend và Chat UI.

- Trả HTTP 200 khi ứng dụng hoạt động bình thường.
- Cho phép mô phỏng HTTP 503 bằng toggle trong môi trường lab.
- Sử dụng `startupProbe` để kiểm soát giai đoạn khởi động.
- Sử dụng `readinessProbe` để quyết định Pod có được nhận traffic từ Service hay không.
- Sử dụng `livenessProbe` để phát hiện container cần restart.

**Reason:** HTTP health checks giúp kiểm tra ứng dụng ở mức HTTP thay vì chỉ kiểm tra cổng TCP. Toggle được sử dụng để thực hành hành vi của Kubernetes khi ứng dụng mất khả năng phục vụ.

**Scope:** Các health checks hiện tại chỉ phục vụ lab, chưa kiểm tra database hoặc các dependency bên ngoài.
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
|PostgreSQL một replica sử dụng Recreate strategy |để tránh overlapping Pods truy cập cùng PVC trong quá trình cập nhật Deployment|

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
