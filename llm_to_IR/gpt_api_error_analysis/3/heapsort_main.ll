; ModuleID = 'heapsort_main'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [19 x i8] c"Before Heap Sort: \00", align 1
@.str.after  = private unnamed_addr constant [18 x i8] c"After Heap Sort: \00", align 1
@.str.d      = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @heap_sort(i32*, i64)

define i32 @main() #0 {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i.ptr = alloca i64, align 8
  %j.ptr = alloca i64, align 8

  %before.ptr = getelementptr inbounds [19 x i8], [19 x i8]* @.str.before, i64 0, i64 0
  %after.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.after, i64 0, i64 0
  %fmtd.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0

  %elt0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %elt0.ptr, align 4
  %elt1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %elt1.ptr, align 4
  %elt2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %elt2.ptr, align 4
  %elt3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %elt3.ptr, align 4
  %elt4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %elt4.ptr, align 4
  %elt5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %elt5.ptr, align 4
  %elt6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %elt6.ptr, align 4
  %elt7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7.ptr, align 4
  %elt8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %elt8.ptr, align 4

  store i64 9, i64* %len, align 8

  %call.printf.before = call i32 (i8*, ...) @printf(i8* %before.ptr)

  store i64 0, i64* %i.ptr, align 8
  br label %loop.print.before

loop.print.before:                              ; preds = %loop.body.before, %entry
  %i.val = load i64, i64* %i.ptr, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp.i = icmp ult i64 %i.val, %len.val
  br i1 %cmp.i, label %loop.body.before, label %loop.end.before

loop.body.before:                               ; preds = %loop.print.before
  %elt.ptr.cur = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elt.val = load i32, i32* %elt.ptr.cur, align 4
  %call.printf.num.before = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elt.val)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i.ptr, align 8
  br label %loop.print.before

loop.end.before:                                ; preds = %loop.print.before
  %call.putchar.nl1 = call i32 @putchar(i32 10)

  %len.val.hs = load i64, i64* %len, align 8
  %arr.base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base.ptr, i64 %len.val.hs)

  %call.printf.after = call i32 (i8*, ...) @printf(i8* %after.ptr)

  store i64 0, i64* %j.ptr, align 8
  br label %loop.print.after

loop.print.after:                               ; preds = %loop.body.after, %loop.end.before
  %j.val = load i64, i64* %j.ptr, align 8
  %len.val2 = load i64, i64* %len, align 8
  %cmp.j = icmp ult i64 %j.val, %len.val2
  br i1 %cmp.j, label %loop.body.after, label %loop.end.after

loop.body.after:                                ; preds = %loop.print.after
  %elt.ptr.cur2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elt.val2 = load i32, i32* %elt.ptr.cur2, align 4
  %call.printf.num.after = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elt.val2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j.ptr, align 8
  br label %loop.print.after

loop.end.after:                                 ; preds = %loop.print.after
  %call.putchar.nl2 = call i32 @putchar(i32 10)
  ret i32 0
}

attributes #0 = { "no-frame-pointer-elim"="false" }