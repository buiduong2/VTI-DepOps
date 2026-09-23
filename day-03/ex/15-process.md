## Block 15 — Thực hành các khối lệnh quản lý tiến trình (Process)

- 1. xem command line của process đầu tiên qua `/proc/1/cmdline`
- 2. xác định type của command/file đó
- 3. Xem PID của bash shell hiện tại
- 4. Xem PID của tất cả các bash shell
- 5. Xem complete Process tree , page by page
- 6. Kiểm tra xem máy có Zombie process không
- 7. Dùng top, mở help và sort theo memory usage

## 1. Issue a cat /proc/1/cmdline to see the command that started the first process on this computer.


```sh
duong@homelab:~$ cat /proc/1/cmdline
/sbin/initduong@homelab:~$ 
```

- `/proc`
  - Là một pseudo filesystem
  - Giữ trạng thái hệ thống / process trong memory 
    - Biểu diễn thông tin đó dưới dạng file và directory quen thuộc


- Ở đây;
    - `cat /proc/1/cmdline`

```
/proc
└── 1
    └── cmdline
```

- `1` là: 
  - PID = 1
  - nên `/proc/1` là directory chứa thong tin về `process có PID 1`
  - Keet squar: `/sbin/init`
  - Nên PID 1 được start với command `/sbin/init`
- `/proc` không chỉ có Process
- Ngoài các directory số PID
- Nó còn expose nhiều thông tin kernel system

- Khác biệt với `/sys`
  - `/proc` -> process + kernel /runtime information
  - `/sys` -> kernel view về devices /hardware và các kernel objects


## 2. What type of file is this command from question 1.?

```sh
duong@homelab:~$ ls -l /sbin/init
lrwxrwxrwx 1 root root 22 Jul 28 15:04 /sbin/init -> ../lib/systemd/systemd
duong@homelab:~$ file /sbin/init
/sbin/init: symbolic link to ../lib/systemd/systemd
```

- Kết luận: 
  - `/sbin/init`
    - -> symbolic link
    - -> trỏ tới `../lib/systemd/systemd`
    - Không phải chương trình độc lập mà là symbolic link tới `systemd` (Thực chất là systemd)


## 3. Display the PID of your bash shell.

- Gợi ý: Shell có một special variable chứa PID của chính nó

```sh
man env
NAME
       env - run a program in a modified environment
       A mere - implies -i.  If no COMMAND, print the resulting environment.

man printenv
NAME
       printenv - print all or part of environment
duong@homelab:~$ compgen -v | grep ID
BASHPID
EUID
PPID
UID
XDG_SESSION_ID

man bash
Shell Variables
       The following variables are set by the shell:

       _      At shell startup, set to the pathname used to invoke the shell or shell script being executed as passed in  the  environment  or  argument  list.   Subse‐
              quently,  expands  to the last argument to the previous simple command executed in the foreground, after expansion.  Also set to the full pathname used to
              invoke each command executed and placed in the environment exported to that command.  When checking mail, this parameter holds the name of the  mail  file
              currently being checked.
       BASH   Expands to the full filename used to invoke this instance of bash.
       BASHOPTS
              A  colon-separated  list  of  enabled  shell options.  Each word in the list is a valid argument for the -s option to the shopt builtin command (see SHELL
              BUILTIN COMMANDS below).  The options appearing in BASHOPTS are those reported as on by shopt.  If this variable is in the environment  when  bash  starts
              up, each shell option in the list will be enabled before reading any startup files.  This variable is read-only.
       BASHPID
              Expands to the process ID of the current bash process.  This differs from $$ under certain circumstances, such as subshells that do not require bash to be
              re-initialized.  Assignments to BASHPID have no effect.  If BASHPID is unset, it loses its special properties, even if it is subsequently reset.

```

