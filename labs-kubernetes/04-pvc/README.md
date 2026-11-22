# Lab 04 – Kubernetes Persistent Storage (PVC)

## 1. Mục tiêu

Thực hành cơ chế lưu trữ dữ liệu bền vững trong Kubernetes thông qua:

- StorageClass
- PersistentVolumeClaim (PVC)
- PersistentVolume (PV)
- Dynamic Provisioning
- Volume Mounting
- WaitForFirstConsumer
- Data Persistence

**Kết quả mong muốn:** Dữ liệu PostgreSQL vẫn tồn tại sau khi Pod bị xóa và tạo lại bằng cùng một PVC.

## 2. Môi trường

- Kubernetes: Kind
- Cluster: `pvc-lab`
- Nodes: 1 control-plane, 1 worker
- Database: PostgreSQL 17
- StorageClass: `standard`
- Provisioner: `rancher.io/local-path`

Cấu trúc thư mục:

```text
04-pvc/
├── README.md
├── kind/
│   └── kind-config.yaml
└── manifests/
    ├── pod.yaml
    └── postgres/
        └── pvc.yaml
```

## 3. Các bước thực hành

### Bước 1 – Tạo Kubernetes Cluster

```bash
kind create cluster \
  --name pvc-lab \
  --config kind/kind-config.yaml
```

Kiểm tra:

```bash
kubectl get nodes -o wide
```

Kết quả: Cluster có 1 control-plane và 1 worker, đều ở trạng thái `Ready`.

### Bước 2 – Kiểm tra StorageClass

```bash
kubectl get sc
kubectl describe sc standard
```

Kết quả quan sát:

```text
NAME                 PROVISIONER             RECLAIMPOLICY   VOLUMEBINDINGMODE
standard (default)   rancher.io/local-path   Delete          WaitForFirstConsumer
```

Ý nghĩa:

- **StorageClass:** Định nghĩa cách Kubernetes cấp phát storage.
- **Provisioner:** Thành phần thực hiện việc cấp phát storage.
- **ReclaimPolicy = Delete:** Khi PVC bị xóa và volume được giải phóng, Kubernetes sẽ yêu cầu xóa PV và storage bên dưới.
- **WaitForFirstConsumer:** Chờ đến khi có Pod sử dụng PVC trước khi cấp phát volume, nhằm lựa chọn node phù hợp.

### Bước 3 – Tạo PersistentVolumeClaim

```bash
kubectl apply -f manifests/postgres/pvc.yaml
```

Kiểm tra:

```bash
kubectl get pvc
kubectl get pv
```

Kết quả:

```text
PVC: Pending
PV: No resources found
```

**Giải thích:**

StorageClass sử dụng `WaitForFirstConsumer`, vì vậy Kubernetes chưa cấp phát PV khi chưa có Pod sử dụng PVC.

### Bước 4 – Tạo PostgreSQL Pod

```bash
kubectl apply -f manifests/pod.yaml
```

Kiểm tra:

```bash
kubectl get pods -o wide
kubectl get pvc
kubectl get pv
```

Kết quả:

```text
Pod: Running
PVC: Bound
PV: Được tạo tự động
```

Pod được scheduler chọn chạy trên node:

```text
pvc-lab-worker
```

Kiểm tra chi tiết:

```bash
kubectl describe pvc postgres-data
```

Quan sát các sự kiện:

```text
WaitForFirstConsumer
Provisioning
ProvisioningSucceeded
```

Kiểm tra PersistentVolume:

```bash
kubectl get pv
kubectl describe pv <pv-name>
```

PV được local-path-provisioner cấp phát trên node với đường dẫn tương tự:

```text
/var/local-path-provisioner/pvc-..._default_postgres-data
```

PV có `NodeAffinity` ràng buộc với `pvc-lab-worker`.

### Bước 5 – Tạo dữ liệu PostgreSQL

Truy cập PostgreSQL:

```bash
kubectl exec -it postgres -- psql -U postgres
```

Tạo bảng:

```sql
CREATE TABLE pvc_test (
    id SERIAL PRIMARY KEY,
    message TEXT
);
```

Thêm dữ liệu:

```sql
INSERT INTO pvc_test (message)
VALUES ('Hello Kubernetes PVC');
```

Kiểm tra:

```sql
SELECT * FROM pvc_test;
```

Kết quả:

```text
 id |       message
----+----------------------
  1 | Hello Kubernetes PVC
```

