## Block 16 - Disk

## 1. Prepare a (virtual) server with at least three extra disks.

- Trước khi làm các câu sau, VM cần có: 

```
1 Disk chính
+ ít nhất 3 virtual disk phụ
```

- Yêu cầu chuẩn bị phần cứng ảo - ~~KHÔNG phải chạy một command trong CentOS để tạo ra 3 disk~~

- Ta đang mô phỏng việc máy vật lý được gắn thêm storage

```
Máy thật: 
- Gắn thêm HHD
- Gắn thêm SSD
- Cắm thêm USB storage

Virtual Box
- Tạo thêm virtual Disk
- Attach chúng vào VM
```

- Khi VM Boot lên, Linux mới nhìn thấy chúng như các block device mới: 

```
/dev/sda -> disk hệ thống
/dev/sdb -> disk phụ 
/dev/sdc -> Disk phụ 2
/dev/sdd -> Disks phụ 3
```

- Tức là hiểu: 

```
Bước 1 : ở tầng hypervisor
-> cấp thêm 3 virtual disks

Bước 2: ở trong linux
-> Dùng lsblk / fdisk / lssscsi để xác nhận OS đã nhận chúng
```


```sh
[duong@centos7-lab ~]$ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sr0              11:0    1 1024M  0 rom  

```


- `sda` -> Disk
- `sr0` -> ROM

- Hiện tại chỉ có: 
  - 1 disk
- là `sda`
- `sda1`, `sda2` là partition
- `sr0` type = rom: là CD/ DVD drive

- `centos-root` , `centos-swap` -> TYPE = lvm -> logcal vollumn


- **`Tiến hành tọa Disks ảo`**

- Hiện tại: 

```
VirtualBox VM
│
└─ SATA Controller
   │
   └─ CentOS-7.9-manual.vdi
          ↓
       CentOS thấy
          ↓
       /dev/sda
```

- ta muốn thành

```
VirtualBox VM
│
└─ SATA Controller
   ├─ CentOS-7.9-manual.vdi
   ├─ disk-lab-1.vdi
   ├─ disk-lab-2.vdi
   └─ disk-lab-3.vdi
          ↓
       CentOS thấy
          ↓
       /dev/sda
       /dev/sdb
       /dev/sdc
       /dev/sdd
```

- B1: tắt VM
- B2 : Chọn VM -> vào Setting  -> storage
- B3: Hiện tại số port của controller là 1 -> tăng lên 4
- B4: Add Attach ment
- B5: tạo 3 disk ảo
  - Chọn VDI (Format native của Virtual Box)
  - Chọn 2GB - Bài tập chủ yếu yêu cầu inspect
  - Dynamically allocated
  - Choose

- B6: khởi động lại và check lại

```sh
[duong@centos7-lab ~]$ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sdb               8:16   0    2G  0 disk 
sdc               8:32   0    2G  0 disk 
sdd               8:48   0    2G  0 disk 
sr0              11:0    1 1024M  0 rom  
```

- **`Kiến thức thêm: Phân Biệt các thuật ngữ`**

```
VM
└─ Storage Controller
   ├─ Disk 1
   ├─ Disk 2
   ├─ Disk 3
   └─ Disk 4
```

- `Controller` là "Bộ điều khiển /bus" mà storage device kết nối vào: 

```
SATA controller
IDE controller
SCSI controller
NVMe controller
USB controller
```

- Còn `attachment`  là thiết bị Storage cụ thể được gắn vào controller đó: 

```
Controller: SATA
├─ CentOS-7.9-manual.vdi   ← attachment
├─ disk2.vdi               ← attachment
├─ disk3.vdi               ← attachment
└─ disk4.vdi               ← attachment
```

- `port` là "khe/cổng logic" trên storage controller để gắn thiết bị logic vào: 
- Viows SATA Controller: 
```
SATA Controller
├─ Port 0 → disk hệ thống
├─ Port 1 → disk phụ 1
├─ Port 2 → disk phụ 2
└─ Port 3 → disk phụ 3
```

- Trên máy thật: 

```
mainboard/ controller
-> Có nhiều cổng SATA
-> mỗi cổng nối tới một ổ đĩa
```

- Trong Virtual Box các port này là ảo, nhưng Linux bên trong VM sẽ thấy kết quả gần giống như có nhiều ổ được cắm thật

- `Optical Drive` - Ổ đĩa quang, kiểu `CD/DVD drive`. Thường được đóng laser
- 
  