```sh

duong@homelab:~$ echo $BASHPID
1263
duong@homelab:~$ echo $PPID
1261
duong@homelab:~$ echo $UID
1000
duong@homelab:~$ id
uid=1000(duong) gid=1000(duong) groups=1000(duong),4(adm),24(cdrom),27(sudo),29(audio),30(dip),46(plugdev),101(lxd)
duong@homelab:~$ echo $EUID
1000
duong@homelab:~$ echo $XDG_SESSION_ID
1

duong@homelab:~$ ps -o pid,ppid,cmd -p 1261,1263
    PID    PPID CMD
   1261    1146 sshd: duong@pts/0
   1263    1261 -bash

```

- `$BASHPID`
  - là PID của bash process hiện tại
- `$$`
  - PID của shell hiện tại theo cách assignment muốn
- `PPID`
  - Parent Process ID
- `UID`
  - Real User ID
- `EUID`
  - Effective user ID

## 4. Display the PID of all bash shells.

- Khác với câu 3: 
  - -> PID cuiar bash shell hiện tại
  - Câu 4 -> PID của tất cả process có tên Ppassh

- Gợi ý: 
  - Đáp án thật dùng một tool nhận `process name` trả về PID

```sh

man ps

       -C cmdlist
              Select  by  command  name.   This  selects the processes whose executable name is given in cmdlist.  NOTE: The command name is not the same as the command
              line. Previous versions of procps and the kernel truncated this command name to 15 characters. This limitation is  no  longer  present  in  both.  If  you
              depended on matching only 15 characters, you may no longer get a match.
       -o format
              User-defined  format.   format  is  a  single  argument in the form of a blank-separated or comma-separated list, which offers a way to specify individual
              output columns.  The recognized keywords are described in the STANDARD FORMAT SPECIFIERS section below.  Headers may be renamed (ps -o  pid,ruser=RealUser
              -o  comm=Command)  as desired.  If all column headers are empty (ps -o pid= -o comm=) then the header line will not be output.  Column width will increase
              as needed for wide headers; this may be used to widen up columns such as WCHAN (ps -o pid,wchan=WIDE-WCHAN-COLUMN -o comm).  Explicit  width  control  (ps
              opid,wchan:42,cmd)  is  offered too.  The behavior of ps -o pid=X,comm=Y varies with personality; output may be one column named "X,comm=Y" or two columns
              named "X" and "Y".  Use multiple -o options when in doubt.  Use the PS_FORMAT environment variable to specify a default as desired; DefSysV and DefBSD are
              macros that may be used to choose the default UNIX or BSD columns.


duong@homelab:~$ ps -C bash -o pid= 
   1263
duong@homelab:~$ ps -C bash
    PID TTY          TIME CMD
   1263 pts/0    00:00:00 bash


man pidof
NAME
       pidof - find the process ID of a running program

duong@homelab:~$ pidof bash
1263

```

- Mental modeL :
  - `ps -C bash`
    - hỏi ps : liệt kê process có command name bash
  - `piof bash`
    - hỏi trực tiếp : PID của process tên bash là gì

## 5. Look at the complete process tree, page by page.

- Gợi ý: 

```sh
ps fax | more

# Hoặc

ps -ef | more
```

- Mục tiêu: 
  - complete process view
  -  VÀ page by page
-  `ps fax`
   -  thiên về hình `dạng cây`
   -  `| more` giúp xem từng trang
-  


```sh 
duong@homelab:~$ ps fax | more
    PID TTY      STAT   TIME COMMAND
      2 ?        S      0:00 [kthreadd]
      3 ?        S      0:00  \_ [pool_workqueue_release]
      4 ?        I<     0:00  \_ [kworker/R-rcu_g]
      5 ?        I<     0:00  \_ [kworker/R-rcu_p]
      6 ?        I<     0:00  \_ [kworker/R-slub_]
      7 ?        I<     0:00  \_ [kworker/R-netns]
      9 ?        I<     0:00  \_ [kworker/0:0H-events_highpri]
--More--
```

- Kí hiệu `|_`
  - Thể hiện mối quan hệ child process trong tree view

```
[kthreadd]
 \_ [pool_workqueue_release]
 \_ [kworker/...]
```

