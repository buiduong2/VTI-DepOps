## Câu 1 Display your current directory.

```sh
duong@homelab:~/VTI-ex/day02$ pwd
/home/duong/VTI-ex/day02

[duong@centos7-lab ~]$ pwd 
/home/duong 
[duong@centos7-lab ~]$ 
```

- `Điểm cần nắm`
  - `pwd` = Print working directory
  - In ra đường dẫn tuyệt đối của thư mục hiện tại


## câu 2: Change to the /etc directory.


```sh 
duong@homelab:~/VTI-ex/day02$ cd /etc
duong@homelab:/etc$ pwd
/etc
[duong@centos7-lab ~]$ cd /etc
[duong@centos7-lab etc]$ pwd
/etc
[duong@centos7-lab etc]$ _
```


- `Điểm cần nắm`
  - `/etc` là absolute path vì nó bắt đầu bằng `/`
  - `cd` được dùng để chuyển directory 
  - `/etc` chứa các file cấu hình của chương trình và dịch vụ

- VD: 
- `/etc/ssh` : chứa cấu hình ssh
- `/etc/passwd` : chứa thông tin tài khoản user cơ bản

## Câu 3: Now change to your home directory using only three key presses.

```sh
duong@homelab:/etc$ pwd
/etc
duong@homelab:/etc$ cd
duong@homelab:~$ pwd
/home/duong

[duong@centos7-lab etc]$ pwd
/etc
[duong@centos7-lab etc]$ cd
[duong@centos7-lab ~]$ pwd
/home/duong


```

- Bài giải: 
  - `cd` không có đối số sẽ đưa shell về home directory của user hiện tại

## Câu 4 Câu 4/17

- `Dùng tab completion`

```sh
[duong@centos7-lab ~]$ cd /boot/grub
[duong@centos7-lab grub]$ pwd
/boot/grub

duong@homelab:~$ cd /boot/grub/
duong@homelab:/boot/grub$ pwd
/boot/grub

```

- Kiến thức cần nắm
  - Bash dựa vào file/thư mục hiện có để đoán phần còn lại khi ta bấm `Tab` nếu dã đủ rõ tự điền nốt tên cho chúng ta
  - `Tab completion` = giảm số lần ký tự phải gõ + giảm lỗi sai gõ path


## Câu 5: Go to the parent directory of the current directory.


```sh
duong@homelab:/boot/grub$ pwd
/boot/grub
duong@homelab:/boot/grub$ cd ..
duong@homelab:/boot$ pwd
/boot

```

- Kiến thức cần nắm
    - `cd ..` : di chuyển lên một cấp trong cây thư mục

## Câu 6: Go to the root directory.


```sh
[duong@centos7-lab boot]$ pwd

/boot

[duong@centos7-lab boot]$ cd /

[duong@centos7-lab /]$ pwd

/

duong@homelab:/boot$ pwd

/boot

duong@homelab:/boot$ cd /

duong@homelab:/$ pwd

/
```

- Kiến thức cần nắm
    - `/` = root directory gốc của toàn bộ cây filesystem
    - `/root` = home directory của user root


## Câu 7: List the contents of the root directory.

```sh
[duong@centos7-lab /]$ pwd

/

[duong@centos7-lab /]$ ls

bin  boot  dev  etc  home  lib  lib64  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var

duong@homelab:/$ pwd

/

duong@homelab:/$ ls

bin                boot   dev  home  lib64              lost+found  mnt  proc  run   sbin.usr-is-merged  srv       sys  usr

bin.usr-is-merged  cdrom  etc  lib   lib.usr-is-merged  media       opt  root  sbin  snap                swap.img  tmp  var
```

- Kiến thức cần nắm: 
    - `ls` = list contents của directory
    - là lệnh liệt kê file và subdirectory trong thư mục hiện tại

## Câu 8/17 List a long listing of the root directory.
 
