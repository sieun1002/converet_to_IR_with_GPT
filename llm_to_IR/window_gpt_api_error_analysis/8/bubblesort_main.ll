; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.loop

outer.loop:
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.cont ]
  %limit = sub i64 %n, 1
  %i.done = icmp uge i64 %i, %limit
  br i1 %i.done, label %ret, label %inner.loop

inner.loop:
  %j = phi i64 [ 0, %outer.loop ], [ %j.next, %inner.cont ]
  %tmp1 = sub i64 %n, %i
  %limit2 = sub i64 %tmp1, 1
  %cond = icmp ugt i64 %j, %limit2
  br i1 %cond, label %outer.cont, label %body

body:
  %gep1 = getelementptr inbounds i32, i32* %arr, i64 %j
  %val1 = load i32, i32* %gep1, align 4
  %jp1 = add i64 %j, 1
  %gep2 = getelementptr inbounds i32, i32* %arr, i64 %jp1
  %val2 = load i32, i32* %gep2, align 4
  %gt = icmp sgt i32 %val1, %val2
  br i1 %gt, label %do.swap, label %inner.cont

do.swap:
  store i32 %val2, i32* %gep1, align 4
  store i32 %val1, i32* %gep2, align 4
  br label %inner.cont

inner.cont:
  %j.next = add i64 %j, 1
  br label %inner.loop

outer.cont:
  %i.next = add i64 %i, 1
  br label %outer.loop

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %arr1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %arr2, align 4
  %arr3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %arr3, align 4
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %arr4, align 4
  %arr5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %arr5, align 4
  %arr6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %arr6, align 4
  %arr7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4
  %arr9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %arr9, align 4
  store i64 10, i64* %n, align 8
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %arrdecay, i64 %nval)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp = icmp ult i64 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %eltptr = getelementptr inbounds i32, i32* %arrdecay, i64 %i.cur
  %elt = load i32, i32* %eltptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elt)
  %inext = add i64 %i.cur, 1
  store i64 %inext, i64* %i, align 8
  br label %loop.cond

after.loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}