```sh 
 1145 ?        Ss     0:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
   1146 ?        Ss     0:00  \_ sshd: duong [priv]
   1261 ?        S      0:13      \_ sshd: duong@pts/0
   1263 pts/0    Ss     0:00          \_ -bash
   2873 pts/0    R+     0:00              \_ ps fax
   2874 pts/0    S+     0:00              \_ more

```

- Các process phía dưới đang được hiển thị như child trong cây process


## 6. Are there any zombies on your computer?


```sh
duong@homelab:~$ top

top - 17:10:15 up  3:57,  1 user,  load average: 0.00, 0.00, 0.00
Tasks: 216 total,   1 running, 215 sleeping,   0 stopped,   0 zombie
%Cpu(s):  0.0 us,  0.0 sy,  0.0 ni,100.0 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st 
MiB Mem :  15690.3 total,  14876.3 free,    639.0 used,    449.8 buff/cache     
MiB Swap:   4096.0 total,   4096.0 free,      0.0 used.  15051.3 avail Mem 
nhưng việc đọc thế này tôi ko hiểu thì có ý nghĩa gì nhỉ 
```

- State
  - `Tasks: 216 total,   1 running, 215 sleeping,   0 stopped,   0 zombie`
  - `216 total` -> tổng số taks/process mà top đang thống kê
  - `1 running` -> đang chạy
  - `215 slepping` -> đang ở trạng thái sleep/wait
  - `0 stopped` -> không có process nào đang stop
  - `0 zombie` -> không có zombie


- Zombie process

```
Parent Process
    ↓ fork
Child processes
    ↓ 
Child chạy xong
    ↓ 
Child exit
    ↓ 
Kernel vẫn giữ lại một ít thông tin: 
- PID
- Exit status
- accounting info
    ↓ 
Doijw parent gọi wait() / waitpid()
    ↓ 
parent nhận ekets quả
    ↓ 
Entry của child mới được dọn sạch
```

- Nếu child đã chết nhưng parent `chưa thu nhận exit status` process đó ở trạng thái `zombie`
- Tóm lại 
  *- ZOMBIE = Process đã kết thúc nhưng record của nó chưa được parent 'reap'*
- Vì vậy Zombie thường ko ăn CPU như một process đang chạy. Vấn đề là chiếm entry trong process table

## 7. Press h when in top to get some help on shortcuts in top. Can you sort the list by memory usage?

- Mở `top`
- Nhấn `h`
- xem phím tắt
- Tìm cách sort process theo mermory usage

```sh
  R,H,J,C . Toggle: 'R' Sort; 'H' Threads; 'J' Num justify; 'C' Coordinates
  f,X       Fields: 'f' add/remove/order/sort; 'X' increase fixed-width fields

Fields Management for window 1:Def, whose current sort field is %CPU
   Navigate with Up/Dn, Right selects for move then <Enter> or Left commits,
   'd' or <Space> toggles display, 's' sets sort.  Use 'q' or <Esc> to end!

* PID      = Process Id            OOMa     = OOMEM Adjustment    
* USER     = Effective User Name   OOMs     = OOMEM Score current 
* PR       = Priority              ENVIRON  = Environment vars    
* NI       = Nice Value            vMj      = Major Faults delta  
* VIRT     = Virtual Image (KiB)   vMn      = Minor Faults delta  
* RES      = Resident Size (KiB)   USED     = Res+Swap Size (KiB) 
* SHR      = Shared Memory (KiB)   nsIPC    = IPC namespace Inode 
* S        = Process Status        nsMNT    = MNT namespace Inode 
* %CPU     = CPU Usage             nsNET    = NET namespace Inode 
* %MEM     = Memory Usage (RES)    nsPID    = PID namespace Inode 
* TIME+    = CPU Time, hundredths  nsUSER   = USER namespace Inode

```

- Cần nắm được

```
s
→ chọn field dùng để sort

< / >
→ chuyển sort field trái/phải

R
→ đảo chiều sort

x
→ highlight field đang được sort
```