```sh
duong@homelab:/$ ls -l
total 4194388
lrwxrwxrwx   1 root root          7 Apr 22  2024 bin -> usr/bin
drwxr-xr-x   2 root root       4096 Feb 26  2024 bin.usr-is-merged
drwxr-xr-x   5 root root       4096 Sep  8 16:33 boot
drwxr-xr-x   2 root root       4096 Jan  1  1970 cdrom
drwxr-xr-x  20 root root       4360 Sep 17 09:40 dev
drwxr-xr-x 119 root root       4096 Sep 17 09:50 etc
drwxr-xr-x   3 root root       4096 Aug 30 03:55 home
lrwxrwxrwx   1 root root          7 Apr 22  2024 lib -> usr/lib
lrwxrwxrwx   1 root root          9 Apr 22  2024 lib64 -> usr/lib64
drwxr-xr-x   2 root root       4096 Feb 26  2024 lib.usr-is-merged
drwx------   2 root root      16384 Aug 30 03:52 lost+found
drwxr-xr-x   2 root root       4096 Feb 10  2026 media
drwxr-xr-x   2 root root       4096 Feb 10  2026 mnt
drwxr-xr-x   2 root root       4096 Feb 10  2026 opt
dr-xr-xr-x 279 root root          0 Sep 17 09:39 proc
drwx------   4 root root       4096 Aug 30 04:13 root
drwxr-xr-x  31 root root        940 Sep 17 09:50 run
lrwxrwxrwx   1 root root          8 Apr 22  2024 sbin -> usr/sbin
drwxr-xr-x   2 root root       4096 Oct  3  2025 sbin.usr-is-merged
drwxr-xr-x   2 root root       4096 Aug 30 04:03 snap
drwxr-xr-x   2 root root       4096 Feb 10  2026 srv
-rw-------   1 root root 4294967296 Aug 30 03:54 swap.img
dr-xr-xr-x  13 root root          0 Sep 17 09:39 sys
drwxrwxrwt  13 root root       4096 Sep 17 09:50 tmp
drwxr-xr-x  12 root root       4096 Feb 10  2026 usr
drwxr-xr-x  13 root root       4096 Aug 30 04:03 var

[duong@centos7-lab /]$ pwd
/
[duong@centos7-lab /]$ ls -l
total 20
lrwxrwxrwx.   1 root root    7 Sep 12 17:35 bin -> usr/bin
dr-xr-xr-x.   5 root root 4096 Sep 12 17:41 boot
drwxr-xr-x.  20 root root 3100 Sep 17 16:53 dev
drwxr-xr-x.  75 root root 8192 Sep 17 16:53 etc
drwxr-xr-x.   3 root root   19 Sep 12 17:40 home
lrwxrwxrwx.   1 root root    7 Sep 12 17:35 lib -> usr/lib
lrwxrwxrwx.   1 root root    9 Sep 12 17:35 lib64 -> usr/lib64
drwxr-xr-x.   2 root root    6 Apr 11  2018 media
drwxr-xr-x.   2 root root    6 Apr 11  2018 mnt
drwxr-xr-x.   2 root root    6 Apr 11  2018 opt
dr-xr-xr-x. 115 root root    0 Sep 17 16:53 proc
dr-xr-x---.   2 root root  114 Sep 12 17:40 root
drwxr-xr-x.  24 root root  720 Sep 17 16:53 run
lrwxrwxrwx.   1 root root    8 Sep 12 17:35 sbin -> usr/sbin
drwxr-xr-x.   2 root root    6 Apr 11  2018 srv
dr-xr-xr-x.  13 root root    0 Sep 17 16:53 sys
drwxrwxrwt.   9 root root 4096 Sep 17 16:54 tmp
drwxr-xr-x.  13 root root  155 Sep 12 17:35 usr
drwxr-xr-x.  19 root root  267 Sep 12 17:41 var

```

- Điểm cần nắm
    - `ls -l`
      - Long listing của thư mục hiện tại
      - Không chỉ hiện tên object. mà còn hiện thêm 
        - permission 
        - owner
        - group
        - file 
        - size
        - và timestamp
        - `->` symbolic link. 

## Câu 9 Stay where you are, and list the contents of /etc.

