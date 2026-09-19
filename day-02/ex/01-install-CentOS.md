### 1. Tải iso

```sh
wget -c \
  https://vault.centos.org/7.9.2009/isos/x86_64/CentOS-7-x86_64-DVD-2009.iso
```

- `-c` = `--continue` 
  - Nế bị ngắt khi đang download. Tiếp tục chạ lại lệnh. wget tiếp tục từ phần đã tải

- **`Kiến thức`**
  - ISO = ảnh của phương tiện cài đăt
    - = Chứa CentOS và Installer
    - != hệ điều hành đã đươc cài trên virtual disk

- Ảnh: 
```
Một đĩa hoặc một môi trường đã dược tổ chức
        ↓ đóng lại thành file
Image
        ↓ Sử dụng để tài tạo/ gắn / chạy
Một đĩa hoặc môi trường tương ứng
```

- Image là một artifact đóng gói trạng thái/ nội dung cần thiết để tạo một đói tượng hoặc môi trường chạy theo mong muốn

### 2. Kiểm tra Intergrity

- `Tải file SHA256`

```sh
wget https://vault.centos.org/7.9.2009/isos/x86_64/sha256sum.txt \
  -O sha256sum.txt

# Xem nội dung checksum cho một phiên bản cụ thể
grep 'CentOS-7-x86_64-DVD-2009.iso' sha256sum.txt
e33d7b1ea7a9e2f38c8f693215dd85254c3a4fe446f93f563279715b68d07987  CentOS-7-x86_64-DVD-2009.iso


# Kiểm tra checksum của file vừa tải
sha256sum CentOS-7-x86_64-DVD-2009.iso
e33d7b1ea7a9e2f38c8f693215dd85254c3a4fe446f93f563279715b68d07987  CentOS-7-x86_64-DVD-2009.iso

```


### 3. Tạo VM

- `1. VM Name`
  - CentOS-7.9-manual
- `2. Không bật mục:`
  - Proceed with Unattended Installation
  - Ta sẽ tự đ qua các bước để hiểu phân vùng, mạng user, boot
  - Nếu bật thì bị che mất các phần thực hành quan trọng

### 4. Cấu hinh phần cứng

#### 4.1. Cấu hình phần cứng ảo hóa 


- Base Memory - Cấu hình RAM; 4GB
- Processors 2CPU - Cấu hình CPU ảo
- Enable EFI: Dùng chế độ BIOS truyền thống

- `Enable EFI`
  - Bật chế độ Boot kiểu UEFI
  - là một firmware


#### 4.2. Cấu hình Đĩa cứng ảo hóa - 

- Create a Virtual Hard Disk Now
- Disk Size: 20.00 GB
- Pre-allocate Full Size: không chọn

- `Ý nghĩa`
  - Virtual Box sẽ tạo một file ổ đĩa 
    - CentOS ở bên tong sẽ nhìn file dó như một ổ cứng thật thường là `/dev/sda`
    - `20GB` dung lượng tối đa mà guest có thể sử dụng
    - `pre-allocate full size`: ổ đĩa được cấp phát động


### 5. Bấm Finish

- Trạng thái hineje tại

```
Cấu hình phần cứng VM
- Ổ cứng ảo gần như trống
```


- Kết quả:

- Quan sát Storage
  - Optinal Drive : CentOS...iso
    - ISO centIOS đang gắn vào ổ quang ảo qua IDE
- Network : NAT 
- Ổ cứng ảo 20GB qua SATA
- VM hiện power off

- `SATA`
  - SATA : Controller ảo dùng để kết nối file ổ đĩa đó với VM
- `NAT`
  - Chế độ kết nối mạng mặc định của VirtualBox
  - một router nhỏ
```
CcentOS VM
-> Nat của VirtualBõ
-> Mạng Của Ubuntu host
-> ROuter
-> Internet
```

- VM Tương đối tách biệt kohir mạng LAN
- Muốn SSH từ host vào VM thường cần `port forwarding` hoăc đổi sang `bridged adapter`

### 6.Cấu hình Boot Manager

- 1. Chọn VM -> SEttings
- 2. System -> mother board
- 3. Boot order
- 4. Bỏ chọn floppy
- 5. Đưa Optical lên tren Hard Disk

