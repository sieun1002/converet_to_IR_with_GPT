; ModuleID = 'merge_sort_print'
source_filename = "merge_sort_print.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0.ptr, align 4
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2.ptr, align 4
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4.ptr, align 4
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6.ptr, align 4
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8.ptr, align 4
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9.ptr, align 4
  store i64 10, i64* %n, align 8
  %arr.decay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  call void @merge_sort(i32* noundef %arr.decay, i64 noundef %n.val)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.cur, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %i.body = load i64, i64* %i, align 8
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.body
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %i.next = add i64 %i.body, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}