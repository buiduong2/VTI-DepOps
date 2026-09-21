## 1. Put a sorted list of all bash users in bashusers.txt.

```sh
duong@homelab:~/VTI-ex$ grep '/bin/bash$' /etc/passwd | cut -d: -f1 | sort > bashusers.txt
duong@homelab:~/VTI-ex$ cat bashusers.txt 
duong
root

```

- Kiến thức cần nắm: 
  - file chứa thông tin user `/etc/passwd`
  - bash user là những user mà login shell của họ được đặt là bash
    - `username:x:UID:GID:comment:home:shell`
    - Trường cuối thường là `/bin/bash`   
  - `grep`  : tìm kiếm các dòng theo tiêu chí
  - `find` = tìm file thư mục
  - `sed` = biến đổi chỉnh sửa text
  - `cut` lấy field cần thiết

- `cut`
  - `:` = Kí tự phân cách field
  - `-f1`= field đầu tiên = username


## 2. Put a sorted list of all logged on users in onlineusers.txt.

- Tạo `onelineusers.txt` chứa danh sách username của các user `đang đăng nhập` và sort danh sách đó

- gợi ý: cần một lệnh để xem ai đang login hiện tại

```sh
duong@homelab:~/VTI-ex$ who | cut -d' '  -f1 | sort  > onlineusers.txt
duong@homelab:~/VTI-ex$ cat onlineusers.txt 
duong

```


- Kiến thức cần nắm: 
- `who` : dùng để hiển thị `những user đang logged in`
  - Trên LInux truyền thống . `who` đọc database login record thường liên quan đến `/run/utmp`
  - Hoặc cơ chế tương đương tùy distro/system
  - Khi một login mechanism tạo session và cập nhật record này thì `who` thấy

## 3. Make a list of all filenames in /etc that contain the string conf in their filename.

- Liệt kê tất cả tên file trong /etc mà tên file có chứa chuỗi conf.

```sh
duong@homelab:~/VTI-ex$ ls -1 /etc | grep conf 
adduser.conf
ca-certificates.conf
ca-certificates.conf.dpkg-old
dconf
debconf.conf
deluser.conf
dhcpcd.conf
e2scrub.conf
fuse.conf
gai.conf
hdparm.conf
host.conf
ld.so.conf
ld.so.conf.d
libaudit.conf
locale.conf
logrotate.conf
manpath.config
mke2fs.conf
multipath.conf
netconfig
nftables.conf
nsswitch.conf
overlayroot.conf
pam.conf
resolv.conf
rsyslog.conf
sensors3.conf
smartd.conf
sudo.conf
sudo_logsrvd.conf
sysctl.conf
ucf.conf
usb_modeswitch.conf
vconsole.conf
xattr.conf

```

- Giá trị cốt lõi: 
  - `ls -1 /etc` liệt kê từng tên trên một dòng
  - `grep conf` -> giữ lại các dòng chứa conf


- Đáp án thực tế là lọc tên entry (ko phải file name thực sự - kể cả solution)

## 4. Make a sorted list of all files in /etc that contain the case insensitive string conf in their filename.

- Vẫn tìm tên có `conf`
- Nhưng ko phân biệt hoa thường
- và phải sort

```sh
duong@homelab:~/VTI-ex$ ls -1 /etc | grep -i conf | sort
adduser.conf
ca-certificates.conf
ca-certificates.conf.dpkg-old
dconf
debconf.conf
deluser.conf
dhcpcd.conf
e2scrub.conf
fuse.conf
gai.conf
hdparm.conf
host.conf
ld.so.conf
ld.so.conf.d
libaudit.conf
locale.conf
logrotate.conf
manpath.config
mke2fs.conf
multipath.conf
netconfig
nftables.conf
nsswitch.conf
overlayroot.conf
pam.conf
resolv.conf
rsyslog.conf
sensors3.conf
smartd.conf
sudo.conf
sudo_logsrvd.conf
sysctl.conf
ucf.conf
usb_modeswitch.conf
vconsole.conf
xattr.conf

```

- Giá trị cốt lõi: 
  - `-i` case -intensitive
  - Nên sẽ matchc ả `conf, CONF, Conf, COnF`

- Một chi tiết nhỏ . `ls` vốn thường đã sort tên nên có thể dùng thêm `sort` là thừa


## 5. Look at the output of /sbin/ifconfig. Write a line that displays only ip address and the subnet mask.

- Xem output của `/sbin/ifconfig` rồi viết một pipeline chỉ hiển thì UP `IP adress` và `Subnet mask`

```sh
duong@homelab:~/VTI-ex$ /sbin/ifconfig


```

- Trên ubuntu mới, `ifconfig` thường ko được cài mặc định vì nó thuộc packaget `net-tools`

```sh
sudo apt install net-tools
```

