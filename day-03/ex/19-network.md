## Block 19 – Network | Câu 1/10


### 1. List the names of the network adapters on your server.

- `Liệt kê tên các network adapter / interface` mà hệ thống đang thấy

```sh
man ip
NAME
       ip - show / manipulate routing, devices, policy routing and tunnels
IP - COMMAND SYNTAX

   OBJECT
       ip addr
           Shows addresses assigned to all network interfaces.

```

- **`Lời giải`**

```sh
[duong@centos7-lab ~]$ ip addr
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:a4:c0:29 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.111/24 brd 192.168.0.255 scope global noprefixroute dynamic enp0s3
       valid_lft 7043sec preferred_lft 7043sec
    inet6 fe80::a6a4:492c:c4f3:6862/64 scope link noprefixroute 
       valid_lft forever preferred_lft forever

```

- Từ `ip addr` ta đang có: 
  - 2 interface `lo` và `enp0s3`
  - Trong đó `lo` là looback interface địa chỉ `127.0.0.1/8`
  - `enp0s3` là network interface chính của VM , đang `UP`
  - IPv4 của `enp0s3` là `192.168.0.111/24`
  - MAC là `08:00:27:a4:c0:29`
  - từ `dynamic` có thể thấy IPv4 này được cấp động. 

- **`Giá trị cốt lõi`**
  - Linux nhìn network qua các interface
    - lo
      - -> Loopback, giao tiếp với chính máy
    - enp0s3
      - interface mạng chính của CentOS VM

### 2. List the IP and MAC address of each of your network adapters.

```
lo:
IP =127.0.0.1
MAC =00:00:00:00:00:00

enp0s3:
IP =192.168.0.111
MAC =08:00:27:a4:c0:29
```

- Loopback ko phải một ethernet NIC thật, nên giá trị `00:00:00:00:00:00` ở đây ko nên hiểu như MAC thật của card mạng

- `lo` có loại link riêng: 
  - `link/loopback`
- `np0s3` link: 
  - `link/ether`

- **`Giá trị cốt lõi cần nắm`**

- IP address
  - -> định danh interface ở layoer 3
- MAC address: 
  - -> định danh  ethernet inteterface ở layer 2
- Loopback: 
  - Không phải Ethernet NIC thật
  - MAC 00:00:00:00:00:00 không mang ý nghĩa như MAC của enp0s3 


### 3. List the cache of MAC-IP addresses of your server.


- `/etc/hosts`

```
127.0.0.1 localhost
::1       localhost
```
- Là mapping kiểu
  - hostname <-> IP
    - Là một file cấu hình tĩnh, ko phải cache DNS
- `/etc/networks`

```
default    0.0.0.0
loopback   127.0.0.0
link-local 169.254.0.0
```

- k phải cache, nó lưu `tên tương ứng với một số network address`. 


- distinction quan trọng: 

```
DNS 
-> Tìm IP Từ hostname

ARP
-> tìm MAC từ IPv4 address trong mạng local
```

- **`Lời giải`**

```sh
man ip
NAME
       ip - show / manipulate routing, devices, policy routing and tunnels
       neighbour
              - manage ARP or NDISC cache entries.
```

```sh
[duong@centos7-lab etc]$ ip n
192.168.0.108 dev enp0s3 lladdr 00:e0:4c:68:10:d3 REACHABLE
192.168.0.1 dev enp0s3 lladdr b0:be:76:a8:10:8a REACHABLE

```

- Khi ta muốn gửi dữ liệu tới một host `cùng LAN` nó đóng dữ liệu vào một Ethernet frame. Ethernet Frame cần một `destination MAC address`
- Vì vậy máy phải biết

```
IP đích trong LAN
-> MAC tương ứng là gì
```

- CentOS đang biết: 

```
192.168.0.108
→ MAC 00:e0:4c:68:10:d3

192.168.0.1
→ MAC b0:be:76:a8:10:8a
```

- Ở đây `192.168.0.1` chính là TP-link

- ở mỗi Hop tiếp theo sẽ cần một Frame

    - VD trên đường đến google
    - Chạm đầu tiên phải qua là Router trong nhà
    - CentOS VM chỉ cần gửi kèm cái Frame của Router.
    - Và router sẽ tự gửi frame nó cần ở chạm tiếp theo

```
CentOS
MAC A
   ↓ frame tới MAC router

Router
MAC B
   ↓ frame mới tới next hop

Router ISP
MAC C
   ↓

...
   ↓

8.8.8.8
```


- **`Giá trị cốt lõi`**

```
ARP / neighbor cache
→ lưu mapping IP ↔ MAC cho neighbor ở local network

IP
→ định danh đích ở Layer 3

MAC
→ dùng cho việc giao frame ở Layer 2 của chặng hiện tại
```


