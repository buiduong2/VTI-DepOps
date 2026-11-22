# Lab 07 — Kubernetes Ingress From Zero (Kind + Envoy)

## 1. Mục tiêu

Hiểu cách một HTTP request từ bên ngoài Kubernetes cluster đến được ứng dụng bên trong thông qua Ingress.

Sau lab này cần giải thích được:

- Deployment, Pod, Service có nhiệm vụ gì?
- ClusterIP và NodePort khác nhau thế nào?
- Ingress, IngressClass, Ingress Controller khác nhau ra sao?
- Reverse Proxy (Envoy) làm nhiệm vụ gì?
- Controller và Proxy khác nhau như thế nào (Control Plane vs Data Plane)?
- Linux quyết định đường đi đến Envoy IP ra sao?
- Envoy sử dụng ClusterIP hay Pod IP trong lab này?

**Phạm vi:** HTTP trên Kind. Chưa thực hành DNS thật, HTTPS/TLS hoặc LoadBalancer trên AWS.

---

## 2. Kiến trúc cuối cùng

```text
Linux Homelab
    |
    | curl -H "Host: app.local"
    | http://172.18.0.4/
    |
    v
Envoy Reverse Proxy
172.18.0.4:80
    |
    | Ingress routing
    | Host: app.local
    | Path: /
    v
Service nginx (ClusterIP)
10.96.49.87:80
    |
    | Kubernetes Service networking
    |
    +----> Nginx Pod 10.244.1.5:80
    |
    +----> Nginx Pod 10.244.1.7:80
    |
    +----> Nginx Pod 10.244.1.8:80
```

**Lưu ý:** Đây là IP của lần thực hành ngày 21/11/2026. Khi tạo cluster mới, IP có thể thay đổi. Không hardcode các IP này vào manifest.

## 3. Chuẩn bị môi trường

Cần cài sẵn:

- Docker
- Kind
- kubectl
- cloud-provider-kind (phiên bản hỗ trợ Ingress)
- curl

Máy homelab sử dụng Linux.

### Bước 1 — Tạo Kind cluster

File `kind-config.yaml`:

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
```

Tạo cluster:

```bash
kind create cluster \
  --name ingress-learning \
  --config kind-config.yaml
```

Kiểm tra:

```bash
kubectl config current-context
kubectl get nodes -o wide
kind get clusters
```

**Kết quả mong đợi:**

- Context là `kind-ingress-learning`.
- Có hai Node `Ready`.
- Một Node control-plane và một Node worker.

**Ý nghĩa:** Kind tạo các Kubernetes Node dưới dạng Docker container. Chúng ta đã có một Kubernetes cluster cục bộ.

---

## 4. Triển khai ứng dụng Nginx

### Bước 2 — Tạo Deployment

File `manifests/nginx-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:alpine
          ports:
            - containerPort: 80
```

Áp dụng:

```bash
kubectl apply -f manifests/nginx-deployment.yaml
kubectl get pods -o wide
```

**Ý nghĩa:**

- Deployment quản lý ReplicaSet và các Pods.
- `replicas: 3` yêu cầu duy trì ba Nginx Pods.
- Các Pod có label `app: nginx`.
- Nginx trong bước này chỉ đóng vai trò ứng dụng web demo, không phải Ingress Controller.

Trong lần thực hành trước, chúng ta ban đầu tạo một Pod rồi scale lên ba:

```bash
kubectl scale deployment nginx --replicas=3
```

Khi thực hành lại có thể khai báo trực tiếp `replicas: 3` trong manifest để tránh khác biệt giữa cấu hình file và trạng thái thực tế.

---

## 5. Tạo Kubernetes Service

### Bước 3 — ClusterIP Service

File `manifests/nginx-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  type: ClusterIP
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
```

Áp dụng:

```bash
kubectl apply -f manifests/nginx-service.yaml
kubectl get svc nginx
```

**Ý nghĩa:**

- Service cung cấp một địa chỉ truy cập ổn định đến nhóm Pod.
- `selector: app: nginx` xác định backend Pods.
- `port: 80` là Service port.
- `targetPort: 80` là cổng của ứng dụng trong Pod.
- Pod IP có thể thay đổi nhưng ClusterIP vẫn giữ nguyên trong vòng đời Service.

Ở lần thực hành này:

```text
Service: nginx
ClusterIP: 10.96.49.87
Port: 80
```

### Bước 4 — Thử truy cập từ trong cluster

Tạo Pod tạm thời:

```bash
kubectl run curl-test \
  --image=curlimages/curl \
  --restart=Never \
  --rm -it -- sh