```sh

duong@homelab:/$ ls /etc
adduser.conf                   cron.yearly           grub.d           libaudit.conf   multipath            polkit-1       services           timezone
alternatives                   cryptsetup-initramfs  gshadow          libblockdev     multipath.conf       pollinate      sgml               tmpfiles.d
apparmor                       crypttab              gshadow-         libibverbs.d    nanorc               profile        shadow             ubuntu-advantage
apparmor.d                     dbus-1                gss              libnl-3         needrestart          profile.d      shadow-            ucf.conf
apport                         dconf                 gtk-3.0          locale.alias    netconfig            protocols      shells             udev
apt                            debconf.conf          hdparm.conf      locale.conf     netplan              pulse          skel               udisks2
avahi                          debian_version        host.conf        locale.gen      network              python3        smartd.conf        ufw
bash.bashrc                    default               hostname         localtime       networkd-dispatcher  python3.12     smartmontools      update-manager
bash_completion                deluser.conf          hosts            logcheck        networks             rc0.d          sos                update-motd.d
bash_completion.d              depmod.d              hosts.allow      login.defs      newt                 rc1.d          ssh                update-notifier
bindresvport.blacklist         dhcp                  hosts.deny       logrotate.conf  nftables.conf        rc2.d          ssl                UPower
binfmt.d                       dhcpcd.conf           ifplugd          logrotate.d     nsswitch.conf        rc3.d          subgid             usb_modeswitch.conf
byobu                          dpkg                  init.d           lsb-release     nvme                 rc4.d          subgid-            usb_modeswitch.d
ca-certificates                e2scrub.conf          initramfs-tools  lvm             openal               rc5.d          subuid             vconsole.conf
ca-certificates.conf           environment           inputrc          machine-id      opt                  rc6.d          subuid-            vdpau_wrapper.cfg
ca-certificates.conf.dpkg-old  environment.d         iproute2         magic           os-release           rcS.d          sudo.conf          vim
cloud                          ethertypes            iscsi            magic.mime      overlayroot.conf     resolv.conf    sudoers            vmware-tools
console-setup                  fonts                 issue            manpath.config  PackageKit           rmt            sudoers.d          vtrgb
credstore                      fstab                 issue.net        mdadm           pam.conf             rpc            sudo_logsrvd.conf  vulkan
credstore.encrypted            fuse.conf             kernel           mime.types      pam.d                rsyslog.conf   supercat           wgetrc
cron.d                         fwupd                 landscape        mke2fs.conf     passwd               rsyslog.d      sysctl.conf        wpa_supplicant
cron.daily                     gai.conf              ldap             ModemManager    passwd-              screenrc       sysctl.d           X11
cron.hourly                    gnutls                ld.so.cache      modprobe.d      perl                 security       sysstat            xattr.conf
cron.monthly                   groff                 ld.so.conf       modules         pki                  selinux        systemd            xdg
crontab                        group                 ld.so.conf.d     modules-load.d  plymouth             sensors3.conf  terminfo           xml
cron.weekly                    group-                legal            mtab            pm                   sensors.d      thermald           zsh_command_not_found
duong@homelab:/$ pwd
/


[duong@centos7-lab /]$ ls /etc
adjtime                  cron.monthly             filesystems  inittab         lvm                       passwd          rc3.d           shadow              terminfo
aliases                  crontab                  firewalld    inputrc         machine-id                passwd-         rc4.d           shadow-             tmpfiles.d
aliases.db               cron.weekly              fstab        iproute2        magic                     pkcs11          rc5.d           shells              tuned
alternatives             crypttab                 gcrypt       issue           makedumpfile.conf.sample  pki             rc6.d           skel                udev
anacrontab               csh.cshrc                gnupg        issue.net       man_db.conf               plymouth        rc.d            ssh                 vconsole.conf
asound.conf              csh.login                GREP_COLORS  kdump.conf      mke2fs.conf               pm              rc.local        ssl                 virc
audisp                   dbus-1                   groff        kernel          modprobe.d                polkit-1        redhat-release  statetab            wpa_supplicant
audit                    default                  group        krb5.conf       modules-load.d            popt.d          resolv.conf     statetab.d          X11
bash_completion.d        depmod.d                 group-       krb5.conf.d     motd                      postfix         rpc             subgid              xdg
bashrc                   dhcp                     grub2.cfg    ld.so.cache     mtab                      ppp             rpm             subuid              xinetd.d
binfmt.d                 DIR_COLORS               grub.d       ld.so.conf      my.cnf                    prelink.conf.d  rsyslog.conf    sudo.conf           yum
centos-release           DIR_COLORS.256color      gshadow      ld.so.conf.d    my.cnf.d                  printcap        rsyslog.d       sudoers             yum.conf
centos-release-upstream  DIR_COLORS.lightbgcolor  gshadow-     libaudit.conf   NetworkManager            profile         rwtab           sudoers.d           yum.repos.d
chkconfig.d              dracut.conf              gss          libnl           networks                  profile.d       rwtab.d         sudo-ldap.conf
chrony.conf              dracut.conf.d            host.conf    libuser.conf    nsswitch.conf             protocols       sasl2           sysconfig
chrony.keys              e2fsck.conf              hostname     locale.conf     nsswitch.conf.bak         python          securetty       sysctl.conf
cron.d                   environment              hosts        localtime       openldap                  qemu-ga         security        sysctl.d
cron.daily               ethertypes               hosts.allow  login.defs      opt                       rc0.d           selinux         systemd
cron.deny                exports                  hosts.deny   logrotate.conf  os-release                rc1.d           services        system-release
cron.hourly              favicon.png              init.d       logrotate.d     pam.d                     rc2.d           sestatus.conf   system-release-cpe
[duong@centos7-lab /]$ pwd
/

```


- `Kiến thức cần nắm`
  - `ls <path>`
    - Xem nội dung của `<path>` mà không đổi current directory

## Câu 10: Stay where you are, and list the contents of /bin and /sbin.

- Một command duy nhất list cả 2 directory

