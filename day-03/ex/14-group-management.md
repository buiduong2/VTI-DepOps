## Block 14 — Thực hành các khối lệnh quản lý Groups


- Flow: 
    - 1. Xem user hiện tại đang thuộc những group nào
    - 2. Tọa 2 group mới
      - music
      - arts
    - 3. Kiểm tra :
      - 2 group đã tồn tại
      - -> hiện chưa có member
    - Đổi GID của arts thành 3000
    - 5. Đổi tên group msics -> artists
    - 6. Xóa group artists
    - 7. Thêm user tania vào group arts

- Mental model

```
group
→ có name
→ có GID
→ có members

group lifecycle:
create
→ verify
→ modify GID
→ rename
→ delete
→ add user membership
```

## 1. Verify your group membership on this computer.

```sh
duong@homelab:~$ groups
duong adm cdrom sudo audio dip plugdev lxd
duong@homelab:~$ id
uid=1000(duong) gid=1000(duong) groups=1000(duong),4(adm),24(cdrom),27(sudo),29(audio),30(dip),46(plugdev),101(lxd)

```

- Điểm cần nắm: 
  - `groups` -> cho danh sách group membership
  - `id` -> Cho chi tiết hơn, primary groupm supplementary groups, 

- Ngoài ra
  - user dương có `sudo` nên có thể có quyền sử dụng `sudo`

## 2. Add two groups named music and arts.

```sh
man groupadd

NAME
       groupadd - create a new group

```

```sh
duong@homelab:~$ sudo groupadd music
duong@homelab:~$ sudo groupadd arts
duong@homelab:~$ 

```

- Điểm cần nắm
  - `groupadd` -> thêm mới một group 

## 3. Verify that both groups were created and contain no members.

```sh
duong@homelab:~$ grep music /etc/group
music:x:1004:
duong@homelab:~$ grep arts /etc/group
arts:x:1005:

```

- Cấu trúc của `/etc/group`
  - `groupname: password field : GID : memberlist`
- Nên 
  - cả `mucsic` và `arts` đều đã tồn tại
  - `mucsic` có GID `1004`
  - `arts` có GID `1005`
  - field member cuối cùng đang rỗng tức hiện tại chưa có supplementary member nào được liệt kê

## 4. Modify the gid of arts to 3000.

```sh
man groupmod
NAME
       groupmod - modify a group definition on the system
OPTIONS
       -g, --gid GID
           The group ID of the given GROUP will be changed to GID.

           The value of GID must be a non-negative decimal integer. This value must be unique, unless the -o option is used.

           Users who use the group as primary group will be updated to keep the group as their primary group.

           Any files that have the old group ID and must continue to belong to GROUP, must have their group ID changed manually.

           No checks will be performed with regard to the GID_MIN, GID_MAX, SYS_GID_MIN, or SYS_GID_MAX from /etc/login.defs.

```

```sh
duong@homelab:~$ sudo groupmod -g 3000 arts
duong@homelab:~$ grep arts /etc/group
arts:x:3000:

```

- Điểm cần nắm
  - `groupmod` -> thay đổi các metadata của một group

## 5. Modify the name of the group music to artists.

```sh
man groupmod
NAME
       groupmod - modify a group definition on the system
OPTIONS
       -n, --new-name NEW_GROUP
           The name of the group will be changed from GROUP to NEW_GROUP name.

```

```sh
duong@homelab:~$ sudo groupmod -n artists music
duong@homelab:~$ grep music /etc/group
duong@homelab:~$ grep art* /etc/group
arts:x:3000:
artists:x:1004:

```

## 6. Delete the group artists.

```sh
NAME
       groupdel - delete a group

```

```sh
duong@homelab:~$ sudo groupdel artists 
duong@homelab:~$ grep artists /etc/group
duong@homelab:~$ grep '^art' /etc/group
arts:x:3000:

```

- `Kiến thức bên ngoài`
  - `FIle ko thực sự lưu tên user/group mà lưu số UID /GID`
  - Nếu có file đã mang GID đó thì sao
    - `-rw-r----- 1 duong 1004 report.txt`
    - Trong inode linux lưu địa khái: 
      - `owner UID = 1000`
      - `group GID = 1004`
    - Tên như `duong` `music` `artitst` chỉ là mapping để con người đọc
      - `/etc/passwd` -> UID -> username
      - `/etc/group` GID -> group name    

- `Trường hợp rename group`
  - Các file có GID `1004` không cần sửa gì cả. Chỉ cách hiển thị tên thay đổi
  - Quyền truy cập vẫn như cũ vì kernel xét `GID 1004` không xét chữ `music`
- `Đổi GID thì khác hoàn toàn`
  - `file cũ vẫn giữ GID cũ` - Linux ko tự quét toafn filesystem rồi sửa ownership cho ta
  - Kết quả: `-rw-r----- duong 1005 file.txt`
  - Và thành viên của `arts` `ko còn được hưởng group permission`
  - Nếu muốn file theo group mới admin phải đổi ownership group của file `chgrp` `chown`

- `GID cũ đã tồn tại trên file`
  - Tái sử dụng một GID có thể làm một group mới thừa hưởng quyền trên các file cũ mang GID có
  - Đây là ý nghĩa của Numeric Identitcal
  - CRUD trên `/etc/group` không đồng nghĩa CRUD trên các file mang GID đó

## 7. Add the user tania to the group arts, without removing her from other groups.

- Quan trọng        
  - KHÔNG ĐƯỢC LÀM MẤT CÁC GROUP KHÁC CỦA TANIA
```sh
duong@homelab:~$ id tania
uid=1002(tania) gid=1003(tania) groups=1003(tania)
man groupadd
       -a, --append GID
           If group members are specified with -U, append them to the existing member list, rather than replacing it.

       -U, --users
           A list of usernames to add as members of the group.

           The default behavior (if the -g, -N, and -U options are not specified) is defined by the USERGROUPS_ENAB variable in /etc/login.defs.

```

```sh
duong@homelab:~$ sudo groupmod -U tania -a arts
duong@homelab:~$ id tania
uid=1002(tania) gid=1003(tania) groups=1003(tania),3000(arts)
duong@homelab:~$ grep arts /etc/group
arts:x:3000:tania

```

- Điểm cần nắm: 
  - khi thêm user vào group
    - phía group -> thêm member tania `groupmod`
    - Phía user -> `usermod`
    - `-a` rất quan trọng vì nó mang ý nghĩa `append`

## Chốt

```
groups / id
→ xem membership

groupadd
→ tạo group

/etc/group
→ kiểm tra group + members

groupmod -g
→ đổi GID

groupmod -n
→ rename

groupdel
→ delete

groupmod ... -a
→ thêm membership
```

```
group name ≠ group identity thật
              ↓
             GID

file ownership lưu GID
không lưu tên group
```

```
rename group
→ GID giữ nguyên
→ ownership file không đổi

change/delete GID mapping
→ file cũ vẫn giữ numeric GID
→ có thể thành orphan ownership / đổi ý nghĩa nếu GID được tái sử dụng
```