## 1. Display a list of logged on users.

```sh
duong@homelab:~$ who 
duong    pts/0        2026-09-23 13:12 (192.168.0.108)
```

- trong out của ta 

```
duong               pts/0             2026-09-23 13:12     (192.168.0.108)
  │                 │                    │                       │
user          terminal/session       login time             remote host

```

- `pts/0` là pseudo-terminal.  (TH này hợp lý vì ta đang SSH vào homelab)
- Giá trị cốt lõi: 
  - `who` -> xem `logged-in users/sessions` không phải danh sách toàn bộ user account

## 2. Display your username

```sh
duong@homelab:~$ whoami 
duong

```

- Khác biệt so với câu trước: 
    - `who` -> xem login session hiện có
    - `whoami` -> hỏi process/shell hiện tại đang chạy dưới user nào

##  3. Display your uid and the list of groups that you are a member of.

```sh
man groups
NAME
       groups - print the groups a user is in

man id
NAME
       id - print real and effective user and group IDs

duong@homelab:~$ groups duong
duong : duong adm cdrom sudo audio dip plugdev lxd

duong@homelab:~$ id duong
uid=1000(duong) gid=1000(duong) groups=1000(duong),4(adm),24(cdrom),27(sudo),29(audio),30(dip),46(plugdev),101(lxd)

```

-  `uid=1000`  -> UID của user duong
-  `gid = 1000` -> primary group của duong
-  `groups` -> toàn bộ group member ship
-  


- Điểm khác biệt so với câu trước: 
  - `groups` -> xem group membership
  - `id` -> xem identity đầy đủ hơn : UID + GID + groups

## 4. 4. If you have the password of another user, then switch to that user.

- Tạo môi trường làm bài tập

```sh
duong@homelab:~$ sudo useradd -m testuser
sudo passwd testuser
[sudo] password for duong: 
New password: 
Retype new password: 
passwd: password updated successfully

```


- Đáp án

```sh
duong@homelab:~$ su testuser
Password: 
$ whoami
testuser
$ cd ~
$ pwd
/home/testuser

```

- `su testuser` -> CHuyển sang chạy dưới identity của một user khác  `testuser`
- `su` = switch/subtitute user

- Điểm mấu chốt
  - `su testuser` đổi identity nhưng ko nhất thiết dựng lại một login evirontment hoàn chỉnh của `testuser`

```
shell hiện tại
   ↓
su <user>
   ↓
mở một shell dưới identity của user đó
   ↓
các command sua này chạy với quyền của user đó
```

- Mental model: 

```
sudo command
-> mượn quyền cho 1 command

su user
-> đổi identity của cả shell hiện tại sang user khác
-> exit để quay lại
```

## 5. 

- Kiểm chứng evinrontment

```sh
duong@homelab:~$ echo $USER
duong
duong@homelab:~$ echo $HOME
/home/duong
duong@homelab:~$ echo $SHELL
/bin/bash
duong@homelab:~$ pwd
/home/duong
duong@homelab:~$ su testuser
Password: 
$ echo $USER
testuser
$ echo $HOME
/home/testuser
$ echo $SHELL
/bin/sh
$ pwd
/home/duong
```

- Đáp án: 

```sh
duong@homelab:~$ su - testuser
Password: 
$ echo $USER
echo $HOME
echo $SHELL
pwdtestuser
$ /home/testuser
$ /bin/sh
$ 
/home/testuser
$ 
```

- Đã caapjt nhật một số biến evinronment quan trọng theo target user

- su test user
  - -> đổi identityh sang testuser
  - -> HOME, USER, SHELL đã đổi
  - -> Nhưng current working directory vẫn là /home/duong

- Vậy `su - testuser` khác gì ?
  - Dấu `-` yêu cầu tạo một `login shell / login envinronment` gần với việc user đó đăng nhập từ đầu hơn


- Mental model: 

```
su user
→ đổi sang user đó
→ cập nhật một phần environment theo target user
→ nhưng vẫn giữ khá nhiều context của session hiện tại
→ ví dụ current directory có thể vẫn giữ nguyên

su - user
→ đổi sang user đó
→ tạo login environment
→ chuyển vào home của target user
→ khởi tạo shell giống một login session hơn
```


## Tóm lại

```
who
→ xem logged-in sessions

whoami
→ user hiện tại của shell/process

id
→ UID, GID, groups

su user
→ switch sang user khác

su - user
→ switch user + login environment
```