-  **`Kiến thức thêm: SATA và IDE khác nhau thế nào`**
-  IDE: 
   -  Chuẩn Stoarge cũ
   -  Ít device hơn
   -  Thường thấy dùng cho CD/DVD trong VM cũ
-  SATA
   -  Mới hơn
   -  Nhiều port hơn
   -  Phù hợp để attach HDD/SDD ảo
   -  Linux thường thấy disk thành /dev/sda, /dev/sdb 

- **`Giá trị cốt lõi`**
- Cấp thêm storage ở tầng Hypervisor: 

```
VirtualBõ
-> tạo 3 virttual hard disks
-> attach vào SATA controller
-> centOS boot lên và kernel phát hiện chúng
```

- Mental model: 

```
VirtualBox virtual disk file (.vdi)
        ↓
VirtualBox expose như hardware ảo
        ↓
Linux kernel nhận diện
        ↓
/dev/sda, /dev/sdb, /dev/sdc, /dev/sdd
        ↓
lsblk hiển thị chúng
```

- 1 điểm nữa: 
  - Disk mới tạo chưa có partition,
  - chưa có filesystem,
  - chưa có mount gì cả
- Nhưng linux vẫn nhìn thấy chúng là block devices 

- Điều đó cho thấy
  - *Block device tồn tại trước partition và filesystem*

## 2. List all block devices in /dev

- Mục tiêu phần này là nhìn trực tiếp `device specciak files` trong `/dev` thay vì `lsblk`


```sh
[duong@centos7-lab ~]$ ls -l /dev | grep '^b'
brw-rw----. 1 root disk    253,   0 Sep 27 15:54 dm-0
brw-rw----. 1 root disk    253,   1 Sep 27 15:54 dm-1
brw-rw----. 1 root disk      8,   0 Sep 27 15:54 sda
brw-rw----. 1 root disk      8,   1 Sep 27 15:54 sda1
brw-rw----. 1 root disk      8,   2 Sep 27 15:54 sda2
brw-rw----. 1 root disk      8,  16 Sep 27 15:54 sdb
brw-rw----. 1 root disk      8,  32 Sep 27 15:54 sdc
brw-rw----. 1 root disk      8,  48 Sep 27 15:54 sdd
brw-rw----. 1 root cdrom    11,   0 Sep 27 15:54 sr0

```


- Khi chưa có lọc grep có rất nhiều loại file; 
- Điểm cần nhìn đầu tiên: `ký tự đầu tiên mỗi dòng`

```
brw-rw----. ... sda
brw-rw----. ... sdb

crw-------. ... console
drwxr-xr-x. ... block
lrwxrwxrwx. ... cdrom -> sr0
```

- ở đây: 
  - `b` = block device
  - `c` = character device
  - `d` = directory 
  - `l` = symbolic link
- Các block device trong output

```
brw-rw----. ... dm-0
brw-rw----. ... dm-1

brw-rw----. ... sda
brw-rw----. ... sda1
brw-rw----. ... sda2
brw-rw----. ... sdb
brw-rw----. ... sdc
brw-rw----. ... sdd

brw-rw----. ... sr0
```

- Điểm đáng chú ý: 
  - `/dev/sda`, `/dev/sdb` là block devices special files đại diện cho disk

```
/dev/sda
├─ /dev/sda1
└─ /dev/sda2
```

- Cả `disk và parittion` đều là block device, nên đều bắt đầu bằng `b`

- `dm-0`, `dm-1` cũng là block device. Chúng chính là các device-mapper devices mà LVM của CentOS đang sử dụng
```
centos-root
centos-swap
```

- Còn `/dev/sr0`
  - là topical drive, nhưng vẫn là `block device` vì CD/DVD cũng được kernel truy cập theo block

- **`Giá trị cốt lõi`**

```
/dev
→ chứa device special files

b ở đầu ls -l
→ block device

c
→ character device

disk và partition đều có thể là block device

/dev/sda  → whole disk
/dev/sda1 → partition
/dev/sr0  → optical block device
/dev/dm-* → device-mapper block device
```

- */dev/sdb không phải là "file chứa dữ liệu của ổ đĩa" nó là special file interface mà process dùng để truy cập block device do kernel quản lý*


## 3. List all block devices on the computer (not using ls).


- Chuyển sang một tool chuyên dụng để xem block device thay vì đọc trực tiếp `/dev`
- Hint: command dùng nhiều lần để nhìn cây

```
disk
├─ partition
└─ logical volume
```

- **`Lời giải`**

