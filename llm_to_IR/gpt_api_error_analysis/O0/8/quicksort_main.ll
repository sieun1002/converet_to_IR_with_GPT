; ModuleID = 'reconstructed'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* nocapture, i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %arr.ptr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.ptr0, align 4
  %arr.ptr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.ptr1, align 4
  %arr.ptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.ptr2, align 4
  %arr.ptr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.ptr3, align 4
  %arr.ptr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.ptr4, align 4
  %arr.ptr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.ptr5, align 4
  %arr.ptr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.ptr6, align 4
  %arr.ptr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.ptr7, align 4
  %arr.ptr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.ptr8, align 4
  %arr.ptr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.ptr9, align 4
  store i64 10, i64* %len, align 8
  %len.load0 = load i64, i64* %len, align 8
  %cmp.len = icmp ugt i64 %len.load0, 1
  br i1 %cmp.len, label %do_sort, label %after_sort

do_sort:
  %len.load1 = load i64, i64* %len, align 8
  %high = add i64 %len.load1, -1
  %arr.decay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* %arr.decay, i64 0, i64 %high)
  br label %after_sort

after_sort:
  store i64 0, i64* %i.addr, align 8
  br label %loop.cond

loop.cond:
  %i.load = load i64, i64* %i.addr, align 8
  %len.load2 = load i64, i64* %len, align 8
  %cmp.it = icmp ult i64 %i.load, %len.load2
  br i1 %cmp.it, label %loop.body, label %loop.end

loop.body:
  %elt.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.load
  %elt.val = load i32, i32* %elt.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elt.val)
  %i.inc = add i64 %i.load, 1
  store i64 %i.inc, i64* %i.addr, align 8
  br label %loop.cond

loop.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}