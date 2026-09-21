## 1. List the contents of the ssh configuration directory.

```sh
duong@homelab:~$ ls -la  /etc/ssh
total 660
drwxr-xr-x   4 root root   4096 Sep  8 16:32 .
drwxr-xr-x 121 root root   4096 Sep 19 09:39 ..
-rw-r--r--   1 root root 620042 Jul  9 18:16 moduli
-rw-r--r--   1 root root   1649 Aug 26  2025 ssh_config
drwxr-xr-x   2 root root   4096 Aug 26  2025 ssh_config.d
-rw-r--r--   1 root root   3517 Jul  9 18:16 sshd_config
drwxr-xr-x   2 root root   4096 Aug 30 04:03 sshd_config.d
-rw-------   1 root root    505 Aug 30 04:03 ssh_host_ecdsa_key
-rw-r--r--   1 root root    174 Aug 30 04:03 ssh_host_ecdsa_key.pub
-rw-------   1 root root    399 Aug 30 04:03 ssh_host_ed25519_key
-rw-r--r--   1 root root     94 Aug 30 04:03 ssh_host_ed25519_key.pub
-rw-------   1 root root   2602 Aug 30 04:03 ssh_host_rsa_key
-rw-r--r--   1 root root    566 Aug 30 04:03 ssh_host_rsa_key.pub
-rw-r--r--   1 root root    342 Dec  7  2020 ssh_import_id

```

- Giá trị cốt lõi: 
  - `ssh_config` và `ssh_config.d/`
    - cấu hình phía `SSH client`
    - Ảnh hưởng khi máy này dùng `ssh` để kết nối sang máy khác
  -  `sshd_config` và `sshd_config.d/`
    -  Cấu hình phía `ssh server`
    -  Ảnh hưởng khi máy khác kết nối vào máy này qua `sshd`
 -  `ssh_host_*_key.pub`
    -  public key tương ứng
 -  `moduli`
    -  Dữ liệu liên quan tới một số phép trao đổi khóa kiểu diffie-hellamn
-  `hậu tố d`
   -  Daemon L background service/process chạy nền trên linux

## 2. List the contents of your home directory

```sh
duong@homelab:~$ ls  -la ~
total 1088
drwxr-x--- 12 duong duong   4096 Sep 21 10:58 .
drwxr-xr-x  3 root  root    4096 Aug 30 03:55 ..
-rw-------  1 duong duong  45165 Sep 21 10:58 .bash_history
-rw-r--r--  1 duong duong    220 Mar 31  2024 .bash_logout
-rw-r--r--  1 duong duong   3771 Mar 31  2024 .bashrc
drwx------  5 duong duong   4096 Sep  8 16:22 .cache
drwx------  4 duong duong   4096 Sep 18 15:19 .config
drwxrwxr-x  3 duong duong   4096 Sep 17 10:22 dir1
drwxrwxr-x  2 duong duong   4096 Sep 17 11:42 etcbackup
-rw-------  1 duong duong    139 Sep 21 10:53 .lesshst
drwx------  3 duong duong   4096 Sep  8 16:16 .local
drwxrwxr-x  7 duong duong   4096 Sep 18 17:21 local-transcriber
drwx------  2 duong duong   4096 Sep 19 08:50 newdir
-rw-r--r--  1 duong duong    807 Mar 31  2024 .profile
drwx------  2 duong duong   4096 Sep  1 13:18 .ssh
-rw-r--r--  1 duong duong      0 Aug 30 04:12 .sudo_as_admin_successful
drwxrwxr-x  2 duong duong   4096 Sep 17 11:14 touched
-rw-------  1 duong duong  11449 Sep 19 11:18 .viminfo
drwxrwxr-x  3 duong duong   4096 Sep 21 09:32 VTI-ex
-rw-r--r--  1 duong duong 985084 Sep 21 10:03 words

```

- Giá trị cốt lõi: 
   - `/home` là cấp thư mục chứa home các user thường
   - `~` là home directory của `user hiện tại`
   - `.ssh` -> dữ liệu cấu hình SSH riêng của user hiện tại

## 3. Try to enter the home directory of the root user.”

