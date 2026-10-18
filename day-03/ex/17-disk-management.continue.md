# Block 17 – Hardware / Disk I/O
Status: DEFERRED

## Lý do tạm bỏ qua

Block 17 không chỉ là "chạy vài command hardware", mà thực tế tập trung nhiều vào:

- disk I/O monitoring:
  - `iostat`
  - `iotop`
  - `vmstat`
- process đang giữ file/filesystem:
  - `fuser`
  - `lsof`
- inode:
  - `df -i`
- mount/filesystem interaction
- hardware inspection nâng cao:
  - `hddtemp`
  - `hwinfo`
  - `smartctl`

Assignment hiện tại chủ yếu yêu cầu chạy tool và quan sát output, nhưng chưa cung cấp đủ nền để hiểu:

- I/O path từ process -> kernel -> filesystem -> block device -> disk
- metric nào trong `iostat`/`vmstat` thực sự quan trọng
- khi nào nghi disk I/O là bottleneck
- open file / file descriptor / filesystem busy là gì
- inode là gì và tại sao có thể hết inode dù disk vẫn còn dung lượng
- khi nào dùng `fuser`, `lsof`, `smartctl`

## Kiến thức cần bổ sung trước khi quay lại

Cần học chắc hơn các phần sau:

1. Disk I/O và storage performance cơ bản
2. Process -> read/write -> filesystem -> block device -> disk
3. Open file / file descriptor
4. Busy filesystem và mount/unmount
5. Inode
6. Cách troubleshoot theo hướng:
   symptom -> hypothesis -> tool -> metric -> conclusion


## Khi nào quay lại

Quay lại Block 17 khi có thể trả lời được ít nhất:

- `iostat` dùng để trả lời câu hỏi gì?
- `iotop` khác `iostat` ở đâu?
- `vmstat` cho góc nhìn gì?
- inode là gì?
- tại sao filesystem có thể "full" dù vẫn còn disk space?
- tại sao process đang mở file có thể ảnh hưởng mount/unmount?
- khi nào dùng `fuser` và khi nào dùng `lsof`?

## Trạng thái

- Block 16 – Disk: DONE
- Block 17 – Hardware / Disk I/O: DEFERRED
- Next: Block 19 – Network