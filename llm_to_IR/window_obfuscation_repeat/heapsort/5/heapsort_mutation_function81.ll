; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = global [2 x i64] [i64 -1, i64 0], align 8

declare i32 @j__crt_atexit(void ()*)

define i32 @sub_140001870() {
entry:
  %basep = getelementptr inbounds [2 x i64], [2 x i64]* @off_140004390, i64 0, i64 0
  %first64 = load i64, i64* %basep, align 8
  %first32 = trunc i64 %first64 to i32
  %isneg1 = icmp eq i32 %first32, -1
  br i1 %isneg1, label %scan_init, label %have_count_from_first

have_count_from_first:
  br label %after_count

scan_init:
  br label %scan_loop

scan_loop:
  %a = phi i64 [ 0, %scan_init ], [ %i, %scan_loop_body_out ]
  %prev = phi i64 [ 0, %scan_init ], [ %a, %scan_loop_body_out ]
  %i = add i64 %a, 1
  %elem_ptr = getelementptr inbounds i64, i64* %basep, i64 %i
  %elem_val = load i64, i64* %elem_ptr, align 8
  %nonzero = icmp ne i64 %elem_val, 0
  br i1 %nonzero, label %scan_loop_body_out, label %scan_end

scan_loop_body_out:
  br label %scan_loop

scan_end:
  %prev32 = trunc i64 %prev to i32
  br label %after_count

after_count:
  %count = phi i32 [ %first32, %have_count_from_first ], [ %prev32, %scan_end ]
  %is_zero = icmp eq i32 %count, 0
  br i1 %is_zero, label %register, label %call_loop_init

call_loop_init:
  %count64 = sext i32 %count to i64
  br label %call_loop

call_loop:
  %i2 = phi i64 [ %count64, %call_loop_init ], [ %dec, %call_loop ]
  %idxptr = getelementptr inbounds i64, i64* %basep, i64 %i2
  %fptr_i64 = load i64, i64* %idxptr, align 8
  %fptr = inttoptr i64 %fptr_i64 to void ()*
  call void %fptr()
  %dec = add i64 %i2, -1
  %cond = icmp ne i64 %dec, 0
  br i1 %cond, label %call_loop, label %register

register:
  %ret = call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}

define void @sub_140001820() {
entry:
  ret void
}