- Ý nghĩa của boot order
  - Lần đầu , firmware tìm thấy ISO ở Optical -> Chạy trình cài CentOS
  - sau khi cài và thao ISO, Firmware bỏ qua OPtical -> boot CentOS từ Hard Disk / VDI
  - VM không có ổ mềm thực tế nên `Floppy` không có giá trị

#### 7. Cấu hình Display - Phần cứng độ họa


```
CentOS
-> driver đò họa
-> card đồ họa ảo VMSVGA
-> VIrtualBox xử lý
-> GPU/ màn hình thật của laptop
```

- 1. Chọn VM -> SEttings
- 2. Display
- 3. Graphics Controller: VMSVGA
- 4. Video Memory: 128 MB
- 5. Enable 3D Acceleration: bật

- `Graphics Controller: VMSVGA`
  - Chọn loại card đồ họ ao mà VirtualBox trình bày cho CEntOSSm, Guest sẽ nghĩ nó đang giap tiếp với một thiết bị đồ họa
- `Video memory: 128MB`
  - Cấp bộ nhớ cho card đồ họa, dùng cho framebuffer, độ phâ giải và dữ liệu hiển thị. Bộ nhớ này đươc virtualbõ cấp từ tài nguyê host, 
- `Enable 3D Acceleration`
  - Cho phép một số tác vụ đồ họa 3d của Guest đượ VirtualBox chuyển xuống hệ thống đồ họa của host để xử lý
- `Độ phâ giải`
  - Độ phân giải phụ huộc cài đặt trong desktop, driver, 

### 8. Khởi động máy tính

```
VM được cấp nguồn
_> BIOS ảo chạy
-> kiểm tra Optical trước
-> THấy ISO centOS
-> Chạy bootloader trong ISO
-> hiện menu cài đặt CentOS
```


### 9. Bắt đàu install

-` Install CentOS 7`: khởi động thẳng trình cài đặt.
- `Test this media & install CentOS 7`: kiểm tra ISO trước rồi cài. Ta đã tự kiểm tra SHA-256 nên không cần.
- `Troubleshooting:` các chế độ cứu hộ hoặc xử lý lỗi boot.


- SAu khi bấm enter

```
Bootloader trong ISO
-> nạp Linux kernel tạm thời
-> khởi động môi truowgf cài đât
-> Chạy Anaconda installer 
```


### 10. Cấu hình Summary

-  Language: English
-  Localization: múi giờ
   -  Asia
   -  HCM
      -  Ảnh thưởng thời gian log
      -  Lịch chạy cron
      -  Dấ thời gian của file
      -  Việc dố chiếu sự kiện giữa nhieuf server
-  Software: Nguồn cài đặt và nhóm phần mềm
   -  Chọn tập hợp package đươc cài ban đầu
   -  Minimal install 
   -  không chọn add-on
   -  
-  System: ổ đĩa net work , hostname, kDUM
   - Installtaion desitnation
   - hostname

```
VirtualBox: Intel PRO/1000 MT Desktop
CentOS:     enp0s3
MAC:        08:00:27:A4:C0:29
Trạng thái: Disconnected / OFF
```

- Enp0s3 : tên interface trong linux
  - `en` : Ethernet
  - `p0s3` vị trí thiết bị trên bus PCI ảo


- 1. Bật NAT ON
- 2. Hostname : centos7-lab

### 3. Bấm Begin installation

- tạo partition / filesystem trên /dev/sda
- -> cài bootloader
- -> Chép package từ ISO vào VDI
- -> tạo cấu hình hệ thống

#### 4. Cài đặt usernamea password

- Cài đặt mât khẩu cho root
  - Tài khoản quản trị cao nhất, có quyền toàn hệ thống
- Cài đặt user
  - duong
  - Bật require password to use
  - make this user administrator: 
    - thêm duong vào group `wheel` - có quyề thực hiện sudo

### Vào và test

