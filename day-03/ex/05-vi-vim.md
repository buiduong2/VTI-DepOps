## Start the vimtutor and do some or all of the exercises. You might need to run aptitude install vim on xubuntu

```sh
vimtutor
```

- Giá trị cốt lõi
  - `vimtutor` là môi trường học vim bằng cách `thực hành trực tiếp`
  - Ko phải tài liệu chỉ để đọc.


## What 3 key sequence in command mode will duplicate the current line.


- trong normal mode
- Đầu tiên là copy/yank cả dòng hiện tại
- Sau đó paste xuống dưới

```
Trong normal mode
- Copy dòng hiện tại `yy`
- Paste xuống dưới `p`
```

```sh
yyp
```

- Điểm cần nắm: 
  - trong normal moed: 
    - `yy` yank của dòng hiện tại
    - `p` paste sau dòng hiện tại
  - `yyp` : duplicate current line



## 3. What 3 key sequence in command mode will switch two lines' place (line five becomes line six and line six becomes line five).

- Tráo đổi vị trí 2 dòng

- Gợi ý: 
  - xóa / cắt dòng hiện tại
  - rồi paste nó xuống dưới dòng kế tiếp

```sh
ddp
```
- Điểm cần nawms: 
  - `dd` = delete cả dòng hiện tại
  - `p` = paste dòng đó xuống sau dòng kế tiếp
- Trong Vim
  - `dd` thực tế vừa `xóa dòng khỏi vị trí hiện tại` vừa đưa nó vào register , nên về cảm giác sử dụng giống `cut`

## 4. What 2 key sequence in command mode will switch a character's place with the next one.

- Đưa kí tự hiện tại sang kí tự kế 
```sh
xp
```

- `x` = Xóa kí tự dưới cursor , đồng thời đưa kí tự đó vào register
- `p` Paste sau vị trí hiện tại


## 5. vi can understand macro's. A macro can be recorded with q followed by the name of the macro. So qa will record the macro named a. Pressing q again will end the recording. You can recall the macro with @ followed by the name of the macro. Try this example: i 1 'Escape Key' qa yyp 'Ctrl a' q 5@a (Ctrl a will increase the number with one).

- `Vim có thể hiểu macro`
  - Một macro có thể được ghi lại bằng cách nhấn `q` rồi nhấn tên của macro
  - VD `qa` nghĩa là bắt đầu ghi macro tên `a`
  - Nhấn `q` lần nữa để kết thúc ghi macro
  - Ta có thể gọi lại macro bằng cách nhấn `@` ròi tên macro
  - Hãy thử VD sau: 
  - `i 1` -> `Esc` -> `qa` -> `yyp` -> `Ctrl A` -> `q` -> `5@a`


- Cơ chế: 
  - Ghi một chuỗi thao tác
  - -> lưu macro
  - -> gọi lại chuỗi đó nhiều lần

```
1
2
3
4
5
6
7
~                      
```

```
i          → vào Insert mode
1          → nhập số 1
Esc        → về Normal mode

qa         → bắt đầu record macro vào register a
yyp        → copy dòng hiện tại rồi paste xuống dưới
Ctrl+a     → tăng số dưới cursor lên 1
q          → kết thúc record

5@a        → chạy macro a thêm 5 lần
```

- Giá trị cốt lõi cần nắm: 
  - Macro trong vim đơn giản là 
    - `Ghi lại một chuỗi thao tác rồi phát lại chuỗi đó`

## 6. Copy /etc/passwd to your ~/passwd. Open the last one in vi and press Ctrl v. Use the arrow keys to select a Visual Block, you can copy this with y or delete it with d. Try pasting it.

- Nghĩa là: 
  - 1. Copy `/etc/passwd` về home thành file `passwd`
  - 2. Mở file đó bằng Vim
  - 3. `Ctrl+V` để vào `Visual block mode`
  - 4. Dùng phím di chuyển để chọn một khối chữ
  - 5. Thử `y` để copy thằng `d` để delete
  - 6. Thử paste bằng `p`


- `Visual Block mode`
-  Chế độ chọn văn bản theo hình chữ nhật/cột thay vì chọn liên tục theo dòng như kiểu bôi đen thông thường
-  Visual block Mode rất hữu ích khi ta muốn thao tác `theo cột` trên nhiều dòng cùng lúc
   -  Xóa cùng một đoạn ở nhiều dòng
   -  Copy một cột dữ liệu
   -  Chèn cùng một nội dung vào nhiều dòng
-  


```sh
uidd:x:104:105::/run/uuidd:/usr/sbin/nologin
cpdump:x:105:107::/nonexistent:/usr/sbin/nologin
tss:x:106:108:TPM software stack,,,:/var/lib/tpm:/bin/false
landscape:x:107:109::/var/lib/landscape:/usr/sbin/nologin
fwupd-refresh:x:989:989:Firmware update daemon:/var/lib/fwupd:/usr/sbin/nologin
usbmux:x:108:46:usbmux daemon,,,:/var/lib/usbmux:/usr/sbin/nologin
duong:x:1000:1000:Duong:/home/duong:/bin/bash
sshd:x:109:65534::/run/sshd:/usr/sbin/nologin
auidd:x:104:vahi:x:110:111:Avahi mDNS daemon,,,:/run/avahi-daemon:/usr/sbin/nologin
 cpdump:x:10
 tss:x:106:1
 landscape:x
 fwupd-refre
 usbmux:x:10
 duong:x:100
 sshd:x:109:
 auidd:x:104:vahi:x:110
  cpdump:x:10
  tss:x:106:1
  landscape:x
  fwupd-refre
  usbmux:x:10
  duong:x:100
  sshd:x:109:
  avahi:x:110
~                 
```

- Điểm cốt lõi:" 
  - Visual block Mode dùng để thao tác `theo cột` trên nhiều dòng
  - Khác với
    - `v` -> chọn ký tự liên tục
    - `V` -> chọn nguyên dòng
    - `Ctrl+V` -> chọn khối chữ nhật


## 7. What does dwwP do when you are at the beginning of a word in a sentence?

- `dwwp` dùng để `đổi chỗ từ hiện tại với từ kế tiếp` khi cursor đang ở đầu một từ

- Tách ra 
  - `dw` = Delete /cut từ hiện tại vào register
  - `w` = di chuyển tới đầu từ kế tiếp
  - `P` paster trước vị trí cursor (P viết hoa before, p thường thì after)

- VD: 

```sh
hello world
^

dwwP

# KQ:

world hello
```