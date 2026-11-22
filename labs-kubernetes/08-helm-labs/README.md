## Cài đặt môi trường

```sh
curl -fsSL -o get_helm.sh \
  https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3

chmod 700 get_helm.sh

./get_helm.sh
```

- Kiểm tra lại


```sh
helm version
kubectl config current-context
kubectl get nodes
```

## Tạo helm chart 

```sh
helm create nginx-demo
```

- Ta có được một bộ template và cấu hình giúp tạo ra, triển khai quản lý các kubernetes resources



## các đối tượng của helm

- chart: là gói ứng dụng (package) của Helm, gồm tập hợp các file và thư mục mô tả cách triển khai một ứng dụng hoặc dịch vụ lên Kubernetes.

- template: : Khi chạy lệnh cài đặt hoặc render, Helm sẽ trộn (render) Template với Values để tạo ra manifest YAML hoàn chỉnh gửi lên Kubernetes API server.

- values: 
    - Là các tham số cấu hình (số replica, image tag, port, biến môi trường, bật/tắt ingress...) được truyền vào template khi render

- Release: 
    - Là một phiên bản cụ thể của Chart đang chạy trên một cluster Kubernetes

- Revision: 
    - Số thứ tự phiên bản của một Release sau mỗi lần helm install, helm upgrade, hoặc helm rollback (giúp theo dõi lịch sử thay đổi và quay lại bản cũ nếu lỗi).

## helm template

- Lấy dữ liệu từ đâu
    - `{{ .Values.replicaCount }}`	Lấy replicaCount từ values
    - `{{ .Values.image.repository }}`	Lấy repository của Docker image
    - `{{ .Release.Name }}`	Tên Release, ở đây là nginx-lab
    - `{{ .Chart.Name }}`	Tên Chart, ở đây là nginx-demo
    - `{{ .Chart.Version }}`	Phiên bản Chart từ Chart.yaml


```
Chart.yaml          values.yaml
     |                  |
     +--------+---------+
              |
       templates/*.yaml
              |
        helm template
              |
              v
        rendered.yaml
```

## helm lưu thông tin ở đâu 

- lưu trạng thái của từng Release ngay trên Kubernetes cluster thông qua Storage Driver — mặc định là các Secret

- Kiểm tra: 

```sh
# Xem các Secret mà Helm tạo ra cho release (thay <namespace> bằng namespace của release)
kubectl get secrets -l owner=helm

NAME                              TYPE                 DATA   AGE
sh.helm.release.v1.nginx-lab.v1   helm.sh/release.v1   1      21m
sh.helm.release.v1.nginx-lab.v2   helm.sh/release.v1   1      4m19s
sh.helm.release.v1.nginx-lab.v3   helm.sh/release.v1   1      3m6s

# Lọc riêng cho một release cụ thể, ví dụ nginx-lab
kubectl get secrets -l "owner=helm,name=nginx-lab"
```

## Thực hành 1: quan sát Chart được render 


```sh
helm lint ./nginx-demo
# Kiểm tra chart có những lỗi cấu hình hoặc cấu trúc phổ biến không

helm template nginx-lab ./nginx-demo > rendered.yaml
# 
```

- `helm template`
    - Render các template thành Kubernetes YAML
    - nginx-lab : Tên release giả định khi render.
    - ./nginx-demo Thư mục chứa Chart cần render.



## Thực hành 2: helm install và release

- 1. Tạo `values-dev.yaml` mới để tạo renderer mới
- 2. Tạo renderer mới để xem trước

```sh
helm template nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-dev.yaml > rendered.yaml
```

- 3. Cài release
```sh
helm install nginx-lab ./nginx-demo -f ./nginx-demo/values-dev.yaml
```

- 4. kiểm tra

```sh
helm list
# Liệt kê các release Helm đã cài đặt cùng trạng thái, revision và namespace hiện tại.

kubectl get deployments
# Xem danh sách các Deployment, số replica mong muốn/sẵn sàng và trạng thái cập nhật.

kubectl get pods
# Xem danh sách các Pod đang chạy, trạng thái

kubectl get services
# Liệt kê các Service
```

- 5. Xem thông tin release

```sh
helm status nginx-lab
# Xem trạng thái chi tiết của release nginx-lab, các tài nguyên Kubernetes liên quan và ghi chú (notes) sau cài đặt.

helm get values nginx-lab 
# Xem các giá trị cấu hình (values) đang được áp dụng cho release nginx-lab (mặc định chỉ lấy giá trị người dùng ghi đè, thêm --all nếu muốn xem cả mặc định).

helm get manifest nginx-lab
# In ra toàn bộ file YAML manifest của các tài nguyên Kubernetes đã được render và áp dụng cho release nginx-lab.

helm history nginx-lab
# lịch sử các phiên bản (REVISION) của release nginx-lab kèm trạng thái và mô tả thay đổi để phục vụ kiểm tra hoặc rollback
```
## Thực hành 3: Upgrade và Rollback

- B1: tiến hành tạo thêm values-dev-update.yaml
    - Thay `replicaCount = 2`

- `B1; upgrade`

```sh
helm upgrade nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-dev-update.yaml 

```

- Kiểm tra history

