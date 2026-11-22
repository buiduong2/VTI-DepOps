# Lab 05 – Kubernetes ConfigMap & Secret

## 1. Mục tiêu

Tìm hiểu cách Kubernetes quản lý và cung cấp cấu hình cho container thông qua:

- ConfigMap
- Secret
- Environment Variables
- `envFrom`
- `configMapRef`
- `secretRef`
- Cơ chế cập nhật cấu hình

**Kết quả mong muốn:**

1. Tạo ConfigMap và Secret độc lập với Pod.
2. Đưa các giá trị từ ConfigMap và Secret vào environment variables.
3. Kiểm tra biến môi trường bên trong container.
4. Thay đổi ConfigMap và quan sát hành vi cập nhật.
5. Hiểu sự khác biệt giữa ConfigMap và Secret.

## 2. Môi trường

- Kubernetes: Kind
- Container image: `nginx:alpine`
- Namespace: `default`

Cấu trúc thư mục:

```text
05-configmap-secret/
├── README.md
├── configmap.yaml
├── secret.yaml
└── pod.yaml
```

## 3. Các bước thực hành

### Bước 1 – Tạo ConfigMap

File `configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: demo-config
data:
  APP_NAME: "Chat Support"
  APP_ENV: "development"
  DATABASE_HOST: "postgres"
  DATABASE_PORT: "5432"
```

Apply:

```bash
kubectl apply -f configmap.yaml
```

Kiểm tra:

```bash
kubectl get configmap
kubectl describe configmap demo-config
```

Kết quả:

```text
NAME               DATA
demo-config        4
kube-root-ca.crt   1
```

ConfigMap `demo-config` chứa 4 key-value.

**Nhận xét:**

- ConfigMap là Kubernetes API Object.
- ConfigMap không chạy dưới dạng Pod.
- Trường `data` chứa các giá trị dạng chuỗi.
- ConfigMap phù hợp với cấu hình không nhạy cảm.
- `kubectl describe configmap` có thể hiển thị trực tiếp các giá trị.

### Bước 2 – Tạo Secret

File `secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: demo-secret
type: Opaque
stringData:
  DATABASE_USERNAME: "postgres"
  DATABASE_PASSWORD: "123456"
```

Apply:

```bash
kubectl apply -f secret.yaml
```

Kiểm tra:

```bash
kubectl get secret
kubectl describe secret demo-secret
```

Kết quả:

```text
NAME          TYPE     DATA
demo-secret   Opaque   2
```

Khi describe:

```text
Data
====
DATABASE_PASSWORD:  6 bytes
DATABASE_USERNAME:  8 bytes
```

**Nhận xét:**

- Secret là Kubernetes API Object.
- Secret dùng để quản lý thông tin nhạy cảm.
- `Opaque` là loại Secret tổng quát, chứa dữ liệu tùy ý.
- `stringData` cho phép khai báo giá trị plaintext.
- Kubernetes chuyển dữ liệu thành trường `data` với biểu diễn Base64.
- `kubectl describe secret` không trực tiếp hiển thị giá trị.

**Lưu ý bảo mật:**

Base64 chỉ là encoding, không phải encryption.

Kubernetes Secret không mặc nhiên đảm bảo dữ liệu được mã hóa khi lưu trong etcd. Production cần chú ý RBAC, encryption at rest và quản lý quyền truy cập.

### Bước 3 – Tạo Pod sử dụng ConfigMap và Secret

File `pod.yaml`:

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-demo
spec:
  containers:
    - name: nginx
      image: nginx:alpine
      envFrom:
        - configMapRef:
            name: demo-config
        - secretRef:
            name: demo-secret
```

Apply:

```bash
kubectl apply -f pod.yaml
```

Chờ Pod sẵn sàng:

```bash
kubectl wait \
  --for=condition=Ready \
  pod/config-demo \
  --timeout=120s
```

**Giải thích:**

```yaml
envFrom:
  - configMapRef:
      name: demo-config
  - secretRef:
      name: demo-secret
