; ModuleID = 'main.ll'
source_filename = "main"
target triple = "x86_64-unknown-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@format = private unnamed_addr constant [1 x i8] c"\00", align 1
@byte_2011 = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.int = private unnamed_addr constant [4 x i8] c"%d \00", align 1

@__stack_chk_guard = external global i64

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)
declare void @__stack_chk_fail()

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %canary = alloca i64, align 8

  %g = load i64, i64* @__stack_chk_guard
  store i64 %g, i64* %canary, align 8

  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4

  store i64 9, i64* %len, align 8

  %fmt0 = getelementptr inbounds [1 x i8], [1 x i8]* @format, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt0)

  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %n = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %n
  br i1 %cond, label %body, label %after1

body:
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %iv
  %val = load i32, i32* %elem.ptr, align 4
  %fmtint = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtint, i32 %val)
  %next = add i64 %iv, 1
  store i64 %next, i64* %i, align 8
  br label %loop

after1:
  call i32 @putchar(i32 10)

  %base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %lenv = load i64, i64* %len, align 8
  call void @heap_sort(i32* %base, i64 %lenv)

  %fmt1 = getelementptr inbounds [1 x i8], [1 x i8]* @byte_2011, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt1)

  store i64 0, i64* %j, align 8
  br label %loop2

loop2:
  %jv = load i64, i64* %j, align 8
  %n2 = load i64, i64* %len, align 8
  %cond2 = icmp ult i64 %jv, %n2
  br i1 %cond2, label %body2, label %after2

body2:
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %jv
  %val2 = load i32, i32* %elem.ptr2, align 4
  %fmtint2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.int, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtint2, i32 %val2)
  %next2 = add i64 %jv, 1
  store i64 %next2, i64* %j, align 8
  br label %loop2

after2:
  call i32 @putchar(i32 10)

  %saved = load i64, i64* %canary, align 8
  %now = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %now
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  br label %ret

ret:
  ret i32 0
}