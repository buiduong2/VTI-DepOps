## 1. Display the first 12 lines of /etc/services

```sh
duong@homelab:~/VTI-ex/day02$ head -12 /etc/services
# Network services, Internet style
#
# Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
#
# New ports will be added on request if they have been officially assigned
# by IANA and used in the real-world or are needed by a debian package.
# If you need a huge list of used numbers please install the nmap package.

tcpmux		1/tcp				# TCP port service multiplexer
echo		7/tcp
echo		7/udp
discard		9/tcp		sink null

```

- Giá trị cốt lõi: 
  - `head <file>` mặc định in ra 10 dòng đầu nội dung của file, thay vì mở toàn bộ file
  - `head -12 <file>` in ra 12 dòng đầu
  - cũng có thể gặp định nghĩa rõ ràng hơn `head -n 12 /etc/services`


## 2 Display the last line of /etc/passwd

```sh
duong@homelab:~/VTI-ex/day02$ tail -n 1 /etc/passwd
avahi:x:110:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin
```

- Giá trị cốt lõi: 
  - `tail <file>` mặc định in 10 dòng cuối của file
  - `tail -n 1 <file>`  = in 1 dòng cuối của file
  - `head` = lấy phần đầu file , `tail` = lấy phần cuối file


## 3 Use cat to create a file named count.txt that looks like this:

```sh
duong@homelab:~/VTI-ex/day02$ cat > count.txt
One
Two
Three
Four
Five
duong@homelab:~/VTI-ex/day02$ cat count.txt 
One
Two
Three
Four
Five

```

- `Điểm cần nắm`
  - Khi k truyền file name
    - `cat` đọc từ `stdin`

## 4. Use cp to make a backup of this file to cnt.txt

```sh
duong@homelab:~/VTI-ex/day02$ cp count.txt  cnt.txt
duong@homelab:~/VTI-ex/day02$ cat cnt.txt
One
Two
Three
Four
Five


```

- Giá trị cốt lõi: 
  - `cp SOURCE DESTINATION`
    - `cp ` tạo một bản sao độc lập
    - Nếu file đích đã tồn tại mặc định thì `cp` sẽ ghi đè nội dung của nó

## 5. Use cat to make a backup of this file to catcnt.txt.

```sh
duong@homelab:~/VTI-ex/day02$ cat cnt.txt > catcnt.txt
duong@homelab:~/VTI-ex/day02$ cat catcnt.txt 
One
Two
Three
Four
Five

```

- Giá trị cốt lõi
  - `cat SOURCE > Destination`
    - Hoạt động như một cách `copy nội dung text`  từ file nguồn sang file đích

## 6. Display catcnt.txt, but with all lines in reverse order (the last line first).

```sh
man sort
       -r, --reverse
             reverse the result of comparisons

man tac
       tac - concatenate and print files in reverse

duong@homelab:~/VTI-ex/day02$ tac  catcnt.txt 
Five
Four
Three
Two
One

```

- Gía trị cốt lõi: 
  - `cat` -> đọc theo thứ tự bình thường
  - `tac` -> đọc theo thứ tự dòng ngược lại
  - Hữu ích thực thế: 
    - muốn xem log hoặc danh sách theo thứ tự "Mới nhất trước" nếu file được append từ trên xuống dưới
    - Xử lý pipeline mà cần đảo thứ tự record
    - Thao tác nhanh trong shell mà ko cần viết script riêng

## 7. Use more to display /etc/services.

