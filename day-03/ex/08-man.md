## 1. Open the man page for cp and search for the option to recursively copy directories


```sh
man cp
/recursively <enter>
n
-R, -r, --recursive
    copy directories recursively
```

- Trong `man`  ta có thể tìm chuỗi bằng 
  - `/pattern`
  - Sau đó có thể dùng 
    - `n` tới kết quả kế tiếp
    - `N` quay lại kết quả trước

## 2. Open the man page for the passwd file.

- `passwd` có thể vừa là `command` vừa là `file/document entry` khác section

```sh
man passwd

PASSWD(1)
NAME
       passwd - change user password
SEE ALSO
       chpasswd(8), passwd(5), shadow(5), usermod(8).


man 5 passwd
PASSWD(5) File Formats and Configuration 

NAME
       passwd - the password file

DESCRIPTION
       /etc/passwd contains one line for each user account, with seven fields delimited by colons (“:”). These fields are:

       •   login name

       •   optional encrypted password

       •   numerical user ID

       •   numerical group ID

       •   user name or comment field

       •   user home directory

       •   optional user command interpreter
```

- Gía trị cốt lỗi: 
  - `passwd` có nhiều `man page khác nhau` tùy secion
  - `man`  không chỉ tra theo tên, mà còn theo `section`
  - `mân passwd` -> mở passwd(1)
  - `man 5 passwd` -> mở passwd(5)

## 3. Open the man page of bash and search for noclobber.

- Mục tiêu: 
  - mở man page của `bash`
  - tìm từ noclobber
  - Xem nó liên quan đến hành vi nào của shell



```sh
duong@homelab:~$ man bash
       If the redirection operator is >, and the noclobber option to the set builtin has been enabled, the redirection will fail if the file whose name results from the
       expansion of word exists and is a regular file.  If the redirection operator is >|, or the redirection operator is > and the noclobber option to the set  builtin
       command is not enabled, the redirection is attempted even if the file named by word exists.
```

- Bình thường `>` có thể ghi đề file đã tồn tại
- nếu bật `noclobber` thì `>` sẽ `không ghi đè regular file đã tồn tại`
- Nếu thật sự muốn ép ghi đè dù `noclobber` đang bật, dùng `>|`

```sh
echo "new" >| file.txt
```

- Giá trị cốt lõi: 
  - `noclobber` là cơ chế bảo vệ vieeicj vô tình overwrite file bằng `>`

## 4. List all the man pages that have something to do with passwords.

- Mục tiêu: 
  - Không phải mở một man page cụ thể nữa
  - Tìm các man page liên quan đến một chủ đề

```sh
man man
SEE ALSO
       apropos(1), groff(1), less(1), manpath(1), nroff(1), troff(1), whatis(1), zsoelim(1), manpath(5), man(7), catman(8), mandb(8)

       Documentation for some packages may be available in other formats, such as info(1) or HTML.

man apropos
NAME
       apropos - search the manual page names and descriptions


duong@homelab:~$ apropos password | head -n 3
chage (1)            - change user password expiry information
chgpasswd (8)        - update group passwords in batch mode
chpasswd (8)         - update passwords in batch mode

```

- Giá trị cốt lõi cần nắm: 
  - `SEE ALSO`: gợi ý vài tài liệu liên quan đến từ trang hiện tại
  - `apropos <keyword>` tìm rộng theo `tên + mô tả man page`
  - `apropos password` không tìm trong toàn bộ nội dung chi tiết của mọi man page; nó dựa vào database tên và mô tả ngắn

## 5. List the location of the cat command and its manual page.

- Tìm ra vị trí của command `cat` và vị trí của man page tương ứng

```sh
duong@homelab:~$ whereis cat
cat: /usr/bin/cat /usr/share/man/man1/cat.1.gz
```

- Giá trị cốt lõi: 
  - `whereis` dùng để tìm vị tgris của binary , source và man page nếu có
  - `which ` chủ yếu tìm executable theo PATH
  - `whatis` mô tả ngắn
  - `manpath` các thư mục chưa man pages

## 6. Display the short description of the grep command


```sh
duong@homelab:~$ whatis grep
grep (1)             - print lines that match patterns

```

- Giá trị cốt lõi: 
    - `Whatis` trả về mô tả ngắn của một man entry , thường lấy từ database của man pages