```

Trong Pod:

```bash
curl http://nginx:80
```

Thử thêm:

```bash
curl http://10.96.49.87:80
```

Thay IP bằng ClusterIP thực tế.

**Kết quả:** Trang `Welcome to nginx!`.

**Ý nghĩa:**

- DNS nội bộ Kubernetes phân giải tên `nginx` thành ClusterIP của Service.
- Client không cần biết IP của từng Pod.
- Service networking chọn một endpoint phù hợp khi thiết lập kết nối.

Thoát bằng `exit`.

### Bước 5 — Thử NodePort

File `manifests/nginx-nodeport-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

Áp dụng:

```bash
kubectl apply -f manifests/nginx-nodeport-service.yaml
kubectl get svc
kubectl get nodes -o wide
```

Từ máy homelab, thử (thay Node IP theo kết quả thực tế):

```bash
curl http://172.18.0.2:30080/
curl http://172.18.0.3:30080/
```

**Kết quả trong lab:** Cả hai đều trả HTTP 200.

**Ý nghĩa:**

- NodePort cho phép truy cập Service qua Node IP và cổng NodePort.
- Với cấu hình mặc định `externalTrafficPolicy: Cluster`, request vào một Node có thể được chuyển đến Pod ở Node khác.
- `nginx-nodeport` và `nginx` là hai Service khác nhau nhưng cùng chọn nhóm Pods có label `app: nginx`.

**Lưu ý:** NodePort ở bước này chỉ nhằm học networking. Ingress ở các bước sau sẽ sử dụng Service `nginx` loại ClusterIP.

---

## 6. Khởi động Ingress Controller

### Bước 6 — Kiểm tra trạng thái ban đầu

```bash
kubectl get ingress -A
kubectl get ingressclass
docker ps
```

Trước khi khởi động controller, chúng ta chưa có Ingress và IngressClass trong cluster mới.

### Bước 7 — Chạy cloud-provider-kind

Mở terminal riêng:

```bash
sudo cloud-provider-kind
```

Giữ terminal này chạy để quan sát log.

Ở terminal khác:

```bash
kubectl get ingressclass
```

**Kết quả thực tế:**

```text
NAME                            CONTROLLER
cloud-provider-kind (default)   kind.sigs.k8s.io/ingress-controller
```

**Ý nghĩa:**

- `cloud-provider-kind` là Ingress Controller chạy trên máy Linux host, bên ngoài Kubernetes cluster.
- Controller giao tiếp với Kubernetes API Server.
- Nó đăng ký IngressClass `cloud-provider-kind`.
- IngressClass là resource dùng để xác định loại controller chịu trách nhiệm xử lý Ingress.
- IngressClass không phải Pod, Proxy hay chương trình đang chạy.

Quan hệ quan trọng:

```text
Ingress
  ingressClassName: cloud-provider-kind
       |
       | Tham chiếu
       v
IngressClass
  name: cloud-provider-kind
  controller: kind.sigs.k8s.io/ingress-controller
       |
       | Controller nhận diện
       v
cloud-provider-kind
```

Ingress và IngressClass có quan hệ tham chiếu, không phải quan hệ sở hữu `ownerReferences`.

IngressClass không tự gửi request hay cấu hình đến controller. Controller theo dõi Kubernetes API và xử lý các resource mà nó phụ trách.

---

## 7. Tạo Ingress Resource

