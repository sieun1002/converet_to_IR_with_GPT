; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140004390 = external global i64*, align 8

declare i32 @j__crt_atexit(void ()*)
declare void @sub_140001820()

define dso_local i32 @sub_140001870() local_unnamed_addr {
entry:
  %baseptr = load i64*, i64** @off_140004390, align 8
  %firstq = load i64, i64* %baseptr, align 8
  %first32 = trunc i64 %firstq to i32
  %is_m1 = icmp eq i32 %first32, -1
  br i1 %is_m1, label %sentinel_entry, label %not_m1

sentinel_entry:
  br label %sentinel_loop

sentinel_loop:
  %i = phi i32 [ 0, %sentinel_entry ], [ %i_plus1, %sentinel_loop ]
  %i_plus1 = add i32 %i, 1
  %i_plus1_z = zext i32 %i_plus1 to i64
  %p = getelementptr inbounds i64, i64* %baseptr, i64 %i_plus1_z
  %val = load i64, i64* %p, align 8
  %not_zero = icmp ne i64 %val, 0
  br i1 %not_zero, label %sentinel_loop, label %have_count

have_count:
  br label %count_dispatch

not_m1:
  br label %count_dispatch

count_dispatch:
  %count = phi i32 [ %first32, %not_m1 ], [ %i, %have_count ]
  %is_zero_count = icmp eq i32 %count, 0
  br i1 %is_zero_count, label %register_atexit, label %loop_setup

loop_setup:
  %count64 = zext i32 %count to i64
  %rbx_init = getelementptr inbounds i64, i64* %baseptr, i64 %count64
  br label %loop_body

loop_body:
  %rbx = phi i64* [ %rbx_init, %loop_setup ], [ %rbx_next, %loop_body ]
  %fn64 = load i64, i64* %rbx, align 8
  %fnptr = inttoptr i64 %fn64 to void ()*
  call void %fnptr()
  %rbx_next = getelementptr inbounds i64, i64* %rbx, i64 -1
  %done = icmp eq i64* %rbx_next, %baseptr
  br i1 %done, label %register_atexit, label %loop_body

register_atexit:
  %ret = tail call i32 @j__crt_atexit(void ()* @sub_140001820)
  ret i32 %ret
}