```sh
duong@homelab:~$ ls -la /root
ls: cannot open directory '/root': Permission denied
duong@homelab:~$ sudo ls -la /root 
[sudo] password for duong: 
total 24
drwx------  4 root root 4096 Aug 30 04:13 .
drwxr-xr-x 23 root root 4096 Aug 30 07:45 ..
-rw-r--r--  1 root root 3106 Apr 22  2024 .bashrc
drwx------  3 root root 4096 Aug 30 04:13 .local
-rw-r--r--  1 root root  161 Apr 22  2024 .profile
drwx------  2 root root 4096 Aug 30 04:03 .ssh

```

- Giá trị cốt lõi cần nắm: 
  - `/home/<username>` home của user thường
  - `/root`: home của user root
  - `/root/.profile || /root/.ssh` các file cấu hình của root

## 4. List the data directories that are shared on the network by this computer.

```sh
duong@homelab:~$ ls -la /srv/
total 8
drwxr-xr-x  2 root root 4096 Feb 10  2026 .
drwxr-xr-x 23 root root 4096 Aug 30 07:45 ..
```

- Giá trji cốt lỗi cần nắm: 
  - `/srv` thường dùng cho dữ liệu của các service mà máy này cung cấp ra ngoài
  - `/srv/www` 
  - `/srv/ftp`
  - `/srv/nfs`

- `/srv = service data`  = convention / standard location

## 5. Create a temporary test directory.

```sh 
uong@homelab:/$ mkdir /tmp/temp-test-dir
duong@homelab:/$ ls -la /tmp
total 56
drwxrwxrwt 14 root  root  4096 Sep 21 13:52 .
drwxr-xr-x 23 root  root  4096 Aug 30 07:45 ..
drwxrwxrwt  2 root  root  4096 Sep 21 13:37 .font-unix
drwxrwxrwt  2 root  root  4096 Sep 21 13:37 .ICE-unix
drwx------  2 root  root  4096 Sep 21 13:37 snap-private-tmp
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-ModemManager.service-HEOJLc
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-polkit.service-6TGLQf
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-systemd-logind.service-T0tug3
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-systemd-resolved.service-PQsB9r
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-systemd-timesyncd.service-Q795gA
drwx------  3 root  root  4096 Sep 21 13:37 systemd-private-cffae44ace304920a4b8fe91a8b44b7b-upower.service-h5PETW
drwxrwxr-x  2 duong duong 4096 Sep 21 13:52 temp-test-dir
drwxrwxrwt  2 root  root  4096 Sep 21 13:37 .X11-unix
drwxrwxrwt  2 root  root  4096 Sep 21 13:37 .XIM-unix

```

- `drwxrwxrwt`
  - `t` : sticky bit
  - `/tmp` : tmo thường có permission kiểu `1777`
  - Mọi user đều có thể tạo file/thư mục trong `/tmp`
  - Nhưng nhờ `sticky bit` user thường ko thể xóa file của user khác chỉ vì `/tmp` là `world writeable`
  - Vì vậy `/tmp` có thể dùng chung cho toàn hệ thống mà vẫn hạn chế người này phá dữ liệu tạm của người khác

## 6. List the commands to manage the Linux system.

```sh
duong@homelab:/$ ls -la /sbin | head
ls -la /usr/sbin | head
lrwxrwxrwx 1 root root 8 Apr 22  2024 /sbin -> usr/sbin
total 40132
drwxr-xr-x  2 root root     20480 Sep 21 08:01 .
drwxr-xr-x 12 root root      4096 Feb 10  2026 ..
-rwxr-xr-x  1 root root     39680 Aug 15  2025 aa-load
-rwxr-xr-x  1 root root      3225 Aug 15  2025 aa-remove-unknown
-rwxr-xr-x  1 root root     40000 Aug 15  2025 aa-status
-rwxr-xr-x  1 root root       137 Apr 12  2024 aa-teardown
-rwxr-xr-x  1 root root     14904 Feb 10  2026 accessdb
-rwxr-xr-x  1 root root      3075 Sep  2 19:38 addgnupghome
lrwxrwxrwx  1 root root         7 Jul  5  2023 addgroup -> adduser

```

- `/usr/bin` -> command user/general-purpose
- `/sbin`      -> system administration command
- `/usr/sbin`  -> system administration command

- `sbin` chỉ là symlink trỏ sang `/usr/sbin`