```sh

[duong@centos7-lab /]$ pwd
/
[duong@centos7-lab /]$ ls /bin /sbin
/bin:
[                                   fg                     lesskey               nl-route-get              setfacl               systemd-inhibit
addr2line                           fgconsole              lesspipe.sh           nl-route-list             setfont               systemd-loginctl
alias                               fgrep                  lexgrog               nl-rule-list              setkeycodes           systemd-machine-id-setup
apropos                             file                   link                  nl-tctree-list            setleds               systemd-notify
ar                                  find                   linux32               nl-util-addr              setmetamode           systemd-nspawn
arch                                findmnt                linux64               nm                        setpriv               systemd-path
as                                  fipscheck              linux-boot-prober     nmcli                     setsid                systemd-run
aserver                             fipshmac               ln                    nm-online                 setterm               systemd-stdio-bridge
aulast                              firewall-cmd           loadkeys              nmtui                     setup-nsssysinit      systemd-sysv-convert
aulastlog                           firewall-offline-cmd   loadunimap            nmtui-connect             setup-nsssysinit.sh   systemd-tmpfiles
ausyscall                           flock                  locale                nmtui-edit                setvtrgb              systemd-tty-ask-password-agent
auvirt                              fmt                    localectl             nmtui-hostname            sftp                  tabs
awk                                 fold                   localedef             nohup                     sg                    tac
base64                              free                   logger                nproc                     sg_compare_and_write  tail
basename                            gapplication           login                 nroff                     sg_copy_results       tailf
bash                                gawk                   loginctl              nsenter                   sg_dd                 tar
bashbug                             gdbus                  logname               nss-policy-check          sg_decode_sense       taskset
bashbug-64                          gencat                 look                  numfmt                    sg_emc_trespass       tbl
bc                                  genl-ctrl-list         ls                    objcopy                   sg_format             teamd
bg                                  geqn                   lsattr                objdump                   sg_get_config         teamdctl
bond2team                           getconf                lsblk                 od                        sg_get_lba_status     teamnl
bootctl                             getent                 lscpu                 oldfind                   sg_ident              tee
busctl                              getfacl                lsinitrd              open                      sginfo                test
cal                                 getkeycodes            lsipc                 openssl                   sg_inq                testgdbm
ca-legacy                           getopt                 lslocks               openvt                    sg_logs               tic
captoinfo                           getopts                lslogins              os-prober                 sg_luns               timedatectl
cat                                 gettext                lsmem                 p11-kit                   sg_map                timeout
catchsegv                           gettext.sh             lsns                  page_owner_sort           sg_map26              tload
catman                              gio                    lsscsi                passwd                    sgm_dd                tmon
cd                                  gio-querymodules-64    lua                   paste                     sg_modes              toe
centrino-decode                     glib-compile-schemas   luac                  pathchk                   sg_opcodes            top
certutil                            gmake                  lz4                   pchrt                     sgp_dd                touch
c++filt                             gneqn                  lz4c                  pflags                    sg_persist            tput
chacl                               gnroff                 lz4cat                pgawk                     sg_prevent            tr
chage                               gpasswd                machinectl            pgrep                     sg_raw                tracepath
chattr                              gpg                    mailq                 pic                       sg_rbuf               tracepath6
chcon                               gpg2                   mailq.postfix         pinentry                  sg_rdac               troff
chfn                                gpg-agent              make                  pinentry-curses           sg_read               true
chgrp                               gpgconf                makedb                ping                      sg_read_block_limits  truncate
chmem                               gpg-connect-agent      man                   ping6                     sg_read_buffer        trust
chmod                               gpg-error              mandb                 pinky                     sg_readcap            tset
chown                               gpgparsemail           manpath               pk12util                  sg_read_long          tsort
chronyc                             gpgsplit               mapscrn               pkaction                  sg_reassign           tty
chrt                                gpgv                   mcookie               pkcheck                   sg_referrals          turbostat
chsh                                gpgv2                  md5sum                pkexec                    sg_requests           tzselect
chvt                                gpg-zip                mesg                  pkg-config                sg_reset              udevadm
cksum                               gpic                   mixartloader          pkill                     sg_rmsn               ul
clear                               gprof                  mkdir                 pkla-admin-identities     sg_rtpg               umask
cmp                                 grep                   mkfifo                pkla-check-authorization  sg_safte              umount
cmsutil                             groff                  mkinitrd              pkttyagent                sg_sanitize           unalias
col                                 grops                  mknod                 pldd                      sg_sat_identify       uname
colcrt                              grotty                 mktemp                plymouth                  sg_sat_phy_event      unexpand
colrm                               groups                 modutil               pmap                      sg_sat_set_features   unicode_start
column                              grub2-editenv          more                  post-grohtml              sg_scan               unicode_stop
comm                                grub2-file             mount                 powernow-k8-decode        sg_senddiag           uniq
command                             grub2-fstest           mountpoint            pr                        sg_ses                unlink
coredumpctl                         grub2-glue-efi         msgattrib             preconv                   sg_start              unlz4
cp                                  grub2-kbdcomp          msgcat                pre-grohtml               sg_stpg               unshare
cpio                                grub2-menulst2cfg      msgcmp                printenv                  sg_sync               unxz
cpupower                            grub2-mkfont           msgcomm               printf                    sg_test_rwbuf         update-ca-trust
crlutil                             grub2-mkimage          msgconv               prlimit                   sg_turs               update-mime-database
crontab                             grub2-mklayout         msgen                 ps                        sg_unmap              uptime
csplit                              grub2-mknetdir         msgexec               psfaddtable               sg_verify             urlgrabber
csslint-0.6                         grub2-mkpasswd-pbkdf2  msgfilter             psfgettable               sg_vpd                users
curl                                grub2-mkrelpath        msgfmt                psfstriptable             sg_write_buffer       usleep
cut                                 grub2-mkrescue         msggrep               psfxtable                 sg_write_long         usx2yloader
cvtsudoers                          grub2-mkstandalone     msghack               ptaskset                  sg_write_same         utmpdump
date                                grub2-render-label     msginit               ptx                       sg_wr_mode            uuidgen
db_archive                          grub2-script-check     msgmerge              pwd                       sg_xcopy              vdir
db_checkpoint                       grub2-syslinux2cfg     msgunfmt              pwdx                      sh                    vi
db_deadlock                         gsettings              msguniq               pwmake                    sha1sum               view
db_dump                             gsoelim                mv                    pwscore                   sha224sum             vlock
db_dump185                          gtar                   namei                 pydoc                     sha256sum             vmstat
db_hotbackup                        gtbl                   ndptool               python                    sha384sum             vxloader
db_load                             gtroff                 neqn                  python2                   sha512sum             w
db_log_verify                       gunzip                 newaliases            python2.7                 showconsolefont       wait
db_printlog                         gzexe                  newaliases.postfix    qemu-ga                   showkey               wall
db_recover                          gzip                   newgidmap             ranlib                    shred                 watch
db_replicate                        hdsploader             newgrp                raw                       shuf                  watchgnupg
db_stat                             head                   newuidmap             read                      signver               wc
db_tuner                            hexdump                nf-ct-add             readelf                   size                  wdctl
db_upgrade                          hostid                 nf-ct-list            readlink                  skill                 whatis
dbus-binding-tool                   hostname               nf-exp-add            realpath                  slabinfo              whereis
dbus-cleanup-sockets                hostnamectl            nf-exp-delete         recode-sr-latin           slabtop               which
dbus-daemon                         i386                   nf-exp-list           rename                    sleep                 whiptail
dbus-monitor                        iconv                  nf-log                renice                    slogin                who
dbus-run-session                    id                     nf-monitor            rescan-scsi-bus.sh        snice                 whoami
dbus-send                           idiag-socket-details   nf-queue              reset                     soelim                write
dbus-test-tool                      idn                    ngettext              resizecons                sort                  x86_64
dbus-update-activation-environment  igawk                  nice                  rev                       sotruss               x86_energy_perf_policy
dbus-uuidgen                        info                   nisdomainname         rm                        split                 xargs
db_verify                           infocmp                nl                    rmail                     sprof                 xgettext
dc                                  infokey                nl-addr-add           rmail.postfix             sqlite3               xmlcatalog
dd                                  infotocap              nl-addr-delete        rmdir                     ssh                   xmllint
deallocvt                           install                nl-addr-list          rpcgen                    ssh-add               xmlwf
df                                  ionice                 nl-class-add          rpm                       ssh-agent             xz
dgawk                               ipcalc                 nl-class-delete       rpm2cpio                  ssh-copy-id           xzcat
diff                                ipcmk                  nl-classid-lookup     rpmdb                     ssh-keygen            xzcmp
diff3                               ipcrm                  nl-class-list         rpmkeys                   ssh-keyscan           xzdec
dir                                 ipcs                   nl-cls-add            rpmquery                  ssltap                xzdiff
dircolors                           iptables-xml           nl-cls-delete         rpmverify                 stat                  xzegrep
dirname                             isosize                nl-cls-list           rsyslog-recover-qi.pl     stdbuf                xzfgrep
dmesg                               jobs                   nl-fib-lookup         runcon                    strings               xzgrep
dnsdomainname                       join                   nl-link-enslave       run-parts                 strip                 xzless
domainname                          journalctl             nl-link-ifindex2name  rvi                       stty                  xzmore
dracut                              kbdinfo                nl-link-list          rview                     su                    yes
du                                  kbd_mode               nl-link-name2ifindex  scp                       sudo                  ypdomainname
dumpkeys                            kbdrate                nl-link-release       script                    sudoedit              yum
dwp                                 kdumpctl               nl-link-set           scriptreplay              sudoreplay            zcat
echo                                kernel-install         nl-link-stats         scsi_logging_level        sum                   zcmp
egrep                               kill                   nl-list-caches        scsi_mandat               sync                  zdiff
eject                               kmod                   nl-list-sockets       scsi_readcap              systemctl             zegrep
elfedit                             last                   nl-monitor            scsi_ready                systemd-analyze       zfgrep
env                                 lastb                  nl-neigh-add          scsi-rescan               systemd-ask-password  zforce
envsubst                            lastlog                nl-neigh-delete       scsi_satl                 systemd-cat           zgrep
eqn                                 lchfn                  nl-neigh-list         scsi_start                systemd-cgls          zless
ex                                  lchsh                  nl-neightbl-list      scsi_stop                 systemd-cgtop         zmore
expand                              ld                     nl-pktloc-lookup      scsi_temperature          systemd-coredumpctl   znew
expr                                ld.bfd                 nl-qdisc-add          sdiff                     systemd-delta         zsoelim
factor                              ldd                    nl-qdisc-delete       secon                     systemd-detect-virt
fallocate                           ld.gold                nl-qdisc-list         sed                       systemd-escape
false                               less                   nl-route-add          seq                       systemd-firstboot
fc                                  lessecho               nl-route-delete       setarch                   systemd-hwdb

/sbin:
accessdb              cracklib-unpacker          groupadd                   lnstat             nl-pktloc-lookup            rtpr                       useradd
addgnupghome          create-cracklib-dict       groupdel                   load_policy        nl-qdisc-add                rtstat                     userdel
addpart               crond                      groupmems                  logrotate          nl-qdisc-delete             runlevel                   usermod
adduser               ctrlaltdel                 groupmod                   logsave            nl-qdisc-list               runuser                    usernetctl
agetty                ctstat                     grpck                      losetup            nologin                     sasldblistusers2           vgcfgbackup
alternatives          debugfs                    grpconv                    lpasswd            nstat                       saslpasswd2                vgcfgrestore
anacron               delpart                    grpunconv                  lshw               ownership                   sefcontext_compile         vgchange
applygnupgdefaults    depmod                     grub2-bios-setup           lsmod              packer                      selabel_digest             vgck
arpd                  devlink                    grub2-get-kernel-settings  luseradd           pam_console_apply           selabel_lookup             vgconvert
arping                dhclient                   grub2-install              luserdel           pam_tally2                  selabel_lookup_best_match  vgcreate
audispd               dhclient-script            grub2-macbless             lusermod           pam_timestamp_check         selabel_partial_match      vgdisplay
auditctl              dmeventd                   grub2-mkconfig             lvchange           parted                      selinuxconlist             vgexport
auditd                dmfilemapd                 grub2-ofpathname           lvconvert          partprobe                   selinuxdefcon              vgextend
augenrules            dmidecode                  grub2-probe                lvcreate           partx                       selinuxenabled             vgimport
aureport              dmsetup                    grub2-reboot               lvdisplay          pdata_tools                 selinuxexeccon             vgimportclone
ausearch              dmstats                    grub2-rpm-sort             lvextend           pidof                       selinux_restorecon         vgmerge
authconfig            dracut                     grub2-set-default          lvm                ping6                       semodule                   vgmknodes
authconfig-tui        dumpe2fs                   grub2-setpassword          lvmconf            pivot_root                  sendmail                   vgreduce
autrace               e2freefrag                 grub2-sparc64-setup        lvmconfig          plymouthd                   sendmail.postfix           vgremove
avcstat               e2fsck                     grubby                     lvmdiskscan        plymouth-set-default-theme  service                    vgrename
badblocks             e2image                    halt                       lvmdump            postalias                   sestatus                   vgs
biosdecode            e2label                    hardlink                   lvmetad            postcat                     setcap                     vgscan
biosdevname           e2undo                     hwclock                    lvmpolld           postconf                    setenforce                 vgsplit
blkdeactivate         e4defrag                   iconvconfig                lvmsadc            postdrop                    setfiles                   vigr
blkdiscard            eapol_test                 iconvconfig.x86_64         lvmsar             postfix                     setsebool                  vipw
blkid                 ebtables                   ifcfg                      lvreduce           postkick                    sfdisk                     virt-what
blockdev              ebtables-restore           ifdown                     lvremove           postlock                    shutdown                   visudo
bridge                ebtables-save              ifenslave                  lvrename           postlog                     sln                        vmcore-dmesg
btrfs                 era_check                  ifstat                     lvresize           postmap                     smtp-sink                  vpddecode
btrfsck               era_dump                   ifup                       lvs                postmulti                   smtp-source                weak-modules
btrfs-convert         era_invalidate             init                       lvscan             postqueue                   ss                         wipefs
btrfs-debug-tree      era_restore                insmod                     makedumpfile       postsuper                   sshd                       wpa_cli
btrfs-find-root       ethtool                    install-info               matchpathcon       poweroff                    sshd-keygen                wpa_passphrase
btrfs-image           faillock                   installkernel              mkdict             ppp-watch                   sulogin                    wpa_supplicant
btrfs-map-logical     fdformat                   intel-microcode2ucode      mkdumprd           pvchange                    sushell                    xfs_admin
btrfs-select-super    fdisk                      ip                         mke2fs             pvck                        swaplabel                  xfs_bmap
btrfstune             filefrag                   ip6tables                  mkfs               pvcreate                    swapoff                    xfs_copy
btrfs-zero-log        findfs                     ip6tables-restore          mkfs.btrfs         pvdisplay                   swapon                     xfs_db
build-locale-archive  firewalld                  ip6tables-save             mkfs.cramfs        pvmove                      switch_root                xfs_estimate
cacertdir_rehash      fixfiles                   iprconfig                  mkfs.ext2          pvremove                    sysctl                     xfs_freeze
cache_check           fsadm                      iprdbg                     mkfs.ext3          pvresize                    sys-unconfig               xfs_fsr
cache_dump            fsck                       iprdump                    mkfs.ext4          pvs                         tc                         xfs_growfs
cache_metadata_size   fsck.btrfs                 iprinit                    mkfs.minix         pvscan                      telinit                    xfs_info
cache_repair          fsck.cramfs                iprsos                     mkfs.xfs           pwck                        thin_check                 xfs_io
cache_restore         fsck.ext2                  iprupdate                  mkhomedir_helper   pwconv                      thin_delta                 xfs_logprint
cache_writeback       fsck.ext3                  ipset                      mklost+found       pwhistory_helper            thin_dump                  xfs_mdrestore
capsh                 fsck.ext4                  iptables                   mkswap             pwunconv                    thin_ls                    xfs_metadump
cbq                   fsck.minix                 iptables-restore           modinfo            rdisc                       thin_metadata_size         xfs_mkfile
cfdisk                fsck.xfs                   iptables-save              modprobe           rdma                        thin_repair                xfs_ncheck
chcpu                 fsfreeze                   irqbalance                 netreport          readprofile                 thin_restore               xfs_quota
chgpasswd             fstrim                     kexec                      NetworkManager     reboot                      thin_rmap                  xfs_repair
chkconfig             fxload                     killall5                   new-kernel-pkg     resize2fs                   thin_trim                  xfs_rtcp
chpasswd              genhomedircon              kpartx                     newusers           resizepart                  tracepath                  xtables-multi
chronyd               genhostid                  lchage                     nl-class-add       restorecon                  tracepath6                 zdump
chroot                genl                       ldattach                   nl-class-delete    rmmod                       tune2fs                    zic
clock                 genl-ctrl-list             ldconfig                   nl-classid-lookup  routef                      tuned                      zramctl
clockdiff             getcap                     lgroupadd                  nl-class-list      routel                      tuned-adm
consoletype           getenforce                 lgroupdel                  nl-cls-add         rsyslogd                    udevadm
cracklib-check        getpcaps                   lgroupmod                  nl-cls-delete      rtacct                      unix_chkpwd
cracklib-format       getsebool                  lid                        nl-cls-list        rtcwake                     unix_update
cracklib-packer       glibc_post_upgrade.x86_64  lnewusers                  nl-link-list       rtmon                       update-alternatives
[duong@centos7-lab /]$ pwd
/

```

