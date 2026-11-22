## Câu lệnh run 

```sh
docker compose run --rm \
  -e SPRING_JPA_HIBERNATE_DDL_AUTO=update \
  chat-be
```

### Gới thiệu

- Lab học tập deploy một dự án 3 module Auth , Chat , Chat App chuẩn bị triển khai cho Deploy lên Kubernetes
- Mong muốn: 
    - Các Image chạy thành công trên môi trường Docker
    - App hoạt động tạm ổn



### Lưu ý: 

- Hệ thống không có migrate. nên có thể cần tạo thêm các COntainer chỉ chạy 1 lần và thêm env liên quan đến Hibernete tự sinh bảng lần đầu để tạo ra các table cần thiết. Nếu ko thì copy ở trong thư mục dumps 


## 4. Quick Start

```bash
# Chạy docker compose 
docker compose up -d


# Chạy trên máy host để có thể thử 
ssh -N \
  -L 8081:127.0.0.1:8081 \
  -L 8080:127.0.0.1:8080 \
  -L 3000:127.0.0.1:80 \
  duong@homelab.local
```

- Truy cập 
    - http://localhost:3000/
    - http://localhost:3000/login-admin
        - username: ROOT_USER
        - pass: {tương ứng trong env}
