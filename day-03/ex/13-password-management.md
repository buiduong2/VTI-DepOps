## Block 13 — Thực hành các khối lệnh quản lý Password (Password Management)

- Overview
- 1. Tạo user tania
- 2. Kiểm tra /etc/shadow
  - -> xác nhận tania chưa có password usable 
- 3. đặt password cho tania
- 4. Từ normal user
  - Su
  - kiểm tra login password hoạt động
- 5. Lock accuont tania
- 6. Xem lại /etc/shadow
  - Nhận biết account đang bị lock
- 7. Thử su - tnania lần nữa
- 8. Unlock account

```
account tồn tại
      ↓
chưa có password
      ↓
đặt password
      ↓
authentication dùng được
      ↓
lock
      ↓
authentication bằng password bị vô hiệu hóa
      ↓
unlock
```


## 1. Create a user named tania with bash shell and home directory.

```sh
duong@homelab:~$ man useradd
duong@homelab:~$ sudo useradd -m -s /bin/bash tania
[sudo] password for duong: 
duong@homelab:~$ grep tania /etc/passwd
tania:x:1002:1003::/home/tania:/bin/bash

duong@homelab:~$ sudo ls -la /home/tania/
total 20
drwxr-x--- 2 tania tania 4096 Sep 23 15:19 .
drwxr-xr-x 6 root  root  4096 Sep 23 15:19 ..
-rw-r--r-- 1 tania tania  220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 tania tania 3771 Mar 31  2024 .bashrc
-rw-r--r-- 1 tania tania  807 Mar 31  2024 .profile

```

## 2. Verify in /etc/shadow that tania has no password.

```sh
duong@homelab:~$ sudo grep tania /etc/shadow
tania:!:20719:0:99999:7:::

```

- Dữ liệu
  - `tania:!:20719:0:99999:7:::`
  - Cần chú ý `!`
  - Nó cho thấy account `tania` chưa có `password dùng để xác thực` . 
- Phân tách sơ bộ

```
tania : ! : 20719 : 0 : 99999 : 7 : : :
   │     │      │
   │     │      └ thông tin aging của password
   │     └ trạng thái password hiện tại
   └ username
```


## 3. Set the password for tania to hunter2.

```sh
duong@homelab:~$ sudo passwd tania
New password: 
Retype new password: 
passwd: password updated successfully
duong@homelab:~$ sudo grep tania /etc/shadow
tania:$y$j9T$H8gJgs85EZFT.DF/MvEEt.$COZTq7FuQSXnOkDJyHmmwGU9DBOQHjBZ.u9hYqWtMQ5:20719:0:99999:7:::

```

- `/etc/shadow`
  - Đã bị đổi thành: `tania:$y$j9T$H8gJgs85EZFT.DF/MvEEt.$COZTq7FuQSXnOkDJyHmmwGU9DBOQHjBZ.u9hYqWtMQ5:20719:0:99999:7:::`
  - Điểm cần nhìn `$y$j9T$...$...`
  - Field password giờ đã chứa `password hash` ko còn là `!`
  - password plaintext ko được lưu trực tiếp
  - Field thứ 2 khi password state thay đổi

- Mental model: 

```
Chưa có password usable 
-> /etc/shadow field 2 = !

passwd tania 
-> tạo password hash

Sau đó
-> /etc/shadow field 2 = hash
```

## 4. As a normal user, verify that you can use su - tania with the password.


```sh
duong@homelab:~$ su - tania
Password: 
su: Authentication failure
duong@homelab:~$ su - tania
Password: 
tania@homelab:~$ whoami
tania
tania@homelab:~$ pwd
/home/tania
tania@homelab:~$ 


```

- Khác biệt với dùng sodu user
    - `sudo su - tania` -> dựa vào quyền sudo/root của duong
    - `su - tania` -> xác thực bằng password của tania


## 5. As root, lock the tania account. 

```sh
man passwd
       -l, --lock
           Lock the password of the named account. This option disables a password by changing it to a value which matches no possible encrypted value (it adds a ´!´ at
           the beginning of the password).

           Note that this does not disable the account. The user may still be able to login using another authentication token (e.g. an SSH key). To disable the
           account, administrators should use usermod --expiredate 1 (this set the account's expire date to Jan 2, 1970).

           Users with a locked password are not allowed to change their password.

```

```sh
duong@homelab:~$ sudo passwd -l tania
passwd: password changed.
duong@homelab:~$ su - tania
Password: 
su: Authentication failure

```

## 6. Verify in /etc/shadow that the account is locked.

```sh
duong@homelab:~$ sudo grep tania /etc/shadow
tania:!$y$j9T$H8gJgs85EZFT.DF/MvEEt.$COZTq7FuQSXnOkDJyHmmwGU9DBOQHjBZ.u9hYqWtMQ5:20719:0:99999:7:::

```

- Trước khi block
  - `$y$j9T$...`
- Sau khi block
  - `!$y$j9T$...`

- Dấu `!` đã được thêm vào phía trước password hash

- Mental model

```
password hash hợp lệ
→ có thể authenticate

! + password hash
→ password authentication bị khóa
```

## 7. Verify that su - tania as a normal user no longer works.

- Đã thử ở câu trước

## 8. Unlock the tania account.


```sh
man passwd
       -u, --unlock
           Unlock the password of the named account. This option re-enables a password by changing the password back to its previous value (to the value before using
           the -l option).

```


```sh
duong@homelab:~$ sudo passwd -u tania
passwd: password changed.
duong@homelab:~$ sudo grep tania /etc/shadow
tania:$y$j9T$H8gJgs85EZFT.DF/MvEEt.$COZTq7FuQSXnOkDJyHmmwGU9DBOQHjBZ.u9hYqWtMQ5:20719:0:99999:7:::
duong@homelab:~$ su - tania
Password: 
tania@homelab:~$ whoami
tania

```

- mental model

## Chốt Block 13

```
/etc/shadow
→ chứa password/authentication state

passwd user
→ đặt password

passwd -l user
→ lock password authentication

passwd -u user
→ unlock lại password authentication
```