### Bước 8 — Khai báo Ingress

File `manifests/nginx-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  ingressClassName: cloud-provider-kind
  rules:
    - host: app.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: nginx
                port:
                  number: 80
```

Áp dụng:

```bash
kubectl apply -f manifests/nginx-ingress.yaml
kubectl get ingress -o wide
```

**Kết quả thực tế:**

```text
NAME            CLASS                 HOSTS       ADDRESS
nginx-ingress   cloud-provider-kind   app.local   172.18.0.4
```

**Ý nghĩa:**

Ingress khai báo quy tắc:

```text
Host = app.local
Path có Prefix /
        |
        v
Service nginx:80
```

Ingress YAML tương tự một bản khai báo routing trong Spring Cloud Gateway.

Nhưng Ingress Resource không tự nhận HTTP request. Nó chỉ lưu cấu hình mong muốn trong Kubernetes API.

### Bước 9 — Kiểm tra Envoy

```bash
docker ps --format \
  'table {{.Names}}\t{{.Image}}\t{{.Status}}'
```

Kết quả thực tế:

```text
kindccm-gw-631a0239acd2
envoyproxy/envoy:v1.33.2
```

**Ý nghĩa:**

- `cloud-provider-kind` phát hiện Ingress.
- Nó quản lý một Envoy Docker container làm reverse proxy.
- Controller cấu hình Envoy qua xDS.
- Envoy mới là thành phần nhận HTTP request và gửi tới backend.

Phân biệt:

```text
Ingress YAML       = Khai báo routing
Ingress Controller = Đọc và đồng bộ routing
Envoy              = Thực thi HTTP routing
```

---

## 8. Kiểm tra HTTP Routing

### Bước 10 — Host hợp lệ

```bash
curl -v \
  -H "Host: app.local" \
  http://172.18.0.4/
```

**Kết quả thực tế:**

```text
HTTP/1.1 200 OK
server: envoy

Welcome to nginx!
```

**Giải thích:**

- `172.18.0.4:80` là IP và port của Envoy trên Docker network.
- `Host: app.local` được Envoy sử dụng để tìm routing rule.
- `/` khớp `pathType: Prefix`.
- Envoy chuyển request đến backend được cấu hình.
- Nginx Application trả HTML.

### Bước 11 — Host không hợp lệ

```bash
curl -i \
  -H "Host: unknown.local" \
  http://172.18.0.4/
```

**Kết quả thực tế:**

```text
HTTP/1.1 404 Not Found
server: envoy
```

**Ý nghĩa:** Request đã đến Envoy nhưng không có Ingress rule phù hợp với Host `unknown.local`.

---

## 9. Kiểm tra Envoy thực sự dùng ClusterIP hay Pod IP

Đây là bước quan trọng nhất để hiểu rằng Ingress YAML tham chiếu Service không có nghĩa mọi Controller đều phải dùng ClusterIP làm upstream.

### Bước 12 — Kiểm tra cấu hình thực tế của Envoy

Lấy ClusterIP hiện tại:

```bash
kubectl get svc nginx
```

Thử Envoy Admin API (trong lab này truy cập được qua port 10000):

```bash
curl -s http://172.18.0.4:10000/clusters \
  | grep '10.96.49.87'
```

**Kết quả thực tế chứa:**

```text
default_nginx_core_Service_80::10.96.49.87:80::rq_total::1
default_nginx_core_Service_80::10.96.49.87:80::rq_success::1
```

**Kết luận:** Trong phiên bản và cấu hình `cloud-provider-kind` của lab này, Envoy sử dụng `10.96.49.87:80` làm upstream endpoint.

### Bước 13 — Kiểm tra Kubernetes EndpointSlice

```bash
kubectl get endpointslice \
  -l kubernetes.io/service-name=nginx \
  -o wide
```

**Kết quả:**

```text
10.244.1.5
10.244.1.7
10.244.1.8
```

**Ý nghĩa:**

