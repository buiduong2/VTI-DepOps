# 1. Create a user named serena with a home directory, a comment and the bash shell.

```sh
man useradd

NAME
       useradd - create a new user or update default new user information

       -d, --home-dir HOME_DIR
           The new user will be created using HOME_DIR as the value for the user's login directory. The default is to append the LOGIN name to BASE_DIR and use that as
           the login directory name. If the directory HOME_DIR does not exist, then it will be created unless the -M option is specified.

       -c, --comment COMMENT
           Any text string. It is generally a short description of the account, and is currently used as the field for the user's full name.

       -s, --shell SHELL
           sets the path to the user's login shell. Without this option, the system will use the SHELL variable specified in /etc/default/useradd, or, if that is as
           well not set, the field for the login shell in /etc/passwd remains empty.

      -m, --create-home
           Create the user's home directory if it does not exist. The files and directories contained in the skeleton directory (which can be defined with the -k
           option) will be copied to the home directory.

           By default, if this option is not specified and CREATE_HOME is not enabled, no home directories are created.

           The directory where the user's home directory is created must exist and have proper SELinux context and permissions. Otherwise the user's home directory
           cannot be created or accessed.


```

```sh
duong@homelab:~$ cat /etc/passwd | grep duong
duong:x:1000:1000:Duong:/home/duong:/bin/bash

duong@homelab:~$ sudo useradd -m  -c 'serena is a user for assignment -block 12' -s /bin/bash  serena

duong@homelab:~$ ls /home
duong  testuser
duong@homelab:~$ cat /etc/passwd | grep serena
serena:x:1002:1003:serena is a user for assignment -block 12:/home/serena_test:/bin/bash

```


## 2. Verify in /etc/passwd that this user was created

```sh
duong@homelab:~$ cat /etc/passwd | grep serena
serena:x:1004:1005:serena is a user for assignment -block 12:/home/serena:/bin/bash

```

- Đọc dòng đó theo từng field

```
serena : x : 1004 : 1005 : serena is a user for assignment -block 12 : /home/serena : /bin/bash
   │      │    │      │                         │                         │            │
 username │   UID    GID                     comment                     home         shell
          │
          └ password thực không nằm ở đây
```

- `x` trong field password không phải password thật; password information được tách sang `/etc/shadow`
- Có thể viết gọn hơn `grep senera /etc/password`


## 3. Use su - to verify that this user has the bash shell and a home directory.

```sh
duong@homelab:~$ su - serena
Password: 
su: Authentication failure
```

- `Normal user` dùng subsitute user thì cần password. Còn `super user `thì không

- Điểm cốt lõi: 

```
/etc/passwd nói metadata là gì
↓
su - serena
↓
kiểm chứng môi trường thật của user đó
```

## 4. 4. Change the comment for the serena user to tennis.

- Gợi ý : không phải `useruser` mà command này sẽ thuojc nhóm `modify user`

```sh
man usermod
NAME
       usermod - modify a user account

       -c, --comment COMMENT
           update the comment field of the user in /etc/passwd, which is normally modified using the chfn(1) utility.

```

- Bài làm

```sh
duong@homelab:~$ sudo usermod -c 'EDITED senera comment' serena

duong@homelab:~$ grep serena /etc/passwd
serena:x:1004:1005:EDITED senera comment:/home/serena:/bin/bash
```

- Mental mode; 


```
user add  -> tạo user

usermod -> Sửa metadata của account đã tồn tại

-c -> sửa comment/GECOS field
```

## 5. 5. Verify that there is a serena home directory in /home.


```sh
duong@homelab:~$ sudo su - serena
serena@homelab:~$ pwd
/home/serena
serena@homelab:~$ echo $HOME
/home/serena
serena@homelab:~$ ls -la $HOME
total 24
drwxr-x--- 2 serena serena 4096 Sep 23 14:12 .
drwxr-xr-x 6 root   root   4096 Sep 23 14:06 ..
-rw------- 1 serena serena   22 Sep 23 14:12 .bash_history
-rw-r--r-- 1 serena serena  220 Mar 31  2024 .bash_logout
-rw-r--r-- 1 serena serena 3771 Mar 31  2024 .bashrc
-rw-r--r-- 1 serena serena  807 Mar 31  2024 .profile

```

- Khi tạo user với `-m` hệ thống đã tạo home và copy các skeleton files vào đó: 
  - `.bash_logout`
  - `.bashrc`
  - `.profile`
- home directory có thật , owner /group đều là serena 
  - `drwxr-x--- 2 serena serena 4096 Sep 23 14:12 .`

## 6. 6. Delete the serena user and the user’s home directory.

- Cần command để xóa serena 
- Xóa luôn home /home/serena

```sh
man userdel
NAME
       userdel - delete a user account and related files
OPTIONS
       -r, --remove
           Files in the user's home directory will be removed along with the home directory itself and the user's mail spool. Files located in other file systems will
           have to be searched for and deleted manually.

```

- Đáp án
```sh
duong@homelab:~$ sudo userdel -r serena
userdel: serena mail spool (/var/mail/serena) not found
duong@homelab:~$ echo $?
0

duong@homelab:~$ grep serena /etc/passwd
duong@homelab:~$ ls -ld /home/serena
ls: cannot access '/home/serena': No such file or directory

```

- Thông báo: 
  - ko phiar lỗi nghiêm trọng.
    - nó chỉ thử dọn cả mail spool của user nhưng file đó ko tồn tại

# BLock 12


```
useradd
→ tạo account

/etc/passwd
→ verify metadata

su -
→ verify environment thật

usermod
→ sửa account metadata

/home
→ verify home directory

userdel -r
→ xóa account + home
```