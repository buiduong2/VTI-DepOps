## Cài các thứ cần thiết

- Cài đặt ameraican english wordlist

```sh 
sudo apt install wamerican
duong@homelab:~/VTI-ex$ ls -l /usr/share/dict/words
lrwxrwxrwx 1 root root 16 Jan 20  2022 /usr/share/dict/words -> american-english

duong@homelab:~/VTI-ex$ sudo apt install bzip2

duong@homelab:~/VTI-ex$ which bzip2
/usr/bin/bzip2

```

## 1. “Copy the /usr/share/dict/words file to your home directory.”


```sh
cp -L  /usr/share/dict/words ~/words
duong@homelab:~$ tail ~/words
zoos
zorch
zucchini
zucchini's
zucchinis
zwieback
zwieback's
zygote
zygote's
zygotes


```

- Giá trị cốt lõi: 
  - `cp`  bình thường với symlink có thể cần để ý xem đang copy link hay target
  - `cp -L` follow symlink copy target


### Copy nội dung của `symlink`

- Thông thường nếu sử dụng cp trên một symlink thì nó sẽ chỉ copy mỗi con trỏ. Và ta cũng ko truy cập được symlink đó

- Ta cần thêm một option của cp 
```sh 
man cp
-L, --dereference
              always follow symbolic links in SOURCE
```

## 2. Verify the size of the ~/words file

```sh
duong@homelab:~$ ls -lh ~/words 
-rw-r--r-- 1 duong duong 962K Sep 21 09:55 /home/duong/words

duong@homelab:~$ du -h ~/words
964K	/home/duong/words

```

- Giá trị cốt lõi: 
  - `ls -lh` hiên thị `logical file size` - số byte dữ liệu của file
  - `du -h` hiển thị `disk usage` - dung lượng thực tế file chiếm trên filesystem theo block
  - Vì vậy file có thể có size khaongr `962K` nhưng chiếm `964K` trên disk

## 3. Use gzip to compress the ~/words file

```sh



duong@homelab:~$ cp -L /usr/share/dict/words ~/words
duong@homelab:~$ ls -lh ~/words
-rw-r--r-- 1 duong duong 962K Sep 21 10:03 /home/duong/words
duong@homelab:~$ gzip ~/words
duong@homelab:~$ ls -lh ~/words
ls: cannot access '/home/duong/words': No such file or directory
duong@homelab:~$ ls -lh ~/words.gz
-rw-r--r-- 1 duong duong 258K Sep 21 10:03 /home/duong/words.gz

```

- Giá trị cốt lõi cần nắm: 
  - `gzip` ko hiểu tham số thứ 2 tên là output. 
  - file gốc `~/words` sẽ bị `xóa/thay thế` bởi file nén
  - File kết quả sẽ tự đặt thêm hậu tố `.gz`
  - Với file dictionary , size giảm từ khoảng `962K` xuống `258K` tức compresssion có hiệu quả khá rõ
  - `gzip` khác với `tar` : 
    - `gzip` làm việc trên `một file độc lập`
    - Nếu muốn đóng gói thì phải dùng `tar`
    - `tar` nén là nén kết quả đóng gói
    - còn gzip là nén file nguồn

## 4. Again verify the size of the file.

- Đã thực hiện ở bài trên

## 5. Is the word evening present in this compressed file

- Mục tiêu: kiểm tra xem từ `evening` có tồn tại `bên trong file gzip ` hay không

```sh
duong@homelab:~$ head -c 50 words.gz 
��jwordsl�۲�8�.
��E�Nۙ�ʃ]鬪=�$aH�(B�
duong@homelab:~$ grep evening words.gz
duong@homelab:~$ echo $?
1

duong@homelab:~$ zgrep evening words.gz
evening
evening's
evenings

```

- Bản chất: 
  - `words.gz` là `dữ liệu nén dạng binary` nên đọc bằng `head` sẽ ra kí tự rác, và `grep` thường ko thể xử lý trực tiếp nội dung nén như text thường
  - `.gz` không phải text thuần -> `head`, `grep` trực tiếp sẽ ko cho ra kết quả như file text'
  - `zgrep` = grep trực tiếp nội dung `gzip` mà ko cần giải nén ra file trước

## 6.  Display the last ten lines of ~/words.gz.

- Mục tiêu là `xem 10 dòng cuối của nội dung bên trong file gzip` mà không cần giải nén file ra trước.

```sh
duong@homelab:~$ zcat words.gz | tail -n 10
zoos
zorch
zucchini
zucchini's
zucchinis
zwieback
zwieback's
zygote
zygote's
zygotes

```

- Giá trị cốt lõi
  - `zcat`Command dùng để đọc nội dung của `.gz` ra stdout là: 
    - Không tạo lại file `words` trên disk
    - mà chỉ stream nội dung đã giải nén ra stdout


## 7. Uncompress the ~/words.gz file.
```sh
duong@homelab:~$ gunzip ~/words.gz 
duong@homelab:~$ ls -lh words*
-rw-r--r-- 1 duong duong 962K Sep 21 10:03 words

```

- Giá trị cốt lõi: 
  - `gzip`: words -> words.gz
  - `gunzip`: words.gz -> words
  - Mặc định `gunzup` cũng thay thế file nén bằng file đã giải nén


## 8. Repeat all of the above but use bzip2 instead of gzip.

- Lặp lại chuỗi thao tác vừa làm với `gzip` nhưng đổi sang bộ công cụ `bzip2`

```sh
duong@homelab:~$ ls -lh words*
-rw-r--r-- 1 duong duong 962K Sep 21 10:03 words
duong@homelab:~$ bzip2 words 
duong@homelab:~$ ls -lh words*
-rw-r--r-- 1 duong duong 344K Sep 21 10:03 words.bz2
duong@homelab:~$ head -c 10  words.bz2 
BZh91AY&SYduong@homelab:~$ grep evening words.bz2 
duong@homelab:~$ zgrep evening words.bz2 
duong@homelab:~$ zcat words.bz2 | tail -n 10

gzip: words.bz2: not in gzip format
duong@homelab:~$ bzgrep evening words.bz2 
evening
evening's
evenings
duong@homelab:~$ bzcat words.bz2 | tail -n 10
zoos
zorch
zucchini
zucchini's
zucchinis
zwieback
zwieback's
zygote
zygote's
zygotes

duong@homelab:~$ bunzip2 words.bz2 
duong@homelab:~$ ls -lh words*
-rw-r--r-- 1 duong duong 962K Sep 21 10:03 words

```

- Giá trị cốt lõi cần nắm: 
  - `bzip2` cũng mặc định thay thế file gốc
  - `grep` thường không đọc được nội dung nén như text
  - `zgrep / zcat` không dùng cho `.bz2`
  - Và `gzip` nén nhỏ hơn trong case này so với `bzip2` 
    - Hiệu quả nén phụ thuộc voaf dữ liệu và thuật toán
    - Ko liên quan đến `gzip` hay `bzip2`