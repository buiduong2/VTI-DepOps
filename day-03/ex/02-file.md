## Câu 1  List the files in the /bin directory.

##  Câu 2: Display the type of file of /bin/cat, /etc/passwd and /usr/bin/passwd.

- Chỉ muốn biết Object/file type. ko phải permission hay extension

```sh
[duong@centos7-lab /]$ file /bin/cat /etc/passwd /usr/bin/passwd
/bin/cat:        ELF 64-bit LSB executable, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=b97cc8358edb123e8a9e21390f30924fe66a5e55, stripped
/etc/passwd:     ASCII text
/usr/bin/passwd: setuid ELF 64-bit LSB shared object, x86-64, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.32, BuildID[sha1]=dee1b9ab6618c6bfb84a14f85ba258c742cf4aec, stripped


duong@homelab:/$ file /bin/cat /etc/passwd /usr/bin/passwd
/bin/cat:        ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=9de7eeef378bdfd62a7e79c05c5381d560b57f15, for GNU/Linux 3.2.0, stripped
/etc/passwd:     ASCII text
/usr/bin/passwd: setuid ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=2344480b478a675609210ed886207d6cbdc8cdd7, for GNU/Linux 3.2.0, stripped

```


- `/etc/paswd`
  - là file `text` : ASSCII text
- /bin/cat : ELF 64-bit...
- /usr/bin/passwd:   steuid ELF 64-bit
- Đều là file `binary executable `


- Điểm cần nắm: 
  - `ELF` = định dạng executable phổ biến trên linux
  - `ASCII text` = file văn bản thuần
  - `setuid` = file executable có special permission steuid
  - `file <path>`
    - dùng để xác định loại nội dung của một file/object
    - Nó không dựa đơn thuần vào đuôi file như `.txt` `.exe` `.jpg`
      - Nó phân tích đặc điểm nội dung của file để đoán loại
    - `ls -l` -> cho biết metadata của file permission, owner, group size ,...
    - `file` cho biết nội dung / định dạng của file là loại gì


## 4. Create a directory ~/touched and enter it.

```sh
duong@homelab:/$ mkdir ~/touched && cd ~/touched

duong@homelab:~/touched$ pwd

/home/duong/touched

[duong@centos7-lab /]$ mkdir ~/touched && cd ~/touched

[duong@centos7-lab touched]$ pwd

/home/duong/touched
```

- Điểm cần nắm: 
  - `&&` chỉ chạy lệnh phia sau nếu lệnh phía trước thành công
  - `;` lệnh phía sau vẫn chạy dù lệnh trước lỗi

## câu 5: câu 5: tạo today.txt và yesterday.txt bằng một command

```sh
duong@homelab:~/touched$ touch today.txt yesterday.txt

duong@homelab:~/touched$ ls

today.txt  yesterday.txt

[duong@centos7-lab touched]$ touch today.txt yesterday.txt

[duong@centos7-lab touched]$ ls

today.txt  yesterday.txt
```

- `touch`
  - tạo ra các file rỗng
  - Có thể tạo nhiều file rỗng
  - Nếu file chưa tồn tại -> tạo file rỗng
  - nếu file đã tồn tại -> cập nhật timestamp của file


## Câu 6: Change the date on yesterday.txt to match yesterday's date.

```sh
man touch
       -d, --date=STRING
              parse STRING and use it instead of current time
       -t STAMP
              use [[CC]YY]MMDDhhmm[.ss] instead of current time


duong@homelab:~/touched$ touch -d 'Sep 16 11:07:43 AM UTC 2026' yesterday.txt
duong@homelab:~/touched$ ls -l
total 0
-rw-rw-r-- 1 duong duong 0 Sep 17 10:57 today.txt
-rw-rw-r-- 1 duong duong 0 Sep 16 11:07 yesterday.txt

[duong@centos7-lab touched]$ ls -l
total 0
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 today.txt
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 yesterday.txt
[duong@centos7-lab touched]$ touch -t 202609161757 yesterday.txt 
[duong@centos7-lab touched]$ ls -l
total 0
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 today.txt
-rw-rw-r--. 1 duong duong 0 Sep 16 17:57 yesterday.txt

```


- Điểm cần nắm của câu này: 
  - `touch -d <date> file`
    - dùng để đặt timestamp theo một thời điểm chỉ định

- Đáp án trong đề

```sh
touch -t 200810251405 yesterday.txt
```

