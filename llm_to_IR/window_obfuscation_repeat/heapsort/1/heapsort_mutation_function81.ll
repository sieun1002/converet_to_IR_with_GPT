; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@table_init = dso_local global [2 x i64] [ i64 -1, i64 0 ], align 8
@off_140004390 = dso_local global i64* getelementptr ([2 x i64], [2 x i64]* @table_init, i64 0, i64 0), align 8

declare dso_local i32 @j__crt_atexit(void ()*)

define dso_local void @sub_140001820() {
entry:
  ret void
}

define dso_local i32 @sub_140001870() {
entry:
  %base_ptr = load i64*, i64** @off_140004390, align 8
  %first = load i64, i64* %base_ptr, align 8
  %first32 = trunc i64 %first to i32
  %isSentinel = icmp eq i32 %first32, -1
  br i1 %isSentinel, label %scan_loop, label %use_count

use_count:
  %count_is_zero = icmp eq i32 %first32, 0
  br i1 %count_is_zero, label %register, label %call_from_count

call_from_count:
  %count64_from_count = zext i32 %first32 to i64
  br label %call_loop

scan_loop:
  %curr = phi i64 [ 0, %entry ], [ %next, %scan_loop ]
  %next = add i64 %curr, 1
  %elem_ptr = getelementptr i64, i64* %base_ptr, i64 %next
  %elem = load i64, i64* %elem_ptr, align 8
  %nonzero = icmp ne i64 %elem, 0
  br i1 %nonzero, label %scan_loop, label %after_scan

after_scan:
  %is_zero2 = icmp eq i64 %curr, 0
  br i1 %is_zero2, label %register, label %call_from_scan

call_from_scan:
  br label %call_loop

call_loop:
  %idx = phi i64 [ %count64_from_count, %call_from_count ], [ %curr, %call_from_scan ], [ %idx_dec, %call_loop ]
  %ptr = getelementptr i64, i64* %base_ptr, i64 %idx
  %f64 = load i64, i64* %ptr, align 8
  %fp = inttoptr i64 %f64 to void ()*
  call void %fp()
  %idx_dec = add i64 %idx, -1
  %cond = icmp ne i64 %idx_dec, 0
  br i1 %cond, label %call_loop, label %register

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}