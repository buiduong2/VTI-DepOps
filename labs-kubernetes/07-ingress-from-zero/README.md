## Cấc bước thực hiện 

### B1: Tạo Kuberneté cluster 

- Sử dụng kind
- 1 Control plane + 1 Workerr

## Vì sao cần Deployment và Service

- Giả sử chúng ta muốn chạy một website nginx

- POd cần để nginx thực thi. Nhưng Pod bị xóa thì Deployment tạo lại thông qua Replica Set -> Deployment
- Muốn POd khác truy cập website này bằng tên ổn định, không phụ thuộc IP của Pod -> Thông qua Service

## Tạo Nginx Deplioyment

- selector.matchLabels: Deployment xác định Pod nào thuộc quyền quản lý thông qua Label selector

- template.metadata.labels: -> các label được gắn lên Pod mà deployment tạo ra . Chúng cần khớp với selector 

## Deployment và Service khác nhau thế nào ?

- Pod IP không cố định. Nó có thể bị thay đổi khi bị xóa và tạo lại 
- Service cung cấp một địa chỉ ổn định và có thể chuyển lưu lượng đến các Pod phù hợp 


- `type: ClusterIP`: service cung cấp địa chỉ nội bộ trong cluster
- selector.app: nginx -> Chọn các Pod có lable  app=nginx
- port: 80 : cổng service nhận request 
- targetPort: 80 -> cổng phía Pod nhận lưu lượng
- Protocol : TCP -> sử dụng giao thức TCP

- selector.app === deployent.template.metadata.labels.app

### Tesst 

```sh
kubectl run curl-test \
  --image=curlimages/curl \
  --restart=Never \
  --rm -it \
  -- curl -v http://nginx:80/
```

- Taoj tạo pod tạm thời tên `curl-test`  bên trong kubernetes cluster. Để thực hiện HTTP request 
- Không phải chạy Curl trên homelab. 

## Các Service Type khác 

- ClusterIP: Cung cấp IP nội bộ cluster
- NodePort : Mở thêm một cổng trên các Node
- Yêu acuaf hạ tầng cung cấp Load Blaancer
- Exterrnal Name: Ánh xạ tên Service sang tên DNS khác 

- VD clusterIP: 
    - Trong cả cụm kubernetes, trong nội bộ các pod. Sử dụng request đến IP đó sẽ tại bất kì node nào sẽ đến đúng service đó luôn
- NodePort: 
    - Tất cả các node (worker, controlPlane) khi request từ bên ngoài vào hoặc nội bộ trong cụm cluster khi request đến các IP của các controler thì sẽ được mapping đến các service tương ứng. 

## Ingress 

- Bây giờ ta đã hiểu được 
- Deploiyment tạo và quản lý Pod
- Service chọn Pod dựa trên label selector
- Cluster IP cung cấp điểm truy cập nội bộ
- NodePOrt bổ sung điểm truy cập qua NodeIP và một cổng cố định 
- CoreDNS phân giải tên service bên trong Cluster
- Một service có thể có nhiều endpoint nằm trên nhieeuf node

- Bài toán mới: 
    + Có 3 ứng dụng  tại 3 IP khác nhau
    + Nếu muốn đưa ra ngoài phải thông qua các Node . Ta có thể phải truy cập các port khác nhau của node (nếu sử dụng Service NodePort) 
    + Nhưng chúng ta muốn sử dụng dns hoặc hostname để tất cả đề đi qua HTTP port 80 hoặc HTTPS port 443 


- Mục đích của Ingress: 
    + Dịnh tuyến request theo hostname hoặc URL path đến các Service phù hợp 

- ingress hoàn toàn biết được ClusterIP làm việc với Service Type Cluster IP
- Vì Ingress Thuộc thành phần tích hợp Kubernetes
    - Nó quan sát: Ingress: quy tắc định tuyến đến service nào
    - Service: service đó có cổng nào
    - EndpointSlice: Service đó có những backend nào 

- *Tuy nhiên biết POD IP và có đường mạng để truy cập POd IP là 2 chuyện khác nhau*. Controller còn cần khả năng kết nối đến bakcend thông qua mạng Cluster hoặc momojt cơ chế chueyern tiếp phù hợp 

## Các khái niệm 

- Ingres: resource khai báo quy tắc HTTP/HTTPS routing - Giống như file yaml của Spring Gateway 
- ingress Controller: Chương trình đọc các quy tắc của ingress và biến nó thành cấu hình có thể thực thi 
- Reverse Proxy (data plane) - Loadbalancer  : Thực sự nhận HTTP request và chuyển tiếp đến bakcend 


## Thực thế

