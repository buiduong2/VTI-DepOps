# Block 3: Permissions

## Câu 1. Display the user owner and group owner of the /var/log/auth.log file.

```sh
duong@homelab:~/etcbackup$ ls -l /var/log/auth.log
-rw-r----- 1 syslog adm 51513 Sep 17 11:45 /var/log/auth.log

```

## 2. Change the group owner of the wolf.png file to the group tennis.

- Chuẩn bị môi trường

```sh
duong@homelab:~/VTI-ex/day02$ touch wolf.png
sudo groupadd tennis
duong@homelab:~/VTI-ex/day02$ ls -l wolf.png
getent group tennis
-rw-rw-r-- 1 duong duong 0 Sep 19 08:24 wolf.png
tennis:x:1001:

```

- Tra lệnh
```sh
info
chgrp 13.2 ‘chgrp’: Change group ownership

```

```sh
duong@homelab:~/VTI-ex/day02$ sudo chgrp tennis wolf.png 
duong@homelab:~/VTI-ex/day02$ ls -lh
total 0
-rw-rw-r-- 1 duong tennis 0 Sep 19 08:24 wolf.png
                  ^^^^^^
```

-  Kết quả: 
   -  grpup owner đã đổi từ `duong` sang `tenis` còn user onwer vẫn là `duong`

- Giá trị cốt lõi: 
  - `chgrp <group> <file>`
    - Dùng để đổi `groupw owner` của file hoặc directory
  - Group và owner độc lập lẫn nhau
  - Đổi group owner không tự đổi user owner
  - Dùng `sudo` là hợp lý vì thay group owner có thể cần quyền cao hơn tùy group đích và quyền hiện tại


## Câu 3. Change the user owner of the wolf.png file to the user root.

```sh
# Ban đầu
duong@homelab:~/VTI-ex/day02$ ls -l wolf.png 
-rw-rw-r-- 1 duong tennis 0 Sep 19 08:24 wolf.png

# Thucwj hienej
duong@homelab:~/VTI-ex/day02$ sudo chown root wolf.png 

# Kết quả
duong@homelab:~/VTI-ex/day02$ ls -l wolf.png 
-rw-rw-r-- 1 root tennis 0 Sep 19 08:24 wolf.png
              ^^^^ ^^^^^^
              user group

```

- Giá trị cốt lõi: 
  - `chown <user> <file>` : dùng để đổi `user owner` của file
    - chown cũng có thể đổi cả user và group cùng lúc theo dạng `user:group`

## 4. Change the permissions on the Linux.pdf file to r--r-----.


```sh
# Tạo file mẫu
duong@homelab:~/VTI-ex/day02$ touch Linux.pdf
duong@homelab:~/VTI-ex/day02$ ls -l Linux.pdf 
-rw-rw-r-- 1 duong duong 0 Sep 19 08:39 Linux.pdf

# Thực hiện C1 
duong@homelab:~/VTI-ex/day02$ man chmod
duong@homelab:~/VTI-ex/day02$ sudo chmod 440 Linux.pdf 
duong@homelab:~/VTI-ex/day02$ ls -l Linux.pdf 
-r--r----- 1 duong duong 0 Sep 19 08:39 Linux.pdf

# Thực hiện C2: 
duong@homelab:~/VTI-ex/day02$ touch Linux.pdf
duong@homelab:~/VTI-ex/day02$ ls -l Linux.pdf
-rw-rw-r-- 1 duong duong 0 Sep 19 08:46 Linux.pdf
duong@homelab:~/VTI-ex/day02$ chmod ug=r,o= Linux.pdf 
duong@homelab:~/VTI-ex/day02$ ls -l Linux.pdf 
-r--r----- 1 duong duong 0 Sep 19 08:46 Linux.pdf

``` 


- Thực hiện symbolic permission
  - `u`= user/owner
  - `g` = group
  - `o` = other
  - `r` = read
  - `w` = write
  - `x` = execute

- `=` gán lại quyền
- `-` Bỏ quyền
- `+` thêm quyền

```sh
chmod u+r file
chmod g-w file
```

- Cú pháp 
  - `chmod [OPTION]... MODE[,MODE]... FILE...`
    - 


## 5. Change the permissions on the Linux.pdf file to r--r----- using octal notation.

- `r` = 4
- `w`  = 2
- `x` = 1

## 6. Create a directory ~/newdir with 700 permissions

```sh
duong@homelab:~/VTI-ex/day02$ mkdir -m 700  ~/newdir 
duong@homelab:~/VTI-ex/day02$ ls -ld  ~/newdir
drwx------ 2 duong duong 4096 Sep 19 08:50 /home/duong/newdir
```

- Điểm cần nắm: 
  - `mkdir -m 700 <directory>`
    - Tạo directory và `đặt permission ngay khi tạo`

## 7. Display the umask

```sh
duong@homelab:~/VTI-ex/day02$ umask 
0002
```

- `Umask là gì ?`
  - `umask` : là một `mặt nạ quyền mặc định` dùng khi tạo file hoặc directory mới
  - Nó không phải permission hiện tại, mà là thứ bớt đi một số quyền mặc định

- **`MỐc mặc định của Linux`**

```
file mới Bắt đầu từ 6666
Directory mới  bắt đầu từ 777
```

- Máy ta có: 
```sh
umask = 0002
```

- `Nên với file mới: `

```
666
-002
---
664
```

- Vậy permission của file mới là  `rw-rw-r--`


- `Còn với directory mới`

```sh
777
-002
775
```

- Tức là `rwxrwxr-x`

- `Vì sao file bắt đầu từ 666 không phải 777`
- Vì file thường `không được cấp execute mặc định`
- Nếu file mới mặc định có `x` thì mọi file text vừa tạo cso thể thành executable khá không hopwj lys
- Directory thì cần `x` để có thể traverse / đi vào, nên mố thường là `777`

- **`0002 nghĩa là gì`**
- `002`
- Tương ứng: 
```
user    group   others
0       0       2   
```

- `2 ` là quyền write
- Nên hiểu đơn giản: 
  - umask `002` chặn quyền write của `others`
- mask bit permission, không phải phép trừ số học thông thường.


## 8. Does the ~/.profile script change the umask?

- Cần tự kiểm tra xem có dòng nào liên quan đến `umask` không

```sh
duong@homelab:~/VTI-ex/day02$ cat ~/.profile 
# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

```

- default umask is set in /etc/profile
  - Không `~/.profile` hiện không thay đổi umask vì dòng `umask 002` đang bị comment

- `umask` là trạng thái của shell process hiện tại

- Ta có thể thay đổi trạng thái
```sh
umask 077
```

- Thì nó áp dụng cho shell hiện tại và các process con của shell đó. Khi logout rồi login lại một shell mới được tạo và umask sẽ được thiết lập lại theo các file cấu hình / login mechanism của hệ thoonsgs


- `Giá trị cốt lõi`
  - `umask` có thể được thiết lập trong startup file
  - `~/.profile` là một trong các file được đọc khi login shell
  - Nhưng comment thì không có tác dụng
  - umask không phải giá trị vĩnh viễn tự lưu sau khi ta gõ lệnh trong một shell