```sh
[duong@centos7-lab ~]$ lsblk
NAME            MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda               8:0    0   20G  0 disk 
├─sda1            8:1    0    1G  0 part /boot
└─sda2            8:2    0   19G  0 part 
  ├─centos-root 253:0    0   17G  0 lvm  /
  └─centos-swap 253:1    0    2G  0 lvm  [SWAP]
sdb               8:16   0    2G  0 disk 
sdc               8:32   0    2G  0 disk 
sdd               8:48   0    2G  0 disk 
sr0              11:0    1 1024M  0 rom  


```

- `sdb`, `sdc`, `sdd` 
  - chưa được mount
  - Cũng chưa có partition
  - chưa có filesystem

- Lsblk cho ta thấy rất rõ

```
Disk tồn tại
!= 
disk đã có partition
!=
disk đã có filesystem
!= 
disk đã mount
```

- **`Giá trị cốt lõi`**
- `lsblk` là tool chuyên để liệt kê `block devices` và quan hệ cha-con của chúng

```
TYPE=disk
→ whole disk

TYPE=part
→ partition

TYPE=lvm
→ logical volume

TYPE=rom
→ optical drive
```

## 4. Tiếp theo là Câu 4/7: Verify that the block devices use the sd driver. 

- Mục tiêu cần nối 2 thứ lại với nhau

```
lsblk
-> thấy MAJ:MIN của device

/proc/devices
-> xem major number đó thuộc driver nào
```

- **`Đáp án`**

```sh
cat /proc/devices | grep '^\s*8'
8 sd
```

- **`Kiến thức thêm: MAJ:MIN dùng để làm gì `**
- trong Linux mỗi dvice special file có 2 số: `MAJOR: MINOR`

- VD
```
sda → 8:0
sdb → 8:16
sdc → 8:32
sdd → 8:48
```

- `Major Number là gì`
- Major number dùng để nói: 
  - *Device này thuộc về driver/device class nào*

```sh
cat /proc/devices | grep '^\s*8'
8 sd
```

- Nghĩa là: 
```
major 8
-> sd driver
```

- Vậy sdX đều có major = 8 , nên đều đi qua `sd`

- `minor number là gì `
- Minor number dùng để phân biệt `các device cụ thể` cùng nằm dưới một major/driver

```
MAJOR
→ loại / driver

MINOR
→ instance cụ thể trong loại đó
```

- **`Giải thích thêm: `**
- Khi ta tạo một Virtual Box và attach nó vào `SATA Controller`

```
VirtualBox
   │
   ├─ SATA controller ảo
   │
   └─ virtual hard disk
```

- CentOS không thể tự nhiên "nói chuyện" trực tiếp với cái disk đó. Kernel cần software biết cách điều khiển hardware/controller

- Trước ta dùng `lshw`

```
SATA COntroller
configuration: driver=ahci
```

- Vậy:

```
Virtual SATA controller
        ↓
      AHCI driver
        ↓
Linux nhận ra storage device
```

- Cần thông qua một thứ ... rồi biểu diễn SATA/ATA disk cho tầng trên theo mô hình SCSI
```
Virtual SATA disk
      ↓
AHCI / libata
      ↓
SCSI storage layer
      ↓
sd driver
      ↓
block device
      ↓
/dev/sda
```

- `sd` là driver ở tầng `SCSI-disk` abstraction và cuối cùng được `sd` xử lý ở tầng disk

- Nên tên và adriver cho ta biết Linux đang đi qua loại storage stack nào
- VD các family khác: 


```
| Device               | Ví dụ tên      | Driver/family |
| -------------------- | -------------- | ------------- |
| SATA/SCSI-style disk | `/dev/sda`     | `sd`          |
| NVMe                 | `/dev/nvme0n1` | NVMe          |
| VirtIO block         | `/dev/vda`     | virtio-blk    |
| Loop                 | `/dev/loop0`   | loop          |
| LVM/device mapper    | `/dev/dm-0`    | device-mapper |

```


```
/dev/sdb
   ↓
major = 8
   ↓
kernel biết đây thuộc sd block-device family
   ↓
sd/storage stack xử lý request
```


### 5. Use fdisk to list all disks


```sh
[duong@centos7-lab ~]$ sudo fdisk -l
[sudo] password for duong: 

Disk /dev/sdd: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sda: 21.5 GB, 21474836480 bytes, 41943040 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk label type: dos
Disk identifier: 0x000a35cc

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     2099199     1048576   83  Linux
/dev/sda2         2099200    41943039    19921920   8e  Linux LVM

Disk /dev/sdc: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/sdb: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-root: 18.2 GB, 18249416704 bytes, 35643392 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes


Disk /dev/mapper/centos-swap: 2147 MB, 2147483648 bytes, 4194304 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes

```