Thoát PostgreSQL:

```sql
\q
```

### Bước 6 – Xóa PostgreSQL Pod

```bash
kubectl delete pod postgres
```

Kiểm tra:

```bash
kubectl get pods
kubectl get pvc
kubectl get pv
```

Kết quả:

```text
Pod: Đã bị xóa
PVC: Bound
PV: Bound
```

**Nhận xét:** Xóa Pod không làm mất PVC và PV.

### Bước 7 – Tạo lại PostgreSQL Pod

```bash
kubectl apply -f manifests/pod.yaml
```

Chờ Pod sẵn sàng:

```bash
kubectl wait \
  --for=condition=Ready \
  pod/postgres \
  --timeout=120s
```

Kiểm tra:

```bash
kubectl get pods -o wide
```

Kết quả:

```text
postgres   1/1   Running   pvc-lab-worker
```

Pod mới tiếp tục sử dụng PVC cũ và được đặt trên node phù hợp với PV.

### Bước 8 – Kiểm tra dữ liệu sau khi tạo lại Pod

```bash
kubectl exec -it postgres -- \
  psql -U postgres -c "SELECT * FROM pvc_test;"
```

Kết quả:

```text
 id |       message
----+----------------------
  1 | Hello Kubernetes PVC
```

**Kết quả: THÀNH CÔNG**

Dữ liệu PostgreSQL vẫn tồn tại sau khi Pod bị xóa và tạo lại.

## 4. Kiến thức rút ra

### 4.1. Phân biệt các thành phần

| Thành phần | Vai trò |
|---|---|
| StorageClass | Định nghĩa cách cấp phát storage |
| Provisioner | Chương trình thực hiện cấp phát storage |
| PVC | Yêu cầu sử dụng một vùng lưu trữ |
| PV | Tài nguyên Kubernetes đại diện cho vùng lưu trữ đã được cấp phát |
| Pod | Sử dụng PVC để mount volume vào container |

### 4.2. Cơ chế hoạt động

```text
1. Tạo PVC
       |
       v
2. PVC Pending
       |
       v
3. Tạo Pod sử dụng PVC
       |
       v
4. Scheduler lựa chọn Node
       |
       v
5. Provisioner cấp phát storage
       |
       v
6. PV được tạo và liên kết với PVC
       |
       v
7. PVC chuyển sang Bound
       |
       v
8. Volume được mount vào Pod
       |
       v
9. PostgreSQL đọc/ghi dữ liệu
```

### 4.3. Những điểm cần nhớ

1. PVC và PV có vòng đời độc lập với Pod.
2. PVC có thể tồn tại ở trạng thái `Bound` ngay cả khi không có Pod sử dụng.
3. `WaitForFirstConsumer` trì hoãn việc cấp phát volume đến khi có Pod cần sử dụng.
4. `local-path-provisioner` cấp phát storage trên filesystem của một node.
5. PV local-path có `NodeAffinity`, ràng buộc volume với node cụ thể.
6. Pod bị xóa không đồng nghĩa dữ liệu bị xóa.
7. Pod mới có thể sử dụng lại dữ liệu thông qua cùng PVC.
8. `ReclaimPolicy: Delete` có thể khiến dữ liệu bên dưới bị xóa khi PVC được giải phóng.
9. PVC không tự động đồng bộ dữ liệu giữa nhiều node.
10. PV không trực tiếp quản lý hoạt động đọc/ghi file. Container vẫn sử dụng filesystem thông qua Linux.

## 5. Dọn dẹp môi trường

Sau khi hoàn thành lab:

```bash
kind delete cluster --name pvc-lab
```

**Lưu ý:** Dữ liệu của local-path-provisioner trong Kind thường được lưu trong filesystem của container node. Khi xóa Kind cluster, dữ liệu này có thể bị mất.

## 6. Kết luận

Lab đã kiểm chứng thành công khả năng lưu trữ dữ liệu độc lập với vòng đời của Pod.

PostgreSQL Pod bị xóa và tạo lại nhưng dữ liệu vẫn tồn tại nhờ sử dụng cùng PersistentVolumeClaim.

Các kiến thức đã thực hành:

- Dynamic Provisioning
- StorageClass và Provisioner
- PVC và PV Binding
- WaitForFirstConsumer
- NodeAffinity của local storage
- Persistent Volume Mounting
- Data Persistence khi Pod bị thay thế

**Trạng thái: COMPLETED**