```sh
which cat
# /usr/bin/cat
file /usr/bin/cat
/usr/bin/cat: ELF 64-bit LSB pie executable, x86-64, version 1 (SYSV), dynamically linked, interpreter /lib64/ld-linux-x86-64.so.2, BuildID[sha1]=9de7eeef378bdfd62a7e79c05c5381d560b57f15, for GNU/Linux 3.2.0, stripped

```

## 7. List the man-db libraries.

```sh
duong@homelab:/$ ls -la  /lib/man-db/
total 304
drwxr-xr-x  2 root root   4096 Feb 10  2026 .
drwxr-xr-x 83 root root   4096 Sep 19 09:39 ..
-rw-r--r--  1 root root 267008 Feb 10  2026 libman-2.12.0.so
-rw-r--r--  1 root root  30864 Feb 10  2026 libmandb-2.12.0.so
lrwxrwxrwx  1 root root     18 Feb 10  2026 libmandb.so -> libmandb-2.12.0.so
lrwxrwxrwx  1 root root     16 Feb 10  2026 libman.so -> libman-2.12.0.so
lrwxrwxrwx  1 root root     13 Feb 10  2026 man -> ../../bin/man
lrwxrwxrwx  1 root root     15 Feb 10  2026 mandb -> ../../bin/mandb

```


- Giá trị cốt lõi
  - `man-db` là hệ thống quản lý và tra cứu manual pages. 
  - `db` = database theo nghĩa cơ sở dữ liệu chỉ mục / metadata để tìm man page nhanh
  - `.so` là share library , code dùng chung mà chương tình có thể load khi chạy

## 8. List third party package providers.

```sh
duong@homelab:/$ ls -la /opt/
total 8
drwxr-xr-x  2 root root 4096 Feb 10  2026 .
drwxr-xr-x 23 root root 4096 Aug 30 07:45 ..

```

- Giá trị cốt lõi
  - `/opt` ;à convetion  dành cho phần mềm "optional" hoặc phaafn mềm bên thứ 3 được cài tách biệt khỏi cấu trúc package chuẩn của distro
  - `/usr/..` -> phần mềm/ thành phần tích hợp theo hệ thống package của distro
  - `/opt/..` phần mềm bên thứ 3 , vendor package, app cài độc lập

## 9. List the size of the kernel in human readable format

```sh
duong@homelab:/boot$ ls -lha /boot
total 193M
drwxr-xr-x  5 root root 4.0K Sep  8 16:33 .
drwxr-xr-x 23 root root 4.0K Aug 30 07:45 ..
-rw-r--r--  1 root root 281K Jul 31 20:56 config-6.8.0-138-generic
-rw-r--r--  1 root root 281K Aug  1 02:25 config-6.8.0-139-generic
drwxr-xr-x  3 root root 4.0K Jan  1  1970 efi
drwxr-xr-x  5 root root 4.0K Sep  8 16:33 grub
lrwxrwxrwx  1 root root   28 Sep  8 16:33 initrd.img -> initrd.img-6.8.0-139-generic
-rw-r--r--  1 root root  73M Aug 30 03:57 initrd.img-6.8.0-138-generic
-rw-r--r--  1 root root  73M Sep  8 16:33 initrd.img-6.8.0-139-generic
lrwxrwxrwx  1 root root   28 Aug 30 03:54 initrd.img.old -> initrd.img-6.8.0-138-generic
drwx------  2 root root  16K Aug 30 03:52 lost+found
-rw-------  1 root root 8.8M Jul 31 20:56 System.map-6.8.0-138-generic
-rw-------  1 root root 8.8M Aug  1 02:25 System.map-6.8.0-139-generic
lrwxrwxrwx  1 root root   25 Sep  8 16:33 vmlinuz -> vmlinuz-6.8.0-139-generic
-rw-------  1 root root  15M Jul 31 20:56 vmlinuz-6.8.0-138-generic
-rw-------  1 root root  15M Aug  1 02:26 vmlinuz-6.8.0-139-generic
lrwxrwxrwx  1 root root   25 Aug 30 03:54 vmlinuz.old -> vmlinuz-6.8.0-138-generic

```

- `vmlinuz-*` -> kernel image
- `initrd.img-*` -> initial RAM disk, môi trường tạm để kernel boot tiếp
- `config-*`  : Config dùng khi build kernel
- `system.map-*` bảng symbol của kernel
- `grub` -> file của GRUB bootloader
- `efi/` -> file liên quan UEFI/EFI boot