### 4. List the routing table of your server.

- hỏi máy đang biết `đường nào để gửi traffic tới các mạng khác`

```sh
NAME
       ip - show / manipulate routing, devices, policy routing and tunnels

IP - COMMAND SYNTAX
   OBJECT

       route  - routing table entry.

```

```sh
[duong@centos7-lab etc]$ ip route
default via 192.168.0.1 dev enp0s3 proto dhcp metric 100 
192.168.0.0/24 dev enp0s3 proto kernel scope link src 192.168.0.111 metric 100 

```


- `ip route` là lệnh hiển thị routing table.
  - GỒm local network
  - Và địa chỉ thiết bị dùng làm gateway router


- `192.168.0.0/24 dev enp0s3 ...`
  - Nếu đích nằm trong mạng `192.168.0.0/24` gửi trực tiếp qua interface `enp0s3`
- `default via 192.168.0.1 dev enp0s3`
  - Nếu ko có route cụ thể nào phù hợp, gửi cho gateway `192.168.0.1` thông qua `enp0s3`
- Phân biệt với ip addr

```
ip addr 
-> tôi có những interface nào, địa chỉ IP của chúng là gì

ip route
-> nếu muốn gửi tới địa chỉ X , tôi phải đi đường nào
```


### 5. Display the configuration of the network adapters.


- `configuration của network adapter` - Cấu hình được lưu cho interface

- **`File lưu cấu hình mạng`**
  - `/etc/sysconfig/network-scripts`
  - Các file bên trong thường có tên bắt đầu bằng `ifcfg` kèm theo tên card mạng


```
[duong@centos7-lab ~]$ cat /etc/sysconfig/network-scripts/ifcfg-enp0s3 
TYPE=Ethernet
PROXY_METHOD=none
BROWSER_ONLY=no
BOOTPROTO=dhcp
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_FAILURE_FATAL=no
IPV6_ADDR_GEN_MODE=stable-privacy
NAME=enp0s3
UUID=4e9ac8ae-ff8f-4fed-823f-3ecda80303dd
DEVICE=enp0s3
ONBOOT=yes
IPV6_PRIVACY=no

```

- Ý nghĩa: 
  - `TYPE = Ethernet`
    - -> interface kiểu Ethernet
  - `DEVICE=enp0s3`
  - -> cấu hình này áp dụng cho enp0s3
  - `ONBOOT=yes`
  - -> bật interface này khi hệ thống boot
  - `BOOTPROTO=dhcp`
  - -> lấy IP bằng DHCP
  - `DEFROUTE=yes`
  - -> Cho phép interfafce này cung cấp default route

- **`Gía trị cốt lõi cần nắm`**

```
ip addr / ip route
-> trạng thái network hiện tại

/etc/sysconfig/network-scripts/ifcfg-enp0s3
-> cấu hình persistent của interface trên CENtOS
```

### 6. Which DNS server is being used on your server?

- Xem CEntOS hiện tại đang dùng DNS server nào rồi gửi

```sh
[duong@centos7-lab ~]$ cat /etc/resolv.conf 
# Generated by NetworkManager
nameserver 192.168.0.1

```

- trong `/etc/resolv.conf` nghĩa là
    - *DNS resolver mà máy đang dùng là `192.168.0.1`*
- - Hai giá trị của `ip route`  trùng nhau nhưng ý nghĩa khác nhau


```
192.168.0.01 trong ip route
-> default gateway

192.168.0.1 trong resolv.conf
-> DNS Server
```

- Việc trùng nhau là rất bình thường vì router nhà ta vừa làm gateway vừa có thể làm DNS server

- **`Giá trị cốt lõi cần nắm `**

- IP route
- -> đường đi /gateway

- /etc/resolv.conf
- -> DNS resolver hiện tại


### Câu 7. Display the list of TCP and UDP protocols.

- Câu này hơi hiểu nhầm. Thực chất assignment đang uốn xem `server name - port/protcol`  mà linux biết

- *`/etc/services` là bảng tra cứu tên service - port/protocol hoặc chuẩn phổ biến, VD http <-> 80/tcp , chứ ko phải danh sách service đang thực sự chạy*
  - Service: một loại dịch vụ mạng được đặt tên
  - VD http: -> dịch vụ web dùng HTTP

