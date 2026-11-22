## Kiến trúc mong muốn

```
09-chat-support-helm/
├── charts/
│   ├── web-app/
│   └── postgresql/
├── values/
│   ├── auth.yaml
│   ├── chat.yaml
│   ├── chat-ui.yaml
│   └── postgres.yaml
├── database/
│   └── init/
│       └── 01-create-databases.sql
├── envs/
│   ├── auth.env
│   ├── chat.env
│   └── chat-ui.env
└── scripts/
    └── deploy.sh
```

- Sử dụng một template chung  Một Generic Helm Chart dùng chung được tạo sẵn
- nhiều file Values và nhiều Helm Releases độc lập.

## Khởi tạo helm chart

```
mkdir -p charts values

helm create charts/web-app
```


## Chỉnh sửa deployment.yaml hợp nhu cầu 

- Thêm `envFrom`
    - Phục vụ lấy secret
```yaml
{{- with .Values.envFrom }}
envFrom:
  {{- toYaml . | nindent 12 }}
{{- end }}
```
- Thêm `startupProbe`
```yaml
{{- with .Values.startupProbe }}
startupProbe:
  {{- toYaml . | nindent 12 }}
{{- end }}
```
- Sửa `containerPort` khỏi `service.port`
    - có thể các ứng dụng có port khác nhau VD 8080 , 3000

```yaml
ports:
  - name: http
    containerPort: {{ .Values.containerPort }}
    protocol: TCP
```
- Thêm lại vào values.yaml để sau copy

```
containerPort: 80
envFrom: []
startupProbe: {}
```

- Tắt mount Kubernetes API token

```yaml
automountServiceAccountToken: {{ .Values.serviceAccount.automount }}
```

## Tạo values/auth.yaml

- Cấu hình serviceAcount là `false`
- Vì các app của chúng ta ko tự động tương tác với Kubernetes API


## Tạo values/chat.yaml và chat-ui.yaml

### Sửa tên service

- bằng cách ghi đè fullnameOveride
- 

### Kiểm tra lint

```sh
helm lint ./charts/web-app -f values/auth.yaml
helm lint ./charts/web-app -f values/chat.yaml
helm lint ./charts/web-app -f values/chat-ui.yaml
```

- Render ra các file để kiểm tra

```sh
mkdir -p rendered

helm template auth ./charts/web-app \
  -f values/auth.yaml > rendered/auth.yaml

helm template chat ./charts/web-app \
  -f values/chat.yaml > rendered/chat.yaml

helm template chat-ui ./charts/web-app \
  -f values/chat-ui.yaml > rendered/chat-ui.yaml
```

### Xóa test vì hiện tại chưa có nhu cầu

### Viết thêm Chart cho PostgreSQL

- 
- Tìm vị trí cấu hình Database và sceret
- Tìm vị trí cấu hình PVC
- Các keyword như là : 
- `auth`, `image` `repository`, `tag`, `existingSecret` `primary:|persistence:|storageClass:|size:|initdb:|scripts:|resources`


- `auth.existingSecret` => cấu hình các tài khoản bằng secret

### Tạo Configmap 

```sh
kubectl create configmap postgres-init-scripts \
  --from-file=database/init/ \
  --dry-run=client -o yaml | kubectl apply -f -
```

## Tạo secret cho Postgres

```sh
kubectl create secret generic postgres-secret \
  --from-env-file=envs/db.env \
  --dry-run=client -o yaml | kubectl apply -f -
```


### triển khai helm postgres 

```sh
helm upgrade --install postgres ./charts/postgresql \
  -f values/postgres.yaml \
  --wait \
  --timeout 5m
```

- Kiểm tra kết quả: 

```sh
helm status postgres
kubectl get statefulset,pods,svc,pvc
kubectl logs postgres-postgresql-0

```

### Tạo lại env cho các service

- Cần cập nhật service DNS VD auth
- cập nhật service của postgres: `postgres-postgresql`


## tạo script để tự động tạo ra các secret 

```


```

## triển khai các ứng dụng còn lại

```sh
helm upgrade --install auth ./charts/web-app -f values/auth.yaml
helm upgrade --install chat ./charts/web-app -f values/chat.yaml
helm upgrade --install chat-ui ./charts/web-app -f values/chat-ui.yaml
```

## tạo chuwgns chỉ 

```sh
mkdir -p certs

mkcert \
  -cert-file certs/chat-support.crt \
  -key-file certs/chat-support.key \
  auth.local.test \
  chat-api.local.test \
  chat.local.test
```

## Tạo secret tls

```sh
kubectl create secret tls chat-support-tls \
  --cert=certs/chat-support.pem \
  --key=certs/chat-support-key.pem \
  --dry-run=client -o yaml | kubectl apply -f -
```

- Kiểm tra;

```sh
kubectl get secret chat-support-tls
```