```sh
duong@homelab:~/VTI-ex/day02$ man more
NAME
       more - display the contents of a file in a terminal

duong@homelab:~/VTI-ex/day02$ more /etc/services 
# Network services, Internet style
#
# Updated from https://www.iana.org/assignments/service-names-port-numbers/service-names-port-numbers.xhtml .
#
# New ports will be added on request if they have been officially assigned
# by IANA and used in the real-world or are needed by a debian package.
# If you need a huge list of used numbers please install the nmap package.

tcpmux		1/tcp				# TCP port service multiplexer
echo		7/tcp
echo		7/udp
discard		9/tcp		sink null
discard		9/udp		sink null
systat		11/tcp		users
daytime		13/tcp
daytime		13/udp
netstat		15/tcp
qotd		17/tcp		quote
chargen		19/tcp		ttytst source
chargen		19/udp		ttytst source
ftp-data	20/tcp
ftp		21/tcp
fsp		21/udp		fspd
ssh		22/tcp				# SSH Remote Login Protocol
telnet		23/tcp
smtp		25/tcp		mail
time		37/tcp		timserver
time		37/udp		timserver
whois		43/tcp		nicname
tacacs		49/tcp				# Login Host Protocol (TACACS)
tacacs		49/udp
domain		53/tcp				# Domain Name Server
domain		53/udp
bootps		67/udp
bootpc		68/udp
tftp		69/udp
gopher		70/tcp				# Internet Gopher
finger		79/tcp
http		80/tcp		www		# WorldWideWeb HTTP
kerberos	88/tcp		kerberos5 krb5 kerberos-sec	# Kerberos v5
kerberos	88/udp		kerberos5 krb5 kerberos-sec	# Kerberos v5
iso-tsap	102/tcp		tsap		# part of ISODE
acr-nema	104/tcp		dicom		# Digital Imag. & Comm. 300
pop3		110/tcp		pop-3		# POP version 3

```

- Điểm cần nắm: 
  - Giống command của `less`
  - Đều là `pager` dùng để xem nội dung dài từng màn hình một. 
  - `more` thường để lại phần nội dung đã xem trên terminal / scrollback
  - `less` thường dùng màn hình riêng của terminal, nên khi thoát bằng `q` nội dung xem có thể biến mất và terminal trở về như trước

- Cốt lõi: 
  - `more file `  xem file dài theo từng trang
  - `Space` -> sang trang tiếp
  - `Enter` xuống từng dòng
  - `q` -> thoát

## 8. Display the readable character strings from the /usr/bin/passwd command.

```sh
sudo apt install binutils

man strings
NAME
       strings - print the sequences of printable characters in files

duong@homelab:~/VTI-ex/day02$ cat /usr/bin/passwd |head -n 1
@@@@��0�0@@@�j�j���� � ���(�������08880hhhDDS�td8880P�tdL�L�L���Q�tdR�td�����/lib64/ld-linux-x86-64.so.2 GNU���GNU#DH
                                                                                                                     G�gV	!؆ }l����GNU����e�m�����F����� �H�K,�b��3��{\�B�2W�h
       �UJ�m��A�	$!��	�U���c��h u������j["�p���.z:��9)xT������c�)�{/����gO�o�, �
                                                                                          B������tX"_ITM_deregisterTMCloneTable__gmon_start___ITM_registerTMCloneTable__libc_start_main__cxa_finalize__cxa_atexitstderrdcgettext__fprintf_chkfputsfputcstdoutgetspnamgmtimestrftime__printf_chk__stack_chk_failfreestrcmp__errno_locationmallocsetlocalestrdup__syslog_chk__vasprintf_chkaudit_log_user_avc_messageaudit_opencallocstrlen__explicit_bzero_chkreallocgetpwnam_rsgetspentgetpid__snprintf_chkwriteunlinkfdatasyncread__isoc23_strtollkillstrncmpgeteuidsleepulckpwdfmemcpyfopenfgets__ctype_b_locstrspnstrcspnferrorfclosestrpbrkputpwentputspentfdopenfilenofcntlfeofstrrchrumaskfchownfchmodfstatfseekgetcfflushfsyncutimelstatrenamegetgrnamrealpath__assert_failperrorforkwaitpidexecve__memcpy_chk__environstrchrbindtextdomaingetgidsetregidgetuidsetreuidchdirchrootopenloggetopt_longoptarg__isoc23_strtolgetlogingetpwuid_roptindsetpwentgetpwentendpwentsetrlimitsignalsetuidstrcasecmpcloselogpam_startpam_strerrorpam_chauthtokpam_endmisc_convselabel_closeselabel_openis_selinux_enabledsecurity_getenforceselabel_lookup_rawfreeconselinux_set_callbacksetfscreatecon_rawselinux_check_accessgetprevcon_rawlibpam.so.0libpam_misc.so.0libaudit.so.1libselinux.so.1libc.so.6LIBPAM_MISC_1.0LIBSELINUX_1.0LIBPAM_1.0GLIBC_2.25GLIBC_2.8GLIBC_2.14GLIBC_2.3GLIBC_2.33GLIBC_2.38GLIBC_2.4GLIBC_2.34GLIBC_2.3.4GLIBC_2.2.5

duong@homelab:~/VTI-ex/day02$ strings /usr/bin/passwd | head
/lib64/ld-linux-x86-64.so.2
gV	!
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
__libc_start_main
__cxa_finalize
__cxa_atexit
stderr
dcgettext

```