- khhi chạy kubectl apply -f ingress.yaml 
    + Chỉ lưu ingress Resource vào hệ thống 

## Ingess Controller thực sự là cái gì 

- Là một chương trình có nhiệm vụ quan sát kubernetes API và thực hiện các quy tắc   ingress 

- Nó quan sát: 

```
Ingress : 
    app.local -> service:nginx:80

Service iginx: 
    Cluster IP 10.95.48.87:80

Endpoint Slice: 
    10.2434.1.5:80
    10.2434.1.4:80

``` 

- Sau đó tùy Implement, controller sẽ: 
    - Sinh cập nhật cấu hình cho Nginx 
    - hoặc gửi yêu cầu cấu hình cho Envoy
    - Hoặc yêu cầu Cloud Provider tạo và cấu hình một Load Blaancer như AWS ALB

### Thực hành 

- Khởi động Ingress Controller  
    - cloud-provider-kind

```sh
sudo cloud-provider-kind
```

```sh
duong@homelab:~/labs/kubernetes/07-ingress-from-zero$ kubectl get ingressclass
NAME                            CONTROLLER                            PARAMETERS   AGE
cloud-provider-kind (default)   kind.sigs.k8s.io/ingress-controller   <none>       11s
```

- cloud-provider-kind: chạy bên ngoài kubernetes Cluster
- Đồng thời nó cũng tạo một IngressClass tgrong Kubernetes thông qua Kubernetes API 
- 
### Ingress Class có ý nghĩa gì 

- cloud-provider-kind: tên ingress Class
- kind.sgs.k8s.io/ingress-controller: định danh của controller chịu trách nhiệm xử lý các ingress thuộc class này 
- default: ingressClass này được đánh dấu mặc định. Một Ingress mới không chỉ định ingressClassName có thể được Kubernetes  tự gán class mặc định đó 

## Tiếp theo - Tạo ingress 

- Khai báo đúng ingressClassName: 
- Kiểm tra docker ps
- Xuất hiện thêm envoy. 
- Có một điểm cần nhớ. xóa  cloud-provider-kind  hệ thống vẫn hoạt động bình thường. Chỉ 

### envoy

- Nhận request thực tế và chuyển đến backend phù hợp 

### Control Plane và Data Plane là gì 

- Khái niệm quan trọng trong mạng máy tính: 
    - Control Plane: Thành phần quyết định và cấu hình hệ thống phải chuyển lưu lượng thế nào
    - Thành phần thực sự xử lý và chuyển tiếp lưu lượng khi request xuất hiện 


- Control Plane — Thiết lập đường đi

```
Ingress YAML: app.local → nginx:80
                |
                v
          Kubernetes API
                |
                v
        cloud-provider-kind
                |
                | Cấu hình qua xDS
                v
              Envoy
```

- Data plane: thực sự chuyển request 

```
curl Host: app.local
         |
         v
   Envoy 172.18.0.4:80
         |
         v
     Nginx Backend
         |
         v
       HTTP 200
```

### IP 172.18.0.4 

- Xuất hiện trong câu lệnh 

```
kubectl get ingress -o wide

NAME            CLASS                 HOSTS       ADDRESS
nginx-ingress   cloud-provider-kind   app.local   172.18.0.4,...
```

- 172.18.0.4 được docker cấp cho Envoy Container trên DOcker network 

### các loại IP

```
duong@homelab:~/labs/kubernetes/07-ingress-from-zero$ hostname -I
192.168.0.114 172.17.0.1 172.18.0.1 172.19.0.1 fc00:f853:ccd:e793::1 
```

- 192: mạng Lan
- 172.18.0.4 Docker network , envoy 
- 172.18.0.11 .... Kind Worker hoặc Control Plane 
- 

### Thực hành 

- Gọi 
```sh
duong@homelab:~/labs/kubernetes/07-ingress-from-zero$ hostname -I
192.168.0.114 172.17.0.1 172.18.0.1 172.19.0.1 fc00:f853:ccd:e793::1 
duong@homelab:~/labs/kubernetes/07-ingress-from-zero$ curl -v -H "Host: app.local" http://172.18.0.4/
*   Trying 172.18.0.4:80...
* Connected to 172.18.0.4 (172.18.0.4) port 80
> GET / HTTP/1.1
> Host: app.local
> User-Agent: curl/8.5.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< server: envoy
< date: Sat, 21 Nov 2026 10:07:35 GMT
< content-type: text/html

```

### Vậy cloud-provider-kind

- kết nối đến POd thông qua đâu 
```sh
curl -s http://172.18.0.4:10000/clusters \
  | grep -E '10\.96\.49\.87|10\.244\.1\.(5|7|8)'
```