- Điểm cần nắm: 
    - `ps path1 path2`
       - Có thể liệt kê nhiều directoryt trong cùng một lệnh , và `ls` sẽ in từng directoryt trước phần nội dung của nó

## Câu 11: Stay where you are, and list the contents of ~.

```sh
duong@homelab:/$ ls ~
local-transcriber  VTI-ex
duong@homelab:/$ pwd
/
duong@homelab:/$ 

[duong@centos7-lab /]$ pwd
/
[duong@centos7-lab /]$ ls ~
[duong@centos7-lab /]$ pwd
/
[duong@centos7-lab /]$ 

```

- Điểm cần nắm: 
  - `~` = home directory của user hiện tại


## Câu 12: List all the files (including hidden files) in your home directory.

```sh
duong@homelab:/$ ls -a ~
.  ..  .bash_history  .bash_logout  .bashrc  .cache  .config  .lesshst  .local  local-transcriber  .profile  .ssh  .sudo_as_admin_successful  VTI-ex

[duong@centos7-lab /]$ ls -a ~
.  ..  .bash_history  .bash_logout  .bash_profile  .bashrc


```

- Điểm cần nắm: 
  - File hoặc directory bắt đầu bằng `.` được coi là `hidden`
  - `-a` : hiện cả hidden files 
  - `.` = current directory
  - `..` parent directory