- Envoy gửi request đến ClusterIP.
- Kubernetes Service networking chuyển kết nối đến một Pod endpoint.
- EndpointSlice chứa thông tin các backend thực tế.
- Nếu Pod IP thay đổi, EndpointSlice và Service networking được cập nhật, trong khi ClusterIP của Service không đổi.

Lưu ý: Các Ingress Controller khác có thể cấu hình reverse proxy sử dụng Pod IP trực tiếp. Ingress YAML không bắt buộc một cách triển khai cụ thể.

---

## 10. Tìm hiểu Linux Routing đến Envoy

### Bước 14 — Kiểm tra IP Envoy

```bash
docker inspect kindccm-gw-631a0239acd2 \
  --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
```

Kết quả:

```text
172.18.0.4
```

### Bước 15 — Xem interface trên homelab

```bash
ip -br addr
```

Các interface quan trọng trong lab:

| Interface | Địa chỉ | Vai trò |
|---|---|---|
| lo | 127.0.0.1 | Loopback |
| eno2 | 192.168.0.114/24 | LAN |
| Docker bridge | 172.18.0.1/16 | Mạng Docker chứa Kind và Envoy |

### Bước 16 — Kiểm tra Linux routing

```bash
ip route get 172.18.0.4
ip route get 192.168.0.1
ip route get 8.8.8.8
```

**Kết quả thực tế:**

```text
172.18.0.4
  dev br-4df0aa99b1d9
  src 172.18.0.1

192.168.0.1
  dev eno2
  src 192.168.0.114

8.8.8.8
  via 192.168.0.1
  dev eno2
  src 192.168.0.114
```

**Ý nghĩa:**

- Khi gọi Envoy, Linux chuyển gói tin qua Docker bridge.
- Không cần đi ra Internet.
- Khi gọi một IP ngoài Internet, Linux sử dụng default gateway nếu không có route cụ thể hơn.
- `ip route get` giúp xác định next hop và interface, không hiển thị toàn bộ router trên đường đến đích.

### Bước 17 — So sánh tracepath

```bash
tracepath 172.18.0.4
tracepath 8.8.8.8
```

Kết quả:

- Envoy `172.18.0.4`: reached ở hop đầu tiên.
- `8.8.8.8`: qua nhiều router trung gian.

**Ý nghĩa:** Máy Linux có thể giao tiếp trực tiếp với Docker network mà không cần qua router gia đình.

Không thể mặc định gọi Envoy qua `localhost:80`, vì hiện tại cổng 80 của Envoy chưa được publish về loopback của máy homelab.

---

## 11. Control Plane và Data Plane

### Control Plane — Quản lý cấu hình

```text
Ingress YAML
    |
    v
Kubernetes API
    |
    v
cloud-provider-kind
    |
    | xDS
    v
Envoy được cập nhật cấu hình
```

Control Plane trả lời câu hỏi:

**Request phải được chuyển đến đâu, dựa trên quy tắc nào?**

### Data Plane — Xử lý request thực tế

```text
Client
   |
   v
Envoy
   |
   v
ClusterIP Service
   |
   v
Application Pod
```

Data Plane trả lời câu hỏi:

**Request thực sự được nhận và chuyển tiếp như thế nào?**

Nếu Controller dừng nhưng Envoy vẫn giữ cấu hình hợp lệ, request có thể tiếp tục hoạt động. Tuy nhiên không được mặc định cho rằng điều đó luôn đúng: Envoy có thể mất cấu hình động hoặc listener khi mất kết nối với controller.

Control Plane trong ngữ cảnh này là một khái niệm kiến trúc mạng, không hoàn toàn đồng nghĩa với Kubernetes control-plane Node.

---

## 12. Các kiến thức cần nhớ