- `Kiến thức`
  - `cat /usr/bin/passwd`
    - `cat` đọc raw bytes của binary nên terminal hinej ra rất nhiều ký tự rác ...
    - `strings` lọc ra những chuỗi kí tự có thể đọc được
  - `strings`
    - Trích các chuỗi text đọc được
    - hữu ích khi muốn nhìn nhanh bên trong một exectuable hoặc binary mà không mở bằng text edior

## 9. Use ls to find the biggest file in /etc

```sh
man ls
       -S     sort by file size, largest first

duong@homelab:~/VTI-ex/day02$ ls -lSh /etc | head -n 5
total 1004K
-rw-r--r-- 1 root root       74K Jul 12  2023 mime.types
-rw-r--r-- 1 root root       37K Sep 19 09:39 ld.so.cache
-rw-r--r-- 1 root root       13K Mar 27  2021 services
-rw-r--r-- 1 root root       13K Feb 22  2024 login.defs

```

- `S` -> sort theo size , lớn trước


## 10. Open two terminal windows (or tabs) and make sure you are in the same directory in both. Type echo this is the first line > tailing.txt in the first terminal, then issue tail -f tailing.txt in the second terminal. Now go back to the first terminal and type echo This is another line >> tailing.txt (note the double >>), verify that the tail -f in the second terminal shows both lines. Stop the tail -f with Ctrl-C.


```sh
# Terninal 1
duong@homelab:~/VTI-ex/day02$ tail -f tailing.txt 
this is the first line
this is another line
^C

# Terminal 2
duong@homelab:~/VTI-ex/day02$ echo "this is the first line" > tailing.txt
duong@homelab:~/VTI-ex/day02$ echo "this is another line" >> tailing.txt
```

- Giá trị cốt lõi
  - `tail -f` = follow file
    - Nó không chỉ in phần cuối file một lần, mà theo dõi file và hiện thêm nội dung mới khi file được append
    - ĐÂy là lệnh rất thực tế khi xem log đang chạy
  - `>>` append thêm vào cuối file
  - `>` ghi đè file

## 11. Use cat to create a file named tailing.txt that contains the contents of tailing.txt followed by the contents of /etc/passwd.

- Giữ nguyên nội dung hiện tại của `tailing.txt` rồi thêm nội dung của `/etc/passwd` vào sau đó

```sh
duong@homelab:~/VTI-ex/day02$ cat /etc/passwd >> tailling.txt 
duong@homelab:~/VTI-ex/day02$ cat tailling.txt 
this is another line
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
dhcpcd:x:100:65534:DHCP Client Daemon,,,:/usr/lib/dhcpcd:/bin/false
messagebus:x:101:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:992:992:systemd Resolver:/:/usr/sbin/nologin
pollinate:x:102:1::/var/cache/pollinate:/bin/false
polkitd:x:991:991:User for polkitd:/:/usr/sbin/nologin
syslog:x:103:104::/nonexistent:/usr/sbin/nologin
uuidd:x:104:105::/run/uuidd:/usr/sbin/nologin
tcpdump:x:105:107::/nonexistent:/usr/sbin/nologin
tss:x:106:108:TPM software stack,,,:/var/lib/tpm:/bin/false
landscape:x:107:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:989:989:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
usbmux:x:108:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
duong:x:1000:1000:Duong:/home/duong:/bin/bash
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
avahi:x:110:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin

```