```sh
[duong@centos7-lab ~]$ whoami
duong
[duong@centos7-lab ~]$ hostname
centos7-lab
[duong@centos7-lab ~]$ cat /etc/centos-release
CentOS Linux release 7.9.2009 (Core)
[duong@centos7-lab ~]$ uname -r
3.10.0-1160.el7.x86_64
[duong@centos7-lab ~]$ lsblk -o NAME,TYPE,FSTYPE,MOUNTPOINT
NAME            TYPE FSTYPE     MOUNTPOINT
sda             disk
├─sda1          part xfs        /boot
└─sda2          part LVM2_member
  ├─centos-root lvm  xfs        /
  └─centos-swap lvm  swap       [SWAP]
sr0             rom
[duong@centos7-lab ~]$ df
Filesystem              1K-blocks    Used Available Use% Mounted on
devtmpfs                  1903612       0   1903612   0% /dev
tmpfs                     1915548       0   1915548   0% /dev/shm
tmpfs                     1915548    8748   1906800   1% /run
tmpfs                     1915548       0   1915548   0% /sys/fs/cgroup
/dev/mapper/centos-root  17811456 1287448  16524008   8% /
/dev/sda1                 1038336  153424     884912  15% /boot
tmpfs                      383112       0    383112   0% /run/user/1000
[duong@centos7-lab ~]$
```

- `sda` toan bộ ổ đĩa VDI 20GiB
- `sda1` : parittion XFS , mount tại `/boot`
- `sda2` : Partition dùng là LVM physical volumn
- `centos-root`: logical volumn XFS , mount tại `/`
  

```
CentOS-7.9-manual.vdi
→ /dev/sda
  → /dev/sda1 → XFS → /boot
  → /dev/sda2 → LVM
      → centos-root → XFS → /
      → centos-swap → swap
```

- Partition chia ổ đĩa thành vùng
- LVM thêm một tầng quản lý dung lượng linh hoạt
- ilesystem XFS : tổ chức file bên trong volumn
- Mount point : đưa file system và cây thư mục linux

- `Kiểm tra khác`

```sh
[duong@centos7-lab ~]$ sudo whoami

We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things:

    #1) Respect the privacy of others.
    #2) Think before you type.
    #3) With great power comes great responsibility.

[sudo] password for duong: 
root
[duong@centos7-lab ~]$ sudo whoami
root
[duong@centos7-lab ~]$ ip addr show enp0s3
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP group default qlen 1000
    link/ether 08:00:27:a4:c0:29 brd ff:ff:ff:ff:ff:ff
    inet 10.0.2.15/24 brd 10.0.2.255 scope global noprefixroute dynamic enp0s3
       valid_lft 85591sec preferred_lft 85591sec
    inet6 fd17:625c:f037:2:a64c:300e:fdfc:85e1/64 scope global noprefixroute dynamic 
       valid_lft 86305sec preferred_lft 14305sec
    inet6 fe80::a6a4:492c:c4f3:6862/64 scope link 
       valid_lft forever preferred_lft forever
[duong@centos7-lab ~]$
```


### Các thông sô khác


```sh
❯ VBoxManage showmediuminfo  "/home/duong/VirtualBox VMs/CentOS-7.9-manual/CentOS-7.9-manual.vdi" 

UUID:           ce710072-c9ba-4092-80d0-378918882232
Parent UUID:    base # Parent sẽ quan trọng khi ta tạo linked Clone sau này
State:          locked write
Type:           normal (base)
Location:       /home/duong/VirtualBox VMs/CentOS-7.9-manual/CentOS-7.9-manual.vdi
Storage format: VDI
Format variant: dynamic default
Capacity:       20480 MBytes
Size on disk:   1632 MBytes
Encryption:     disabled
Property:       AllocationBlockSize=1048576
In use by VMs:  CentOS-7.9-manual (UUID: 57324579-d0a7-46d5-8246-e0c9fc045698)

```

### Tắt VM đúng cách: 


```sh
sudo poweroff
```

### Remove Disks khỏi virtual Drive

- Kiểm tra tháo ISO
- Settings -> Storage -> optiocal Drive

#### Cấu hình - Boot Order lại

- 1. Setting -> System -> mother board
- -> Chọn hard disk đưa lên order cao hơn
- Floppy và NetWork không đực chọn
- ok