```
sda = whole disk 20G

sda1 = partition ~1G
sda2 = partition ~19G

sda2
→ được dùng cho LVM
→ tạo centos-root + centos-swap

sdb/sdc/sdd
→ 3 disk mới
→ chưa partition
```

- Parition là một khoảng Sector trên Disk, được mô tả bởi start/end


- `/dev/ampper/...`

- Không phải thêm 2 ổ ccunwgs vật lý/virtual disk mới: 

```
20G disk /dev/sda
│
├── 1G /dev/sda1
│       └── mounted /boot
│
└── 19G /dev/sda2
        └── LVM
            ├── ~17G centos-root
            │       └── mounted /
            │
            └── 2G centos-swap
                    └── swap
```

- `swap là gì ?`
  - `centos-swap` là một logical volume dành cho `swap space` 
  - Nó không phải filesystem để ta lưu file bình thường và mount kiểu `/home`
  - Nó là vùng storage mà linux có thể dùng hỗ trợ quản lý memory khi cần

- **`fdisk -l khác lsblk ở đâu`**

- `lsblk` mạnh cho việc ta nhìn
  - quan hệ cha con
  - disk -> partition -> LVM
- Còn `fidisk` cho ta nhieeuyf thông tin thấp hơn về disk/partition
  - disk size
  - sector count
  - sector size
  - partition table
  - partition start/end
  - partition type

- 2 tool bổ xung cho nhau

## 6. Use lsscsi to list all SCSI devices.

- Câu này muốn ta xem Linux đang nhìn các storage device qua `SCSI layer` như thế nào

```sh
[duong@centos7-lab ~]$ lsscsi
[0:0:0:0]    cd/dvd  VBOX     CD-ROM           1.0   /dev/sr0 
[2:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sda 
[3:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdb 
[4:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdc 
[5:0:0:0]    disk    ATA      VBOX HARDDISK    1.0   /dev/sdd 

``` 

- `lsscsi` cho ta nhìn các device theo `SCSI subsystem`

```
[2:0:0:0]  disk  ATA  VBOX HARDDISK  1.0  /dev/sda
```

- Đây là một disk
- Vendor /interface được nhận là ÂT
- model là : VBOX harddisk
- Device node phía sau user space là `/dev/sda`


```
VirtualBox SATA disk
        ↓
ATA/SATA handling
        ↓
SCSI subsystem
        ↓
sd disk driver
        ↓
/dev/sda
```


- **`Cốt lõi của câu hỏi`**
- Linux có một taagnf chung để biểu diễn nhiều loại thiết bị lưu trữ theo kiểu SCSI . `lsscsi`  cho ta xem danh sách thiết bị mà tầng đó đang quản lý

- Nó nói: 
  - Linux thấy một thiết bị lưu trữ
  - -> loại disk
  - -> thiết bị gốc là VBOX HARDDISK
  - -> Giao diện /nguồn là ATA
  - -> device node để user space dùng là /dev/sda

## 7. Use lshw and look at the complete device tree.


```sh
sudo lshw
```

- **`Điểm cốt lõi`**
- Đọc hiểu `cấu trúc cha-con`

- Phần liên quan đến disk

```
*-pci
   ...
   *-sata
        description: SATA controller
        configuration: driver=ahci
        ...
        *-disk:0
             logical name: /dev/sda
             ...
             *-volume:0
                  logical name: /dev/sda1
                  logical name: /boot
             *-volume:1
                  logical name: /dev/sda2

        *-disk:1
             logical name: /dev/sdb

        *-disk:2
             logical name: /dev/sdc

        *-disk:3
             logical name: /dev/sdd
```

```
PCI bus
  ↓
SATA controller
  ↓
AHCI driver
  ↓
disk
  ├─ /dev/sda
  ├─ /dev/sdb
  ├─ /dev/sdc
  └─ /dev/sdd
```

- `lshw` nối các lớp cắt của các command trước
  - `lsblk` 
    - disk
    - -> parittion
    - -> LVM
    - -> mount point
  - `fdisk -l` 
    - -> sector
    - -> partition boundaries
  - `lsscsi`
    - storage device
    - -> SCSI address
    - -> /dev/sdX
  - `lshw` cho ta thấy
    - machine
    - -> motherboard
    - -> PCI
    - -> SATAController
    - -> Driver
    - -> disk
    - -> partition

- `lshw` là bức tránh hardware tổng thể, và cho thấy heirarchy giữa các thành phần