```sh
duong@homelab:~/VTI-ex$ /sbin/ifconfig


```

- Trên ubuntu hiện đại người ta thường dùng

```sh
ip addr
```

- `IP address là gì`
  - IP address là `địa chỉ của một interface mạng` trên một mạng IP
  - Ta có `192.168.0.110` là IPv4 address của interface `eno2`
  - IP address = Địa chỉ để máy khác biết: "Máy /interface này ở đâu trong mạng"
- `Subnet là gì`
  - Subnet là `một mạng con` tức một nhóm các IP được coi là cùng một mạng
  - VD má yta có: 

```sh
IP:      192.168.0.110
Netmask: 255.255.255.0
```

- Netmask : `255.255.255.0` tương đương `/24`
- Nó cho biết phần nào của IP là `network` phần nào là host
- `192.168.0.110/24`
- Có thể hiểu: 
  - `192.168.0` = phần mạng
  - `110` = phần host

- Đáp án

- Tư duy : 
  - Lọc đúng dòng
  - -> chuẩn hóa khoảng trắng `tr`
  - -> tách theo dấu cách 
  - -> Lấy field cần thiết
```sh
duong@homelab:~/VTI-ex$ ifconfig | grep 'inet ' | tr -s ' ' | cut -d' ' -f3,5 | head -n 1
192.168.0.110 255.255.255.0

```

- `ifconffig`
  - -> grep 'inet' -# giữ các dòng IPv4
  - -> tr -s ' ' # nén nhiều space thành 1
  - -> cut -d' ' -f3,5 # lấy IP và netmask theo vị trí field
  - -> Head -n 1       # Chỉ lấy interface đầu tiên

- Đây là kiểu parse text theo format cỗ định

## `tr -s` = `squeeze repeasts`

```sh
echo "a     b   c" | tr -s ' '
"a b c"
```

- Ép các chuỗi kí tự liên tiếp thành một kí tự duy nhất

## 6. Write a line that removes all non-letters from a stream

- Một stream dữ liệu đang đi qua
- Công cụ nào có khả năng `xóa kí tự không phải chữ cái`  khỏi stream. 

```sh
duong@homelab:~/VTI-ex$ echo "abc 123 \!@# def" | tr -cd '[:alpha:]'
abcdefduong@homelab:~/VTI-ex$ 

```

- `tr` có 3 ý lớn: 
  - Traslate SET1 -> SET2
  - Delete : -d
  - Complement : -c 

## 7. “Write a line that receives a text file, and outputs all words on a separate line.”

```sh
duong@homelab:~/VTI-ex$ echo "it is very cold today without the sun" | tr -s ' ' | tr ' ' "\n"
it
is
very
cold
today
without
the
sun

```

- Giá  trị cốt lõi cần lắm: 
  - ở câu này `tr` đang dùng chức năng gốc của nó làm `translate`
  - `' ' -> '\n'`
  - Tức space -> new line

## 8. “Write a spell checker on the command line. (There may be a dictionary in /usr/share/dict/.)”

- Ý tưởng bài toán: 
  - mỘt đoạn text
  - + Một danh sách từ đúng (dictionary)
  - Tìm những từ xuất hiện trong text nhưng KHÔNG có trong dictionary

- VD: 

```
Text:
The zun is shining today

Dictionary:
is
shining
sun
the
today
```

- Ngầm định `DICT` đã được sort

```sh
todayduong@homelab:~/VTI-ex$ printf "is\nshining\nsun\nthe\ntoday\n"  | tr 'A-Z' 'a-z' > dict.txt
duong@homelab:~/VTI-ex$ cat dict.txt 
is
shining
sun
the
today
duong@homelab:~/VTI-ex$ sort dict.txt -o dict.txt 
duong@homelab:~/VTI-ex$ printf "The zun is shining today\n" > word.txt
duong@homelab:~/VTI-ex$ cat word.txt 
The zun is shining today



duong@homelab:~/VTI-ex$ cat word.txt | tr ' ' '\n' | tr 'A-Z' 'a-z' | sort | uniq | comm -23 - dict.txt 
zun


```


- Chốt: 
  - `tr ' ' '\n'` Mỗi từ thành một dnogf
  - `tr 'A-Z' 'a-z'` Chuẩn hóa lowercase
  - sort bắt buộc trước kh idungf
  - dict cũng phải được chuẩn hóa cùng kiểu và phải sorted
  - `uniq` chỉ loại các từ trùng lặp liền nhau


### `comm`

- `comm` là command dùng để `so sánh 2 file text đã được sắp xếp theo dòng`

- Cú phpas

```sh
comm file1 file2
```

- output chia 3 cột

```
cột 1 = dòng chỉ có trong file1
cột 2 = dòng chỉ có trong file2
cột 3 = dòng có trong cả 2 file
```

```
file1:
apple
banana
zun

file2:
apple
banana
sun
```