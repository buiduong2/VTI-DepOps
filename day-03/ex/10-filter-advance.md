## Tạo file mẫu

```sh
duong@homelab:~/VTI-ex$ cat > tennis <<'EOF'
Justine Henin, Belgium
Serena Williams, USA
Kim Clijsters, Belgium
Maria Sharapova, Russia
EOF
cat > dates.txt <<'EOF'
Event starts on     2026-09-21                    2026-09-22
Backup starts on    2026-10-01                    2026-10-02
EOF
duong@homelab:~/VTI-ex$ cat > cities <<'EOF'
Hanoi
Tokyo
Berlin
Paris
Amsterdam
Seoul
EOF

```

## 1. Do a case insensitive grep for ‘Bel’ in the tennis file.

```sh
duong@homelab:~/VTI-ex$ grep -i Bel tennis
Justine Henin, Belgium
Kim Clijsters, Belgium

```

- grep -i = tìm không phân biệt hoa thường.

## 2. Filter the lines containing ‘Henin’ and the line before and after from the tennis file.

- Mục tiêu: 
  - tìm dòng có `Henin`
  - Đồng thời lấy thêm 1 dòng trước
  - Và 1 dòng sau

- Gợi ý: `grep` có options hỗ trợ

```sh 
man grep
   Context Line Control
       -A NUM, --after-context=NUM
              Print NUM lines of trailing context after matching lines.  Places a line containing a group separator (--) between contiguous groups of matches.  With the
              -o or --only-matching option, this has no effect and a warning is given.

       -B NUM, --before-context=NUM
              Print NUM lines of leading context before matching lines.  Places a line containing a group separator (--) between contiguous groups of matches.  With the
              -o or --only-matching option, this has no effect and a warning is given.
       -C NUM, -NUM, --context=NUM
              Print NUM lines of output context.  Places a line containing a group separator (--) between contiguous groups of matches.  With the -o or  --only-matching
              option, this has no effect and a warning is given.



duong@homelab:~/VTI-ex$ grep -i -A 1 -B 1 Henin tennis 
Justine Henin, Belgium
Serena Williams, USA

duong@homelab:~/VTI-ex$ grep -C 1 Henin tennis
Justine Henin, Belgium
Serena Williams, USA


```

- Ở sample hiện tại `Hein` nằm ở dòng đầu tiên nên `không có dòng trước để in`
  - `-A 1` lấy thêm một dòng `after`
  - `-B 1` Lấy thêm 1 dòng `before`
  - `-C 1`  lấy thêm một dòng cả trước lẫn sau

## 3. Filter the surname column from the tennis file.

```sh
duong@homelab:~/VTI-ex$ cut -d' ' -f2 tennis 
Henin,
Williams,
Clijsters,
Sharapova,
duong@homelab:~/VTI-ex$ cut -d' ' -f2 tennis | cut -d, -f1 
Henin
Williams
Clijsters
Sharapova
```

- Có thể dùng cut nhiều để split nhiều lần

## 4. Again filter the surname from the tennis file, but remove the comma’s.

```sh
duong@homelab:~/VTI-ex$ cut -d' ' -f2 tennis | tr -d ','
Henin
Williams
Clijsters
Sharapova

```

- cut  -> lấy đúng field surname
- tr   -> xóa ký tự không mong muốn

## 5. Filter the dates from the dates.txt file and put each date on a separate line.

- Khác với các câu trước ở chỗ `cut` ko cắt theo delimiter nữa, mà cắt theo `vị trí byte cố định`

- Theo mẫu dữ liệu hiện tại

```
Meeting starts on 2026-09-21 and ends on 2026-09-22
Backup runs at    2026-10-01 and finishes 2026-10-02
```

- Mục tiêu: 
```
2026-09-21
2026-09-22
2026-10-01
2026-10-02
```

- Gợi ý: 
  - Xem số thứ tự , vị trí ký tự
  - byte trong từng dòng,
  - Xác định range chứa ngày

- Thông thường
  - Các dữ liệu ASCII/English thường thì `1 ký tự = 1 byte`
  - nên chúng ta hay hiểu nhầm là cắt theo index
  - Chỉ có các dữ liệu theo dạng format fixed-width (column size) thì mới cắt hợp kiểu như vậy
  - Còn log thực tế theo dạng Key=Value thì byte position có thể thay đổi

```sh
duong@homelab:~/VTI-ex$ cut -b 21-30,50-60 dates.txt | tr ' ' '\n'
2026-09-21
2026-09-22
2026-10-01
2026-10-02

```

## 6. Count the number of files and directories in /etc

- Đếm số entry mà `ls /etc` trả ra

```sh
duong@homelab:~/VTI-ex$ ls -1 /etc | wc -l
211

```

- `ls -1 /etc`  mỗi entry một dòng

- `wc -l `= đếm số dòng

## 7. the cities file and put the result in sorted_cities.txt

```sh
duong@homelab:~/VTI-ex$ cat cities 
Hanoi
Tokyo
Berlin
Paris
Amsterdam
Seoul
duong@homelab:~/VTI-ex$ man sort
duong@homelab:~/VTI-ex$ sort -o sorted_cities.txt cities 
duong@homelab:~/VTI-ex$ cat sorted_cities.txt 
Amsterdam
Berlin
Hanoi
Paris
Seoul
Tokyo

sort cities > sorted_cities.txt # cùng kết quả
```

- `sort` mặc định ghi kết quả ra stdout
- `-o FILE` cho phép ghi trực tiếp vào file
- Cách khác `sort cities > sorted_cities.txt`


## 8. Knowing that /usr/share/dict/words is a dictionary, write a simple spell checker on the command line.

- Chỉ giữ từ không có trong dictionary
- Viết một pipeline command dài ngay trên shell

```sh
duong@homelab:~/VTI-ex$ echo "The zun is shining today!" | tr ' ' '\n' | tr 'A-Z' 'a-z' | tr -cd '[:alpha:]\n' | sort | uniq | comm -23 - dict.txt 
zun

```

- comm cần cả hai input đã sort.