| Khái niệm | Ý nghĩa |
|---|---|
| Pod | Đơn vị chạy container trong Kubernetes |
| Deployment | Quản lý replica và vòng đời Pod |
| ClusterIP | Địa chỉ Service ổn định trong cluster |
| NodePort | Expose Service qua Node IP và một cổng |
| EndpointSlice | Thông tin các endpoint thực tế của Service |
| Ingress | Resource khai báo HTTP/HTTPS routing |
| IngressClass | Xác định loại Controller xử lý Ingress |
| Ingress Controller | Quan sát API và đồng bộ cấu hình routing |
| Reverse Proxy | Nhận HTTP request, chọn upstream và chuyển tiếp |
| Load Balancer | Phân phối lưu lượng đến các backend |
| Control Plane | Quản lý trạng thái và cấu hình |
| Data Plane | Xử lý lưu lượng thực tế |

**Quan hệ Ingress và IngressClass:** Tham chiếu, không phải sở hữu.

**Quan hệ Service và Pods:** Selector và backend endpoints, không phải sở hữu.

**Quan hệ Deployment và Pods:** Gián tiếp qua ReplicaSet, có quan hệ sở hữu thông qua ownerReferences.

---

## 13. Tự kiểm tra kiến thức sau khi thực hành

Không nhìn tài liệu, hãy trả lời:

1. Vì sao tạo Ingress YAML mà không chạy Ingress Controller thì chưa đủ để HTTP routing hoạt động?
2. IngressClass có phải một chương trình đang chạy không?
3. Ai đọc Kubernetes API: Envoy hay cloud-provider-kind?
4. Ai thực sự nhận HTTP request?
5. Vì sao `unknown.local` nhận HTTP 404?
6. Vì sao Envoy có thể truy cập Service ClusterIP dù chạy bên ngoài Kind Nodes?
7. Nếu Pod đổi IP, tại sao Service vẫn có thể hoạt động?
8. Vì sao `172.18.0.4` truy cập được từ homelab nhưng `localhost` không nhất thiết được?
9. Controller và Proxy khác nhau thế nào?
10. Vì sao cùng một Ingress YAML nhưng Controller khác nhau có thể sử dụng ClusterIP hoặc Pod IP làm upstream?

---

## 14. Trạng thái cuối cùng và phạm vi hoàn thành

**Đã hoàn thành — Ingress Basic:**

- Tạo Kind cluster.
- Triển khai Nginx.
- Tạo ClusterIP và NodePort Service.
- Chạy cloud-provider-kind.
- Tạo Ingress và quan sát Envoy.
- Kiểm tra Host routing.
- Xác định upstream thực tế của Envoy.
- Kiểm tra Docker networking và Linux routing.

**Chưa thực hành:**

- DNS thực tế cho `app.local`.
- HTTPS/TLS và certificate.
- Truy cập Ingress từ thiết bị khác trong LAN.
- Kiểm tra lỗi khi Controller dừng.
- Kiểm tra thay đổi Pod IP trong khi hệ thống đang phục vụ request.
- Triển khai ứng dụng thực tế thay cho Nginx demo.

Những nội dung chưa thực hành không được xem là đã hoàn thành.

---

## 15. Dọn dẹp lab khi không còn sử dụng

Chỉ thực hiện khi không cần giữ cluster.

Dừng `cloud-provider-kind` trong terminal đang chạy (Ctrl+C), rồi:

```bash
kind delete cluster --name ingress-learning
```

Việc xóa cluster sẽ xóa các Kubernetes Resource bên trong. Kiểm tra riêng các container hoặc tiến trình ngoài cluster còn sót lại nếu cần.

**Không sử dụng `docker system prune -a` để dọn lab**, vì có thể ảnh hưởng đến các ứng dụng Docker khác trên homelab.

---

**Kết luận:** Kubernetes Ingress không phải một proxy. Nó là cách khai báo HTTP routing. Ingress Controller hiện thực những quy tắc đó thông qua một proxy hoặc hạ tầng phù hợp. Trong lab này, `cloud-provider-kind` cấu hình Envoy, Envoy nhận request và gửi đến Service ClusterIP `nginx`, sau đó Kubernetes Service networking chuyển kết nối đến một Nginx Pod.