- Có ít nhất 2 cách biểu diễn thời gian: 
  - `-d` : dễ đọc hơn, nhận chuỗi ngày giờ
  - `-t` : dạng số cố didhj theo format thời gian
  
## Câu 7: Copy yesterday.txt to copy.yesterday.txt

```sh
[duong@centos7-lab touched]$ ls
today.txt  yesterday.txt
[duong@centos7-lab touched]$ cp yesterday.txt copy.yesterday.txt
[duong@centos7-lab touched]$ ls -l
total 0
-rw-rw-r--. 1 duong duong 0 Sep 17 18:12 copy.yesterday.txt
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 today.txt
-rw-rw-r--. 1 duong duong 0 Sep 16 17:57 yesterday.txt

duong@homelab:~/touched$ ls -l
total 0
-rw-rw-r-- 1 duong duong 0 Sep 17 10:57 today.txt
-rw-rw-r-- 1 duong duong 0 Sep 16 11:07 yesterday.txt
duong@homelab:~/touched$ cp yesterday.txt copy.yesterday.txt
duong@homelab:~/touched$ ls -l
total 0
-rw-rw-r-- 1 duong duong 0 Sep 17 11:12 copy.yesterday.txt
-rw-rw-r-- 1 duong duong 0 Sep 17 10:57 today.txt
-rw-rw-r-- 1 duong duong 0 Sep 16 11:07 yesterday.txt
```


- Điểm cần nắm: 
  - `cp <source> <destination>`: Copy file 
  - source : vẫn còn nguyên
  - destination là một file mới
  - timestmap của `copy.yesterday.txt` là thời điểm vừa copy. không giữ nguyên timestamp cũ. Đó là hành vi mặc định của `cp`


## Câu 9: Rename copy.yesterday.txt to kim

```sh
[duong@centos7-lab touched]$ ls -l
total 0
-rw-rw-r--. 1 duong duong 0 Sep 17 18:12 copy.yesterday.txt
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 today.txt
-rw-rw-r--. 1 duong duong 0 Sep 16 17:57 yesterday.txt
[duong@centos7-lab touched]$ mv copy.yesterday.txt  kim
[duong@centos7-lab touched]$ ls -l
total 0
-rw-rw-r--. 1 duong duong 0 Sep 17 18:12 kim
-rw-rw-r--. 1 duong duong 0 Sep 17 17:57 today.txt
-rw-rw-r--. 1 duong duong 0 Sep 16 17:57 yesterday.txt

duong@homelab:~/touched$ ls -l
total 0
-rw-rw-r-- 1 duong duong 0 Sep 17 11:12 copy.yesterday.txt
-rw-rw-r-- 1 duong duong 0 Sep 17 10:57 today.txt
-rw-rw-r-- 1 duong duong 0 Sep 16 11:07 yesterday.txt
duong@homelab:~/touched$ mv copy.yesterday.txt kim
duong@homelab:~/touched$ ls -l
total 0
-rw-rw-r-- 1 duong duong 0 Sep 17 11:12 kim
-rw-rw-r-- 1 duong duong 0 Sep 17 10:57 today.txt
-rw-rw-r-- 1 duong duong 0 Sep 16 11:07 yesterday.txt

```


- Điểm cần nắm: 
  - `mv <source> <desitnation> ` có thể dùng để `move` file
  - Nếu source và destination vẫn ở cùng directory , nó hoạt động như `rename`
  - timestamp vẫn giữ nguyên vì bản chất là đổi tên không phải bản copy

## Câu 9: Create a directory called ~/testbackup and copy all files from ~/touched into it.

```sh
duong@homelab:~/touched$ mkdir ~/testbackup
duong@homelab:~/touched$ cp -R ~/touched/* ~/testbackup/
duong@homelab:~/touched$ ls ~/testbackup/
kim  today.txt  yesterday.txt

```

- `-R / -r` chỉ cần khi copy directory và nội dung bên trong nó theo kiểu recursive
  - `cp ~/touched/* ~/testbackup/`
    - sẽ gặp vấn đề với `subdir`
    - `*` bình thường `ko match hidden files`


## Câu 10/12 Use one command to remove the directory ~/testbackup and all files into it.

```sh
duong@homelab:~/touched$ ls ~
dir1  local-transcriber  testbackup  touched  VTI-ex
duong@homelab:~/touched$ rm -r ~/testbackup
duong@homelab:~/touched$ ls ~
dir1  local-transcriber  touched  VTI-ex

```

