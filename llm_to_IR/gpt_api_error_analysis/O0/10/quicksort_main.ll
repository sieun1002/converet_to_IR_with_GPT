; ModuleID = 'main_quicksort.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @quick_sort(i32* noundef, i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %cmp = icmp ule i64 10, 1
  br i1 %cmp, label %loop.init, label %qs.call

qs.call:
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @quick_sort(i32* noundef %arrdecay, i64 noundef 0, i64 noundef 9)
  br label %loop.init

loop.init:
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %loop.init ], [ %inc, %loop.body ]
  %cmp2 = icmp ult i64 %i, 10
  br i1 %cmp2, label %loop.body, label %after.loop

loop.body:
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %inc = add nuw nsw i64 %i, 1
  br label %loop.cond

after.loop:
  %newline = call i32 @putchar(i32 noundef 10)
  ret i32 0
}