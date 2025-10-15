; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define internal i32 @partition(i32* %arr, i32 %low, i32 %high) local_unnamed_addr {
entry:
  %low.ext = sext i32 %low to i64
  %high.ext = sext i32 %high to i64
  %high.ptr = getelementptr inbounds i32, i32* %arr, i64 %high.ext
  %pivot = load i32, i32* %high.ptr, align 4
  %i.init = add i32 %low, -1
  br label %loop

loop:                                             ; preds = %loop.inc, %entry
  %j = phi i32 [ %low, %entry ], [ %j.next, %loop.inc ]
  %i.cur = phi i32 [ %i.init, %entry ], [ %i.next, %loop.inc ]
  %cond = icmp slt i32 %j, %high
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %aj = load i32, i32* %j.ptr, align 4
  %cmpaj = icmp sle i32 %aj, %pivot
  br i1 %cmpaj, label %then, label %loop.inc

then:                                             ; preds = %body
  %i.plus1 = add i32 %i.cur, 1
  %i.plus1.ext = sext i32 %i.plus1 to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.plus1.ext
  %ai = load i32, i32* %i.ptr, align 4
  store i32 %aj, i32* %i.ptr, align 4
  store i32 %ai, i32* %j.ptr, align 4
  br label %loop.inc

loop.inc:                                         ; preds = %then, %body
  %i.next = phi i32 [ %i.plus1, %then ], [ %i.cur, %body ]
  %j.next = add i32 %j, 1
  br label %loop

after:                                            ; preds = %loop
  %i.final = add i32 %i.cur, 1
  %i.final.ext = sext i32 %i.final to i64
  %i.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.final.ext
  %ai2 = load i32, i32* %i.final.ptr, align 4
  store i32 %pivot, i32* %i.final.ptr, align 4
  store i32 %ai2, i32* %high.ptr, align 4
  ret i32 %i.final
}

define dso_local void @quick_sort(i32* %arr, i32 %low, i32 %high) local_unnamed_addr {
entry:
  %cmp = icmp slt i32 %low, %high
  br i1 %cmp, label %recurse, label %exit

recurse:                                          ; preds = %entry
  %p = call i32 @partition(i32* %arr, i32 %low, i32 %high)
  %p.minus1 = add i32 %p, -1
  call void @quick_sort(i32* %arr, i32 %low, i32 %p.minus1)
  %p.plus1 = add i32 %p, 1
  call void @quick_sort(i32* %arr, i32 %p.plus1, i32 %high)
  br label %exit

exit:                                             ; preds = %recurse, %entry
  ret void
}

define dso_local i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr9, align 4
  %n = add i32 10, 0
  %cmpn = icmp ugt i32 %n, 1
  br i1 %cmpn, label %do_sort, label %after_sort

do_sort:                                          ; preds = %entry
  %nminus1 = add i32 %n, -1
  call void @quick_sort(i32* %arr0, i32 0, i32 %nminus1)
  br label %after_sort

after_sort:                                       ; preds = %do_sort, %entry
  br label %loop

loop:                                             ; preds = %loop.body, %after_sort
  %i = phi i32 [ 0, %after_sort ], [ %i.next, %loop.body ]
  %cond = icmp ult i32 %i, %n
  br i1 %cond, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop
  %i.ext = sext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i.ext
  %val = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %val)
  %i.next = add i32 %i, 1
  br label %loop

loop.end:                                         ; preds = %loop
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}