```

Kubernetes lấy các key-value hợp lệ từ hai tài nguyên và đưa chúng vào environment variables của container.

### Bước 4 – Kiểm tra environment variables

Truy cập container:

```bash
kubectl exec -it config-demo -- sh
```

Kiểm tra:

```bash
printenv APP_NAME
printenv APP_ENV
printenv DATABASE_HOST
printenv DATABASE_PORT
printenv DATABASE_USERNAME
printenv DATABASE_PASSWORD
```

Kết quả:

```text
Chat Support
development
postgres
5432
postgres
123456
```

Có thể kiểm tra trực tiếp mà không cần vào shell:

```bash
kubectl exec config-demo -- printenv APP_ENV
```

**Kết luận:**

Container nhận được cấu hình từ ConfigMap và Secret mà không cần khai báo trực tiếp các giá trị trong Pod manifest hoặc Docker image.

### Bước 5 – Thay đổi ConfigMap

Sửa `configmap.yaml`:

```yaml
APP_ENV: "production"
```

Apply lại:

```bash
kubectl apply -f configmap.yaml
```

Kết quả:

```text
configmap/demo-config configured
```

Kiểm tra environment variable trong Pod đang chạy:

```bash
kubectl exec config-demo -- printenv APP_ENV
```

Kết quả:

```text
development
```

**Nhận xét:**

Mặc dù ConfigMap đã thay đổi, environment variable trong container vẫn giữ giá trị cũ.

Nguyên nhân:

- Environment variables được thiết lập khi container khởi tạo.
- Cập nhật ConfigMap không tự động thay đổi environment variables của container đang chạy.

### Bước 6 – Tạo lại Pod

Xóa Pod:

```bash
kubectl delete pod config-demo
```

Tạo lại:

```bash
kubectl apply -f pod.yaml
```

Kiểm tra:

```bash
kubectl exec config-demo -- printenv APP_ENV
```

Kết quả:

```text
production
```

**Kết quả: THÀNH CÔNG**

Pod mới đã nhận được giá trị ConfigMap vừa cập nhật.

## 4. Kiến thức rút ra

### 4.1. ConfigMap và Secret

| Thành phần | Mục đích |
|---|---|
| ConfigMap | Lưu cấu hình không nhạy cảm |
| Secret | Lưu dữ liệu nhạy cảm |
| `data` trong ConfigMap | Các key-value dạng chuỗi |
| `data` trong Secret | Các giá trị được biểu diễn bằng Base64 |
| `stringData` trong Secret | Cho phép khai báo chuỗi plaintext |
| `Opaque` | Loại Secret tổng quát |

ConfigMap và Secret đều là API Object thuộc namespace.

Chúng không phải Pod và không tự chạy như một chương trình.

### 4.2. Các cách đưa cấu hình vào container

| Cách sử dụng | Ý nghĩa |
|---|---|
| `env.value` | Khai báo trực tiếp giá trị |
| `env.valueFrom.configMapKeyRef` | Lấy một key từ ConfigMap |
| `env.valueFrom.secretKeyRef` | Lấy một key từ Secret |
| `envFrom.configMapRef` | Lấy tất cả key hợp lệ từ ConfigMap |
| `envFrom.secretRef` | Lấy tất cả key hợp lệ từ Secret |
| Volume Mount | Mount ConfigMap hoặc Secret thành file |

Ví dụ lấy một key:

```yaml
env:
  - name: DATABASE_PASSWORD
    valueFrom:
      secretKeyRef:
        name: demo-secret
        key: DATABASE_PASSWORD
```

Ví dụ lấy tất cả key:

```yaml
envFrom:
  - configMapRef:
      name: demo-config
  - secretRef:
      name: demo-secret
```

### 4.3. Cơ chế cập nhật

Khi sử dụng environment variables:

```text
ConfigMap / Secret
        |
        v
Container khởi tạo
        |
        v
Environment Variables
        |
        v
Ứng dụng sử dụng cấu hình
```

Khi ConfigMap hoặc Secret thay đổi:

- Các environment variables đang tồn tại không tự cập nhật.
- Pod mới sẽ nhận được cấu hình mới.
- Với Deployment, có thể sử dụng `kubectl rollout restart`.

Ví dụ:

```bash
kubectl rollout restart deployment/my-app
```

**Lưu ý:** Nếu ConfigMap/Secret được mount thành file, Kubernetes có cơ chế cập nhật nội dung file trong một số điều kiện. Tuy nhiên, ứng dụng vẫn phải hỗ trợ đọc lại cấu hình.

### 4.4. Tạo ConfigMap và Secret từ file .env

Không cần khai báo lại từng key-value trong YAML.

Tạo ConfigMap:

```bash
kubectl create configmap app-config \
  --from-env-file=app.env
```

Tạo Secret:

```bash
kubectl create secret generic app-secret \
  --from-env-file=app.env
```

Phân biệt:

| Cách tạo | Kết quả |
|---|---|
| `--from-env-file=app.env` | Mỗi dòng KEY=VALUE trở thành một key |
| `--from-file=app.env` | Nội dung cả file được lưu dưới một key |

Ví dụ:

```bash
kubectl create secret generic app-secret \
  --from-file=.env=app.env
```

Có thể kết hợp với volume mount để đưa nguyên file `.env` vào container.

**Lưu ý:** Chỉ nên đưa các giá trị nhạy cảm vào Secret. Không commit file chứa mật khẩu thật lên Git.

## 5. Dọn dẹp môi trường

Xóa Pod:

```bash
kubectl delete pod config-demo
```

Xóa ConfigMap:

```bash
kubectl delete configmap demo-config
```

Xóa Secret:

```bash
kubectl delete secret demo-secret
```

Hoặc sử dụng các manifest đã tạo:

```bash
kubectl delete -f pod.yaml
kubectl delete -f configmap.yaml
kubectl delete -f secret.yaml
```

## 6. Kết luận

Lab đã kiểm chứng thành công:

- Tạo ConfigMap.
- Tạo Secret với `type: Opaque`.
- Sử dụng `envFrom` để đưa cấu hình vào container.
- Kiểm tra environment variables bằng `kubectl exec`.
- Cập nhật ConfigMap.
- Quan sát environment variables không tự thay đổi.
- Tạo lại Pod để nhận cấu hình mới.

**Trạng thái: COMPLETED**

### Nội dung có thể thực hành tiếp

- Mount ConfigMap thành file.
- Mount Secret thành file.
- Quan sát việc cập nhật file cấu hình.
- Sử dụng ConfigMap và Secret trong Deployment.
- Tự động tạo ConfigMap và Secret từ file `.env`.