## Câu 13: List the files in /boot in a human readable format.

- Cần option nào để size hiển thị kiểu `K` `M` `G` thay vì số byte khó đọc

```sh
[duong@centos7-lab /]$ ls -lh /boot/
total 110M
-rw-r--r--. 1 root root 150K Oct 19  2020 config-3.10.0-1160.el7.x86_64
drwxr-xr-x. 3 root root   17 Sep 12 17:35 efi
drwxr-xr-x. 2 root root   27 Sep 12 17:36 grub
drwx------. 5 root root   97 Sep 12 17:40 grub2
-rw-------. 1 root root  60M Sep 12 17:38 initramfs-0-rescue-79453257a7d0d5468246e0c9fc045698.img
-rw-------. 1 root root  21M Sep 12 17:40 initramfs-3.10.0-1160.el7.x86_64.img
-rw-------. 1 root root  13M Sep 12 17:41 initramfs-3.10.0-1160.el7.x86_64kdump.img
-rw-r--r--. 1 root root 314K Oct 19  2020 symvers-3.10.0-1160.el7.x86_64.gz
-rw-------. 1 root root 3.5M Oct 19  2020 System.map-3.10.0-1160.el7.x86_64
-rwxr-xr-x. 1 root root 6.5M Sep 12 17:38 vmlinuz-0-rescue-79453257a7d0d5468246e0c9fc045698
-rwxr-xr-x. 1 root root 6.5M Oct 19  2020 vmlinuz-3.10.0-1160.el7.x86_64
duong@homelab:/$ ls -lh /boot/
total 193M
-rw-r--r-- 1 root root 281K Jul 31 20:56 config-6.8.0-138-generic
-rw-r--r-- 1 root root 281K Aug  1 02:25 config-6.8.0-139-generic
drwxr-xr-x 3 root root 4.0K Jan  1  1970 efi
drwxr-xr-x 5 root root 4.0K Sep  8 16:33 grub
lrwxrwxrwx 1 root root   28 Sep  8 16:33 initrd.img -> initrd.img-6.8.0-139-generic
-rw-r--r-- 1 root root  73M Aug 30 03:57 initrd.img-6.8.0-138-generic
-rw-r--r-- 1 root root  73M Sep  8 16:33 initrd.img-6.8.0-139-generic
lrwxrwxrwx 1 root root   28 Aug 30 03:54 initrd.img.old -> initrd.img-6.8.0-138-generic
drwx------ 2 root root  16K Aug 30 03:52 lost+found
-rw------- 1 root root 8.8M Jul 31 20:56 System.map-6.8.0-138-generic
-rw------- 1 root root 8.8M Aug  1 02:25 System.map-6.8.0-139-generic
lrwxrwxrwx 1 root root   25 Sep  8 16:33 vmlinuz -> vmlinuz-6.8.0-139-generic
-rw------- 1 root root  15M Jul 31 20:56 vmlinuz-6.8.0-138-generic
-rw------- 1 root root  15M Aug  1 02:26 vmlinuz-6.8.0-139-generic
lrwxrwxrwx 1 root root   25 Aug 30 03:54 vmlinuz.old -> vmlinuz-6.8.0-138-generic
```