- Giá trị cốt lõi: 
    - `>>` = append
    - Thêm nội dung vào `cuối file` mà không xóa nội dung đang có

## 12. Use cat to create a file named tailing.txt that contains the contents of tailing.txt preceded by the contents of /etc/passwd.

- Nội dung ban đầu

```sh
[nội dung cũ của tailing.txt]
[nội dung /etc/passwd]
```

- Sang câu 12 nội dung muốn kết quả: 

```sh
[nội dung /etc/passwd]
[nội dung cũ của tailing.txt]
[nội dung /etc/passwd]
```

- Đề yêu cầu `prepend`

```sh
duong@homelab:~/VTI-ex/day02$ mv tailing.txt tmp.txt
duong@homelab:~/VTI-ex/day02$ cat /etc/passwd tmp.txt > tailing.txt

duong@homelab:~/VTI-ex/day02$ cat tailing.txt 
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
dhcpcd:x:100:65534:DHCP Client Daemon,,,:/usr/lib/dhcpcd:/bin/false
messagebus:x:101:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:992:992:systemd Resolver:/:/usr/sbin/nologin
pollinate:x:102:1::/var/cache/pollinate:/bin/false
polkitd:x:991:991:User for polkitd:/:/usr/sbin/nologin
syslog:x:103:104::/nonexistent:/usr/sbin/nologin
uuidd:x:104:105::/run/uuidd:/usr/sbin/nologin
tcpdump:x:105:107::/nonexistent:/usr/sbin/nologin
tss:x:106:108:TPM software stack,,,:/var/lib/tpm:/bin/false
landscape:x:107:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:989:989:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
usbmux:x:108:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
duong:x:1000:1000:Duong:/home/duong:/bin/bash
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
avahi:x:110:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin
this is the first line
this is another line
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin
_apt:x:42:65534::/nonexistent:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:998:998:systemd Network Management:/:/usr/sbin/nologin
systemd-timesync:x:997:997:systemd Time Synchronization:/:/usr/sbin/nologin
dhcpcd:x:100:65534:DHCP Client Daemon,,,:/usr/lib/dhcpcd:/bin/false
messagebus:x:101:102::/nonexistent:/usr/sbin/nologin
systemd-resolve:x:992:992:systemd Resolver:/:/usr/sbin/nologin
pollinate:x:102:1::/var/cache/pollinate:/bin/false
polkitd:x:991:991:User for polkitd:/:/usr/sbin/nologin
syslog:x:103:104::/nonexistent:/usr/sbin/nologin
uuidd:x:104:105::/run/uuidd:/usr/sbin/nologin
tcpdump:x:105:107::/nonexistent:/usr/sbin/nologin
tss:x:106:108:TPM software stack,,,:/var/lib/tpm:/bin/false
landscape:x:107:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:989:989:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
usbmux:x:108:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
duong:x:1000:1000:Duong:/home/duong:/bin/bash
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
avahi:x:110:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin

```

- Giá trị cốt lõi: 
  - xử lý an toàn khi vừa cần đọc nội dung cũ vừa muốn ghi lại cùng tên file

- Nếu sử dụng

```sh
cat /etc/passwd tailing.txt > tailing.txt
```

- Shell sẽ mở `tailing.txt` và trancate nó trước khi `cat` kịp đọc nội dung cũ
  - Vì vậy phải giữ bản cũ ở file tạm trước

```
tailing.txt
   ↓ mv
tmp.txt

/etc/passwd + tmp.txt
        ↓
    tailing.txt
```