- Điểm cần lắm
    - `rm` xóa file
    - `-r / --recursive` = đi vào directory và xóa toàn bộ nội dung bên trong theo kiểu đệ quy
    - Vì vậy `rm -r directory` có thể xóa directory không rỗng
    - `rmdir directory` chỉ xóa được ddirrectory rỗng
    - `-f` : force : bỏ qua nhiều cảnh báo/lỗi không cần thiết - lời giải có

## Câu 11/12 Create a directory ~/etcbackup and copy all *.conf files from /etc into it. Did you include all subdirectories of /etc?

```sh
sh
duong@homelab:~/touched$ mkdir ~/etcbackup
duong@homelab:~/touched$ cp /etc/*.conf ~/etcbackup/
duong@homelab:~/touched$ ls ~/etcbackup/
adduser.conf          dhcpcd.conf   hdparm.conf    locale.conf     nftables.conf     resolv.conf    sudo.conf          usb_modeswitch.conf
ca-certificates.conf  e2scrub.conf  host.conf      logrotate.conf  nsswitch.conf     rsyslog.conf   sudo_logsrvd.conf  vconsole.conf
debconf.conf          fuse.conf     ld.so.conf     mke2fs.conf     overlayroot.conf  sensors3.conf  sysctl.conf        xattr.conf
deluser.conf          gai.conf      libaudit.conf  multipath.conf  pam.conf          smartd.conf    ucf.conf

```

- Điểm cần nắm:
    - `*` wildcard chỉ áp dụng tại một cấp directory hiện tại
    - `*.conf` match tên kết thức bằng .conf ở đúng directory đang chỉ 

## Câu 12 Use rename to rename all *.conf files to *.backup.

```sh
duong@homelab:~/etcbackup$ pwd
/home/duong/etcbackup
duong@homelab:~/etcbackup$ ls | head
adduser.conf
ca-certificates.conf
debconf.conf
deluser.conf
dhcpcd.conf
e2scrub.conf
fuse.conf
gai.conf
hdparm.conf
host.conf

```

