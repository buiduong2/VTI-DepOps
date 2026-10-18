# Block 20 – Cron/Scheduler

## Install the at command and verify the contents of at.deny


```sh
[duong@centos7-lab ~]$ which at
/usr/bin/which: no at in (/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/duong/.local/bin:/home/duong/bin)
[duong@centos7-lab ~]$ at
-bash: at: command not found


[duong@centos7-lab ~]$ sudo yum install at 
[duong@centos7-lab ~]$ cat /etc/at.deny 

[duong@centos7-lab ~]$ 


```

- **`Giá trị cốt lõi`**
- at
- -> schedule một command chạy một lần trong tương lai

- /etc/at.deny
- -> danh sách user bị cấm dùng at


## 2. Deny all users the use of at and cron.    Đã dán markdown (1)(2)


- Kiểm tra các policy ban đầu của `at` và `cron`

```
at
├─ at.allow
└─ at.deny

cron
├─ cron.allow
└─ cron.deny
```

```sh
[duong@centos7-lab ~]$ ls -l /etc/at.allow /etc/at.deny /etc/cron.allow /etc/cron.deny
ls: cannot access /etc/at.allow: No such file or directory
ls: cannot access /etc/cron.allow: No such file or directory
-rw-r--r--. 1 root root 1 May 18  2022 /etc/at.deny
-rw-------. 1 root root 0 Aug  9  2019 /etc/cron.deny

```

- Tieens hành thử tạo `at` và `cron`

```sh 
[duong@centos7-lab ~]$ at now + 1 minute
at> echo before-allow-test >> /tmp/at-test.log
at> <EOT>
job 2 at Thu Oct  1 09:50:00 2026
[duong@centos7-lab ~]$ ls -l /tmp/
total 4
-rw-rw-r--. 1 duong duong 36 Oct  1 09:50 at-test.log
drwx------. 3 root  root  17 Oct  1 09:29 systemd-private-6677f60fbf4645779cf04951842d2c7d-chronyd.service-8a2RId
drwx------. 3 root  root  17 Sep 30 22:03 systemd-private-69e9d7b57f7142b6a668e249f4e361cc-chronyd.service-IfeOLo
drwx------. 3 root  root  17 Sep 30 09:38 systemd-private-7a6ff595e1744301bb436b80c134db33-chronyd.service-QsB55U
# Cho phép User Dương tạo at

[duong@centos7-lab ~]$ crontab -e
crontab: no changes made to crontab
# Cho phép user Duong tạo cron
```

```sh
[duong@centos7-lab ~]$ sudo touch /etc/at.allow
[duong@centos7-lab ~]$ sudo touch /etc/cron.allow
[duong@centos7-lab ~]$ at now + 1 minute
You do not have permission to use at.
[duong@centos7-lab ~]$ crontab -l
You (duong) are not allowed to use this program (crontab)
See crontab(1) for more information
[duong@centos7-lab ~]$ 
```

- **`Nhận xét`**

- Trước khi tạo `allow`

```
at.allow    không tồn tại
cron.allow  không tồn tại
-> hệ thống xét deny
-> duong ko bị deny
-> dùng được
```

- sau khi tạo các file allow

```
at.allow   = empty
cron.allow = empty
```

- Kết quả nhận được

```
You do not have permission to use at.
You (duong) are not allowed to use this program (crontab)
```


- **`Mental model`**

```
*.allow tồn tại
-> chỉ có user có tên trong file mới được phép

*.allow không tồn tại
-> mới xét *.deny
```

- Vì `allow` hiện rỗng

```
Không có user thường nào nằm trong danh sách cho phép
```

## 3. Schedule an at job that writes to a log file, at noon tomorrow. Verify that your job is in the at queue.

- `atq` -> kiểm tra queue của `at`

- B1: cần sửa lại file cho phép user duong có quyền thêm `at`

```sh
echo duong | sudo tee -a /etc/at.allow
```

- B2: Khai báo thời điểm chạy có thể sử dụng nhanh `noon tomorrow`
- noon
→ 12:00 trưa

tomorrow
→ ngày mai



```sh
[duong@centos7-lab ~]$ at noon tomorrow
at> echo hello > /home/duong/noonjob-assignment.txt
at> <EOT>
job 3 at Sat Oct  3 12:00:00 2026

## Kiểm tra trong queue xem job đã được khai báo chưa 
[duong@centos7-lab ~]$ atq
3	Sat Oct  3 12:00:00 2026 a duong
[duong@centos7-lab ~]$ 

```

## 4. Remove your job from the at queue and then remove at from your system.