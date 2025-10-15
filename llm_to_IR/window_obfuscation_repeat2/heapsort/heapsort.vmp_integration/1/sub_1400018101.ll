; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i8*, align 8

declare void @sub_1400017C0()
declare i32 @loc_140001420(i8*)

define i32 @sub_140001810() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_140004390, align 8
  %base_as_i64ptr = bitcast i8* %baseptr to i64*
  %q0 = load i64, i64* %base_as_i64ptr, align 8
  %q0_trunc = trunc i64 %q0 to i32
  %is_m1 = icmp eq i32 %q0_trunc, -1
  br i1 %is_m1, label %scan_entry, label %test_count

scan_entry:                                         ; preds = %entry
  br label %scan_loop

scan_loop:                                          ; preds = %scan_entry, %scan_loop
  %idx = phi i64 [ 1, %scan_entry ], [ %idx_next, %scan_loop ]
  %off = shl i64 %idx, 3
  %elem_ptr_i8 = getelementptr i8, i8* %baseptr, i64 %off
  %elem_ptr = bitcast i8* %elem_ptr_i8 to i8**
  %elem = load i8*, i8** %elem_ptr, align 8
  %is_nonzero = icmp ne i8* %elem, null
  %idx_next = add i64 %idx, 1
  br i1 %is_nonzero, label %scan_loop, label %post_scan

post_scan:                                          ; preds = %scan_loop
  %idx_minus1 = add i64 %idx, -1
  %count_from_scan = trunc i64 %idx_minus1 to i32
  br label %join_count

test_count:                                         ; preds = %entry
  br label %join_count

join_count:                                         ; preds = %test_count, %post_scan
  %count = phi i32 [ %q0_trunc, %test_count ], [ %count_from_scan, %post_scan ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %after_calls, label %setup_loop

setup_loop:                                         ; preds = %join_count
  %count_ext = zext i32 %count to i64
  %count_bytes = shl i64 %count_ext, 3
  %cur_ptr_i8 = getelementptr i8, i8* %baseptr, i64 %count_bytes
  br label %loop

loop:                                               ; preds = %setup_loop, %loop
  %cur_ptr = phi i8* [ %cur_ptr_i8, %setup_loop ], [ %cur_ptr_dec, %loop ]
  %fpptr = bitcast i8* %cur_ptr to void ()**
  %fp = load void ()*, void ()** %fpptr, align 8
  call void %fp()
  %cur_ptr_dec = getelementptr i8, i8* %cur_ptr, i64 -8
  %cmp = icmp ne i8* %cur_ptr_dec, %baseptr
  br i1 %cmp, label %loop, label %after_calls

after_calls:                                        ; preds = %loop, %join_count
  %fnptr = bitcast void ()* @sub_1400017C0 to i8*
  %ret = tail call i32 @loc_140001420(i8* %fnptr)
  ret i32 %ret
}