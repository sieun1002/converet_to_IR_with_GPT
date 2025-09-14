; ModuleID = 'binary.ll'
source_filename = "binary"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@__stack_chk_guard = external global i64

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare void @__stack_chk_fail() noreturn

define i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %ssp = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %ssp, align 8

  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 4
  %idx1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %idx9, align 4

  store i64 10, i64* %len, align 8

  %lenv = load i64, i64* %len, align 8
  %le1 = icmp ule i64 %lenv, 1
  br i1 %le1, label %after_sort, label %do_sort

do_sort:
  %nminus1 = add i64 %lenv, -1
  call void @quick_sort(i32* noundef %base, i64 noundef 0, i64 noundef %nminus1)
  br label %after_sort

after_sort:
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %iv, %lenv2
  br i1 %cmp, label %body, label %post_loop

body:
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %iv
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %elem)
  %inc = add i64 %iv, 1
  store i64 %inc, i64* %i, align 8
  br label %loop

post_loop:
  %put = call i32 @putchar(i32 10)

  %guard_saved = load i64, i64* %ssp, align 8
  %guard_now = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard_saved, %guard_now
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}