```sh
helm history nginx-lab

REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION     
1               Sun Nov 22 07:59:00 2026        superseded      nginx-demo-0.1.0        1.16.0          Install complete
2               Sun Nov 22 08:16:22 2026        deployed        nginx-demo-0.1.0        1.16.0          Upgrade complete

kubectl get deployments
NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
nginx-lab-nginx-demo   2/2     2            2           17m
```

- `B2: rollback`

```sh
helm rollback nginx-lab 1 --wait
# khôi phục lại cấu hình từ revision 1

```

- Kiểm tra

```sh
helm history nginx-lab
REVISION        UPDATED                         STATUS          CHART                   APP VERSION     DESCRIPTION
1               Sun Nov 22 07:59:00 2026        superseded      nginx-demo-0.1.0        1.16.0          Install complete
2               Sun Nov 22 08:16:22 2026        superseded      nginx-demo-0.1.0        1.16.0          Upgrade complete
3               Sun Nov 22 08:17:35 2026        deployed        nginx-demo-0.1.0        1.16.0          Rollback to 1   

kubectl get deployments

NAME                   READY   UP-TO-DATE   AVAILABLE   AGE
nginx-lab-nginx-demo   3/3     3            3           19m
```

## Thực hành 4: if trong helm

- Mệnh đề if trong template của helm

```yaml
{{- if .Values.ingress.enabled }}
apiVersion: networking.k8s.io/v1
kind: Ingress
# ...
{{- end }}
```

- trong values.yaml

```yaml
ingress:
  enabled: false

```

- Vì vậy có thể bỏ qua nội dung trong block của `if` và `end` nếu cần

- Tiến hành thử bật để sinh thử render.yaml

```sh
# gán giá trị true
helm template nginx-lab ./nginx-demo \
  --set ingress.enabled=true \ 
  --show-only templates/ingress.yaml

---
# Source: nginx-demo/templates/ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-lab-nginx-demo
  labels:
    helm.sh/chart: nginx-demo-0.1.0
    app.kubernetes.io/name: nginx-demo
    app.kubernetes.io/instance: nginx-lab
    app.kubernetes.io/version: "1.16.0"
    app.kubernetes.io/managed-by: Helm
spec:
  rules:
    - host: "chart-example.local"
      http:
        paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: nginx-lab-nginx-demo
                port:
                  number: 80
```

```sh
# Giá trị false thì ko sinh ra template tương ứng
helm template nginx-lab ./nginx-demo \
  --set ingress.enabled=false \
  --show-only templates/ingress.yaml

error: could not find template templates/ingress.yaml in chart
```

## Thực hành 5: `if` với configMap

- B1: Thêm cấu hình vào `values-if.yaml`

```sh
demoConfig:
  enabled: false
  message: "Hello from Helm"
```

- B2: tạo file template mới

- nginx-demo/templates/demo-configmap.yaml

```yaml
{{- if .Values.demoConfig.enabled}}
apiVersion: v1
kind: ConfigMap
metadata: 
    name: {{ .Release.Name}}-demo-config
data: 
    message: {{ .Values.demoConfig.message | quote }}
{{- end}}
```

- B3: Chạy thử

```sh

helm template nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-if.yaml  \
  --show-only templates/demo-configmap.yaml

---
# Source: nginx-demo/templates/demo-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata: 
    name: nginx-lab-demo-config
data: 
    message: "Hello from Helm"
```

- B4: Thử chạy enable = false

```sh
helm template nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-if.yaml  \
  --set demoConfig.enabled=false \
  --show-only templates/demo-configmap.yaml

Error: could not find template templates/demo-configmap.yaml in chart
```

## Thực hành 6: `range` trong Helm Template.

- Giả sử ta có một số cấu hình

```yaml
appConfig:
  APP_NAME: "nginx-demo"
  APP_ENV: "development"
  LOG_LEVEL: "debug"
```

- Cần viết kubernetes manifest yaml thủ công 

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: nginx-config
data:
  APP_NAME: "nginx-demo"
  APP_ENV: "development"
  LOG_LEVEL: "debug"
```

- Thực hành: 1. Tạo `value-range.yaml`

```yaml

appConfig:
  APP_NAME: "nginx-demo"
  APP_ENV: "development"
  LOG_LEVEL: "debug"
```

- B2: tạo helm template 

```yaml
apiVersion: v1
kind: ConfigMap
metadata: 
    name: {{ .Release.Name }}-app-config
data: 
    {{- range $key, $value := .Values.appConfig }}
    {{ $key }}: {{ $value | quote }}
    {{- end }}
```

- render để kiểm tra


```sh
helm template nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-range.yaml \
  --show-only templates/app-configmap.yaml

--
# Source: nginx-demo/templates/app-configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata: 
    name: nginx-lab-app-config
data:
    APP_ENV: "development"
    APP_NAME: "nginx-demo"
    LOG_LEVEL: "debug"
```

## Thực hành 7: `include`

- ở các template trước của ta đều sử dụng 

```yaml
metadata:
  name: {{ .Release.Name }}-app-config
```

- Nhưng thực tế các file gốc khác sử dụng 

```yaml
metadata:
  name: {{ include "nginx-demo.fullname" . }}
```

- Sửa lại các file template theo cú phpas giống gốc
- Chạy lại

```sh
helm template nginx-lab ./nginx-demo \
  -f ./nginx-demo/values-range.yaml \
  --show-only templates/app-configmap.yaml
```

- Chúng ta hoàn toàn có thể sử dụng fullNameOverride