```sh
[duong@centos7-lab etc]$ grep -E '^(ssh|http|https|domain)' /etc/services
ssh             22/tcp                          # The Secure Shell (SSH) Protocol
ssh             22/udp                          # The Secure Shell (SSH) Protocol
domain          53/tcp                          # name-domain server
domain          53/udp
http            80/tcp          www www-http    # WorldWideWeb HTTP
http            80/udp          www www-http    # HyperText Transfer Protocol
http            80/sctp                         # HyperText Transfer Protocol
https           443/tcp                         # http protocol over TLS/SSL
https           443/udp                         # http protocol over TLS/SSL
https           443/sctp                        # http protocol over TLS/SSL
ssh             22/sctp                 # SSH
http-mgmt       280/tcp                 # http-mgmt
http-mgmt       280/udp                 # http-mgmt
http-rpc-epmap  593/tcp                 # HTTP RPC Ep Map
http-rpc-epmap  593/udp                 # HTTP RPC Ep Map
sshell          614/tcp                 # SSLshell
sshell          614/udp                 #       SSLshell
httpx           4180/tcp                # HTTPX
httpx           4180/udp                # HTTPX
http-wmap       8990/tcp                # webmail HTTP service
http-wmap       8990/udp                # webmail HTTP service
https-wmap      8991/tcp                # webmail HTTPS service
https-wmap      8991/udp                # webmail HTTPS service
domaintime      9909/tcp                # domaintime
domaintime      9909/udp                # domaintime
ssh-mgmt        17235/tcp               # SSH Tectia Manager
ssh-mgmt        17235/udp               # SSH Tectia Manager

```

### 8. Test your connection to 8.8.8.8


```sh
[duong@centos7-lab etc]$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=117 time=23.3 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=117 time=23.7 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=117 time=23.6 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=117 time=23.7 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3224ms
rtt min/avg/max/mdev = 23.337/23.629/23.792/0.174 ms

```

- Output cho thấy
  - 4 packet transmitted
  - 4 received
  - 0% packet loss
- Các thành phần chính
    - `icmp_seq=1` -> Số thứ tự của gói pping
    - `ttl=117` TTL còn lại khi resply về tới máy ta . Giới hạn số chặng mà packet được phép đi qua
    - `time=23.3ms` -> thời gian khứ hồi của request/reply 
    - `rtt min/avg/max/mdev = 23.337/23.629/23.792/0.174 ms` : thời gian khứ hồi nhỏ nhất/ trung bình/ lớn nhất/ độ giao động

### 9. Display the hops between you and 8.8.8.8.

```sh

❯ traceroute 8.8.8.8    
traceroute to 8.8.8.8 (8.8.8.8), 30 hops max, 60 byte packets
 1  _gateway (192.168.0.1)  0.558 ms  0.499 ms  25.116 ms
 2  192.168.1.1 (192.168.1.1)  1.346 ms  1.354 ms  1.378 ms
 3  113.22.0.135 (113.22.0.135)  4.042 ms  4.038 ms  4.049 ms
 4  * 118.68.199.205 (118.68.199.205)  4.408 ms *
 5  118.69.189.84 (118.69.189.84)  4.418 ms 118.70.1.124 (118.70.1.124)  4.438 ms 118.69.189.86 (118.69.189.86)  4.320 ms
 6  * 118.70.1.125 (118.70.1.125)  4.334 ms 118.70.1.121 (118.70.1.121)  3.456 ms
 7  * 1.53.123.85 (1.53.123.85)  3.559 ms 118.69.249.26 (118.69.249.26)  23.859 ms
 8  * 118.69.249.26 (118.69.249.26)  21.062 ms 74.125.32.112 (74.125.32.112)  21.675 ms
 9  * * *
10  * dns.google (8.8.8.8)  23.281 ms  24.399 ms

```

- 2 hop đầu tiên
  - hop 1: `192.168.0.1` -> Router TP-link
  - hop 2: `192.168.1.1` Router / ZTE 
  -  113.22.0.135 - 118.68.199.205 - 118.69.x.x -> các router trung gian trên đường tới Google
  -  `*` -> Router không trả lời

### 10. List the open TCP ports on your server.

```sh
[duong@centos7-lab etc]$ ss -lnt
State       Recv-Q Send-Q                                         Local Address:Port                                                        Peer Address:Port              
LISTEN      0      128                                                        *:22                                                                     *:*                  
LISTEN      0      100                                                127.0.0.1:25                                                                     *:*                  
LISTEN      0      128                                                     [::]:22                                                                  [::]:*                  
LISTEN      0      100                                                    [::1]:25                                                                  [::]:*                  

```


- `-l` = Listening
- `-n` = hiện số port, không đổi sang tên như ssh/http
- `-t` = TCP

- Có thể đọc như này
  - `*:22` -> Có service đang listen TCP port `22` trên mọi IPv4 address của máy
  - `[::]:22` -> LIsten port 22 trên IPv6
  - `127.0.0.1:25` | `[::1]:25` -> port `25` chỉ listen trên loopback /localhost
  - Tức là service ở port 25 chỉ nhận connection từ chính máy đó, ko mở ra network bên ngoài

- **`Giá trị cốt lõi`**
  - `ss -lnt` -> liệt kê các TCP socket đang LISTEN