```sh
duong@homelab:~/etcbackup$ pwd
/home/duong/etcbackup
duong@homelab:~/etcbackup$ ls -l
total 160
-rw-r--r-- 1 duong duong  3444 Sep 17 11:31 adduser.conf
-rw-r--r-- 1 duong duong  6862 Sep 17 11:31 ca-certificates.conf
-rw-r--r-- 1 duong duong  2967 Sep 17 11:31 debconf.conf
-rw-r--r-- 1 duong duong  1706 Sep 17 11:31 deluser.conf
-rw-r--r-- 1 duong duong  1429 Sep 17 11:31 dhcpcd.conf
-rw-r--r-- 1 duong duong   685 Sep 17 11:31 e2scrub.conf
-rw-r--r-- 1 duong duong   694 Sep 17 11:31 fuse.conf
-rw-r--r-- 1 duong duong  2584 Sep 17 11:31 gai.conf
-rw-r--r-- 1 duong duong  4436 Sep 17 11:31 hdparm.conf
-rw-r--r-- 1 duong duong    92 Sep 17 11:31 host.conf
-rw-r--r-- 1 duong duong    34 Sep 17 11:31 ld.so.conf
-rw-r--r-- 1 duong duong   191 Sep 17 11:31 libaudit.conf
-rw-r--r-- 1 duong duong    17 Sep 17 11:31 locale.conf
-rw-r--r-- 1 duong duong   586 Sep 17 11:31 logrotate.conf
-rw-r--r-- 1 duong duong   744 Sep 17 11:31 mke2fs.conf
-rw-r--r-- 1 duong duong    41 Sep 17 11:31 multipath.conf
-rwxr-xr-x 1 duong duong   243 Sep 17 11:31 nftables.conf
-rw-r--r-- 1 duong duong   558 Sep 17 11:31 nsswitch.conf
-rw-r--r-- 1 duong duong  6920 Sep 17 11:31 overlayroot.conf
-rw-r--r-- 1 duong duong   552 Sep 17 11:31 pam.conf
-rw-r--r-- 1 duong duong   920 Sep 17 11:31 resolv.conf
-rw-r--r-- 1 duong duong  1213 Sep 17 11:31 rsyslog.conf
-rw-r--r-- 1 duong duong 10593 Sep 17 11:31 sensors3.conf
-rw-r--r-- 1 duong duong  6136 Sep 17 11:31 smartd.conf
-rw-r--r-- 1 duong duong  4343 Sep 17 11:31 sudo.conf
-rw-r--r-- 1 duong duong  9804 Sep 17 11:31 sudo_logsrvd.conf
-rw-r--r-- 1 duong duong  2209 Sep 17 11:31 sysctl.conf
-rw-r--r-- 1 duong duong  1260 Sep 17 11:31 ucf.conf
-rw-r--r-- 1 duong duong  1523 Sep 17 11:31 usb_modeswitch.conf
-rw-r--r-- 1 duong duong   150 Sep 17 11:31 vconsole.conf
-rw-r--r-- 1 duong duong   681 Sep 17 11:31 xattr.conf
duong@homelab:~/etcbackup$ rename 's/conf/backup/' *.conf
duong@homelab:~/etcbackup$ ls -l
total 160
-rw-r--r-- 1 duong duong  3444 Sep 17 11:31 adduser.backup
-rw-r--r-- 1 duong duong  6862 Sep 17 11:31 ca-certificates.backup
-rw-r--r-- 1 duong duong  2967 Sep 17 11:31 debbackup.conf
-rw-r--r-- 1 duong duong  1706 Sep 17 11:31 deluser.backup
-rw-r--r-- 1 duong duong  1429 Sep 17 11:31 dhcpcd.backup
-rw-r--r-- 1 duong duong   685 Sep 17 11:31 e2scrub.backup
-rw-r--r-- 1 duong duong   694 Sep 17 11:31 fuse.backup
-rw-r--r-- 1 duong duong  2584 Sep 17 11:31 gai.backup
-rw-r--r-- 1 duong duong  4436 Sep 17 11:31 hdparm.backup
-rw-r--r-- 1 duong duong    92 Sep 17 11:31 host.backup
-rw-r--r-- 1 duong duong    34 Sep 17 11:31 ld.so.backup
-rw-r--r-- 1 duong duong   191 Sep 17 11:31 libaudit.backup
-rw-r--r-- 1 duong duong    17 Sep 17 11:31 locale.backup
-rw-r--r-- 1 duong duong   586 Sep 17 11:31 logrotate.backup
-rw-r--r-- 1 duong duong   744 Sep 17 11:31 mke2fs.backup
-rw-r--r-- 1 duong duong    41 Sep 17 11:31 multipath.backup
-rwxr-xr-x 1 duong duong   243 Sep 17 11:31 nftables.backup
-rw-r--r-- 1 duong duong   558 Sep 17 11:31 nsswitch.backup
-rw-r--r-- 1 duong duong  6920 Sep 17 11:31 overlayroot.backup
-rw-r--r-- 1 duong duong   552 Sep 17 11:31 pam.backup
-rw-r--r-- 1 duong duong   920 Sep 17 11:31 resolv.backup
-rw-r--r-- 1 duong duong  1213 Sep 17 11:31 rsyslog.backup
-rw-r--r-- 1 duong duong 10593 Sep 17 11:31 sensors3.backup
-rw-r--r-- 1 duong duong  6136 Sep 17 11:31 smartd.backup
-rw-r--r-- 1 duong duong  4343 Sep 17 11:31 sudo.backup
-rw-r--r-- 1 duong duong  9804 Sep 17 11:31 sudo_logsrvd.backup
-rw-r--r-- 1 duong duong  2209 Sep 17 11:31 sysctl.backup
-rw-r--r-- 1 duong duong  1260 Sep 17 11:31 ucf.backup
-rw-r--r-- 1 duong duong  1523 Sep 17 11:31 usb_modeswitch.backup
-rw-r--r-- 1 duong duong   150 Sep 17 11:31 vconsole.backup
-rw-r--r-- 1 duong duong   681 Sep 17 11:31 xattr.backup

```

- Kết quả có phàn dáng chú ý: 
- `debconf.conf` -> `debbackup.conf`
- s/conf/backup/ = thay lần đầu tiên xuất hiện của chuỗi `conf` không phải thay extendsion `.conf`
- command chặt chẽ hơn phải là:

```sh
rename 's/\.conf$/.backup/' *.conf
```

- rename : command
- `s/conf/backup/` rule thay thế
- `*.conf` các file áp dụng


- `s/conf/backup/`
  - `s` = subtitute = thay thế
  - `conf` = chuỗi cần tìm
  - `backup` chuỗi thay thế
  - Đọc thành: Thay `conf` bằng `backup`

- Điểm cần nắm: 
  - `rename` khác với `mv`
    - `mv` thường rename file cụ thể
    - `rename` có thể áp dụng một rule/pattern cho nhiều file cùng lúc
  - 