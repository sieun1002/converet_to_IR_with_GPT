target triple = "x86_64-pc-windows-msvc"

@off_1400043B0 = external global i64, align 8

declare void @sub_140001450()
declare void @sub_140001420(void ()* noundef)

define void @sub_1400014A0() {
entry:
  %hdr64 = load i64, i64* @off_1400043B0, align 8
  %hdr32 = trunc i64 %hdr64 to i32
  %is_m1 = icmp eq i32 %hdr32, -1
  br i1 %is_m1, label %scan_loop, label %after_header

scan_loop:
  br label %scan_check

scan_check:
  %count_phi = phi i64 [ 0, %scan_loop ], [ %count_next, %scan_cont ]
  %idx = add i64 %count_phi, 1
  %elem_ptr = getelementptr inbounds i64, i64* @off_1400043B0, i64 %idx
  %elem = load i64, i64* %elem_ptr, align 8
  %nonzero = icmp ne i64 %elem, 0
  br i1 %nonzero, label %scan_cont, label %scan_exit

scan_cont:
  %count_next = add i64 %count_phi, 1
  br label %scan_check

scan_exit:
  %count32_from_scan = trunc i64 %count_phi to i32
  br label %after_header

after_header:
  %count32 = phi i32 [ %hdr32, %entry ], [ %count32_from_scan, %scan_exit ]
  %is_zero = icmp eq i32 %count32, 0
  br i1 %is_zero, label %tail, label %loop_setup

loop_setup:
  %count64 = zext i32 %count32 to i64
  %p_start = getelementptr inbounds i64, i64* @off_1400043B0, i64 %count64
  br label %loop

loop:
  %p = phi i64* [ %p_start, %loop_setup ], [ %p_next, %loop_cont ]
  %fp_i64 = load i64, i64* %p, align 8
  %fp = inttoptr i64 %fp_i64 to void ()*
  call void %fp()
  %p_next = getelementptr inbounds i64, i64* %p, i64 -1
  %done = icmp eq i64* %p_next, @off_1400043B0
  br i1 %done, label %tail, label %loop_cont

loop_cont:
  br label %loop

tail:
  call void @sub_140001420(void ()* @sub_140001450)
  ret void
}