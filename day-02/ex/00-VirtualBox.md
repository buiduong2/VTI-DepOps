### Kiemr tra host trước khi cài virtual box 

```
Ubuntu hiện tại
= Host OS
= Chạy virtual Box
= Cung cấp CPU, RAM, SSD thật

CentOS trong Virtual Box
= Guest OS
= Nhìn thấy vCPU, RAM, Virtual DIsk
```

- `Kiểm tra đã cài chưa`
```sh
VBoxManage --version
zsh: command not found: VBoxManage
# Virtual Box chưa được cài đặt
```

- `Cần kiểm tra phần cứng máy host có đạt yêu cầu`

```sh
❯ cat /etc/os-release
PRETTY_NAME="Ubuntu 24.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.4 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo

## 

❯ uname -m
x86_64

## x86_64 tương thích với ISO CentOS x86_64.

❯ free -h
total        used        free      shared  buff/cache   available
Mem:            15Gi       5.7Gi       7.2Gi       932Mi       3.8Gi       9.7Gi
Swap:          4.0Gi          0B       4.0Gi

❯ lscpu | grep -E 'Model name|CPU\(s\)|Virtualization'
CPU(s):                                  12
On-line CPU(s) list:                     0-11
Model name:                              12th Gen Intel(R) Core(TM) i7-1255U
CPU(s) scaling MHz:                      21%
Virtualization:                          VT-x
NUMA node0 CPU(s):                       0-11


### VT-x đã bật: CPU hỗ trợ và firmware đang cho phép hardware virtualization.
```


### Cập nhật package index và kiểm tra gói Virtual Box

```sh
df -h /

sudo apt update

apt policy virtualbox
virtualbox:
  Installed: (none)
  Candidate: 7.0.16-dfsg-2ubuntu1.3 # Debian đóng gói phù hợp rồi
  Version table:
     7.0.16-dfsg-2ubuntu1.3 500
        500 http://vn.archive.ubuntu.com/ubuntu noble-updates/multiverse amd64 Packages
     7.0.16-dfsg-2 500
        500 http://vn.archive.ubuntu.com/ubuntu noble/multiverse amd64 Packages

```


### Kiểm tra secure Boot

- Các dependency `kermnel module`

```sh
❯ mokutil --sb-state
SecureBoot disabled
```

```
VirtualBox GUI/process
        ↓
VirtualBox kernel module
        ↓
Linux kernel
        ↓
VT-x và phần cứng thật
```

- Cần kiểm tra vì: 
  - Ko cho phép kernel nạp module chưa đươc xác nhân

### Cà đặt Virtual Box bằng APT

- Có thể bị lỗi dkms vì liên quan version kernel (Ubuntu 24.04)
- Dùng VirtualBox 7.2.16 

```sh
sudo apt install virtualbox
```

### Thêm repository chính thức

```
Ubuntu repository
→ có VirtualBox
→ nhưng chỉ có 7.0.16
→ module không build được với kernel 7.0

Oracle repository
→ có VirtualBox 7.2.16 mới hơn
```

```sh
wget https://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc \
  -O /tmp/oracle_vbox_2016.asc`
```

####  Tải public signing key

```sh
wget https://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc \
  -O /tmp/oracle_vbox_2016.asc
```
#### 2. Kiểm tra fingerprint
```sh
gpg --show-keys --with-fingerprint /tmp/oracle_vbox_2016.asc
```
Fingerprint phải là:

B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF


#### 3. Chuyển key vào keyring của APT
```sh
sudo install -d -m 0755 /etc/apt/keyrings
sudo gpg --dearmor --yes \
  -o /etc/apt/keyrings/oracle-virtualbox-2016.gpg \
  /tmp/oracle_vbox_2016.asc

```
### 4. Khai báo repository

```sh
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian noble contrib" \
  | sudo tee /etc/apt/sources.list.d/virtualbox.list
```
### 5. Cập nhật index và kiểm tra candidate
```sh
sudo apt update
apt policy virtualbox-7.2
```


### 6 Tải

```sh
sudo apt install virtualbox-7.2

```