; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004390 = external global i64*, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define i32 @sub_140001870() {
entry:
  %base_ptr = load i64*, i64** @off_140004390, align 8
  %hdr = load i64, i64* %base_ptr, align 8
  %hdr32 = trunc i64 %hdr to i32
  %is_m1 = icmp eq i32 %hdr32, -1
  br i1 %is_m1, label %scan_init, label %non_sentinel

non_sentinel:
  %count_is_zero = icmp eq i32 %hdr32, 0
  br i1 %count_is_zero, label %register, label %loop_prep_ns

loop_prep_ns:
  %idx0 = zext i32 %hdr32 to i64
  br label %call_loop

scan_init:
  br label %scan_loop

scan_loop:
  %i = phi i64 [ 1, %scan_init ], [ %i_next, %scan_loop ]
  %ptr = getelementptr inbounds i64, i64* %base_ptr, i64 %i
  %val = load i64, i64* %ptr, align 8
  %nz = icmp ne i64 %val, 0
  %i_next = add i64 %i, 1
  br i1 %nz, label %scan_loop, label %after_scan

after_scan:
  %k = add i64 %i, -1
  %k_is_zero = icmp eq i64 %k, 0
  br i1 %k_is_zero, label %register, label %call_loop_entry_from_scan

call_loop_entry_from_scan:
  br label %call_loop

call_loop:
  %idx = phi i64 [ %idx0, %loop_prep_ns ], [ %k, %call_loop_entry_from_scan ], [ %idx_dec, %call_loop_tail ]
  %elt_ptr = getelementptr inbounds i64, i64* %base_ptr, i64 %idx
  %f_addr = load i64, i64* %elt_ptr, align 8
  %f = inttoptr i64 %f_addr to void ()*
  call void %f()
  %is_one = icmp eq i64 %idx, 1
  br i1 %is_one, label %register, label %call_loop_tail

call_loop_tail:
  %idx_dec = add i64 %idx, -1
  br label %call_loop

register:
  %ret = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}