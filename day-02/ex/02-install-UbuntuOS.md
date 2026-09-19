## 1. Tạo thư mục riêng


```sh
mkdir -p "$HOME/workspace/05-linux-action-lab/VM-ISOs/ubuntu-22.04.5"

cd "$HOME/workspace/05-linux-action-lab/VM-ISOs/ubuntu-22.04.5"
```

## 2. Tải ISO


```sh
wget -c \
  https://releases.ubuntu.com/jammy/ubuntu-22.04.5-desktop-amd64.iso
```

## 2. Tải một public key riêng


```sh
wget \
  https://archive.ubuntu.com/ubuntu/project/ubuntu-archive-keyring.gpg \
  -O ubuntu-signing-keys.gpg
```

## 3. Xem Fingerprint bên trong public key


```sh
gpg \
  --no-default-keyring \
  --keyring ./ubuntu-signing-keys.gpg \
  --list-keys \
  --with-fingerprint


-------------------------
pub   rsa4096 2012-05-11 [SC]
      790B C727 7767 219C 42C8  6F93 3B4F E6AC C0B2 1F32
uid           [ unknown] Ubuntu Archive Automatic Signing Key (2012) <ftpmaster@ubuntu.com>

pub   rsa4096 2012-05-11 [SC]
      8439 38DF 228D 22F7 B374  2BC0 D94A A3F0 EFE2 1092
uid           [ unknown] Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>

pub   rsa4096 2018-09-17 [SC]
      F6EC B376 2474 EDA9 D21B  7022 8719 20D1 991B C93C
uid           [ unknown] Ubuntu Archive Automatic Signing Key (2018) <ftpmaster@ubuntu.com>

```

## 3. Dùng public key để kireemr tra chữ kí


```sh
gpgv \
  --keyring ./ubuntu-signing-keys.gpg \
  SHA256SUMS.gpg \
  SHA256SUMS

gpgv: Signature made Wed 11 Mar 2026 12:23:13 AM +07
gpgv:                using RSA key 843938DF228D22F7B3742BC0D94AA3F0EFE21092
gpgv: Good signature from "Ubuntu CD Image Automatic Signing Key (2012) <cdimage@ubuntu.com>"
```

## 4. Dùng Danh sách hash đã xá thực để kiểm tra ISO

```sh
sha256sum --check --ignore-missing SHA256SUMS
```

## 2. Tải checksum và chữ kí


```sh
wget \
  https://releases.ubuntu.com/jammy/SHA256SUMS \
  https://releases.ubuntu.com/jammy/SHA256SUMS.gpg
```


## 4. Xác thực SHA256 SUMS bằng chữ kí Ubuntu


```sh
gpgv \
  --keyring /usr/share/keyrings/ubuntu-archive-keyring.gpg \
  SHA256SUMS.gpg \
  SHA256SUMS

```