- `Điểm cần nắm`
    - `-h` = human-readable size
      - khiến kích thước hiển thị kiểu 281K, 73M, 15M 

## câu 14: Create a directory testdir in your home directory.

```sh
duong@homelab:/$ mkdir ~/testdir
duong@homelab:/$ ls ~
local-transcriber  testdir  VTI-ex
[duong@centos7-lab /]$ mkdir ~/test-dir
[duong@centos7-lab /]$ ls ~
test-dir
```


- Điểm cần nắm: 
  - `mkdir` : tạo directory

## Câu 15: Change to the /etc directory, stay here and create a directory newdir in your home directory.


## Câu 16: Create in one command the directories ~/dir1/dir2/dir3 (dir3 là thư mục con của dir2, và dir2 là thư mục con của dir1).

- Tạo luôn cả cây thư mục - Nhưng lam bằng `một command`


```sh
[duong@centos7-lab /]$ mkdir ~/dir1/dir2/dir3
mkdir: cannot create directory ‘/home/duong/dir1/dir2/dir3’: No such file or directory
[duong@centos7-lab /]$ man mkdir
[duong@centos7-lab /]$ mkdir -p  ~/dir1/dir2/dir3
[duong@centos7-lab /]$ ls -R ~/dir1/
/home/duong/dir1/:
dir2

/home/duong/dir1/dir2:
dir3

/home/duong/dir1/dir2/dir3:
[duong@centos7-lab /]$ 
duong@homelab:/$ mkdir -p ~/dir1/dir2/dir3 
duong@homelab:/$ ls -R ~/dir1/
/home/duong/dir1/:
dir2

/home/duong/dir1/dir2:
dir3

/home/duong/dir1/dir2/dir3:
duong@homelab:/$ 

```

- Điểm cần nắm: 
  - `mkdir` mặc định chỉ tạo `thư mục cuối cùng` nếu parent không tồn tại sẽ bị lỗi
  - `mkdir -p` = --parents : Nếu các parent directory chưa tồn tại thì tạo luôn chúng
  - `ls -R`: đệ quy và listing contents từng thành phần

## Câu 17 Remove the directory testdir.

```sh
duong@homelab:/$ ls ~

dir1  local-transcriber  testdir  VTI-ex

duong@homelab:/$ rmdir ~/testdir/

duong@homelab:/$ ls ~

dir1  local-transcriber  VTI-ex

[duong@centos7-lab /]$ ls ~

dir1  testdir

[duong@centos7-lab /]$ rmdir ~/testdir/ 

[duong@centos7-lab /]$ ls ~

dir1
```

- `điểm cần nắm`
  - `rmdir` : Xóa thư mục rỗng. Nếu có file hoặc subdirectory thì nó sẽ báo lỗi