; ModuleID = 'main_with_heap_sort_print'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [9 x i8] c"Before: \00", align 1
@.str.after  = private unnamed_addr constant [8 x i8] c"After: \00", align 1
@.str.fmt    = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %i0 = alloca i64, align 8
  %i1 = alloca i64, align 8

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

  %before.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.before, i64 0, i64 0
  %call.before = call i32 (i8*, ...) @printf(i8* %before.ptr)

  store i64 0, i64* %i0, align 8
  br label %loop.print.before

loop.print.before:
  %idx0 = load i64, i64* %i0, align 8
  %cmp0 = icmp ult i64 %idx0, 9
  br i1 %cmp0, label %loop.body.before, label %loop.end.before

loop.body.before:
  %elem.ptr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx0
  %val0 = load i32, i32* %elem.ptr0, align 4
  %fmt.ptr0 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt.ptr0, i32 %val0)
  %inc0 = add nuw nsw i64 %idx0, 1
  store i64 %inc0, i64* %i0, align 8
  br label %loop.print.before

loop.end.before:
  %nl0 = call i32 @putchar(i32 10)

  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base, i64 9)

  %after.ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.str.after, i64 0, i64 0
  %call.after = call i32 (i8*, ...) @printf(i8* %after.ptr)

  store i64 0, i64* %i1, align 8
  br label %loop.print.after

loop.print.after:
  %idx1 = load i64, i64* %i1, align 8
  %cmp1 = icmp ult i64 %idx1, 9
  br i1 %cmp1, label %loop.body.after, label %loop.end.after

loop.body.after:
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %idx1
  %val1 = load i32, i32* %elem.ptr1, align 4
  %fmt.ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.fmt, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr1, i32 %val1)
  %inc1 = add nuw nsw i64 %idx1, 1
  store i64 %inc1, i64* %i1, align 8
  br label %loop.print.after

loop.end.after:
  %nl1 = call i32 @putchar(i32 10)
  ret i32 0
}