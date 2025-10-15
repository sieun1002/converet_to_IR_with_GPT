; ModuleID = 'bubble_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @__main()
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @bubble_sort(i32* %arr, i64 %len) {
entry:
  br label %outer.cond

outer.cond: ; preds = %outer.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp ult i64 %i, %len
  br i1 %cmp.outer, label %inner.init, label %ret

inner.init: ; preds = %outer.cond
  br label %inner.cond

inner.cond: ; preds = %inner.inc, %inner.init
  %j = phi i64 [ 0, %inner.init ], [ %j.next, %inner.inc ]
  %len_minus_i = sub i64 %len, %i
  %up_to = sub i64 %len_minus_i, 1
  %cmp.inner = icmp ult i64 %j, %up_to
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body: ; preds = %inner.cond
  %idxj = getelementptr inbounds i32, i32* %arr, i64 %j
  %j1 = add i64 %j, 1
  %idxj1 = getelementptr inbounds i32, i32* %arr, i64 %j1
  %valj = load i32, i32* %idxj, align 4
  %valj1 = load i32, i32* %idxj1, align 4
  %cmpgt = icmp sgt i32 %valj, %valj1
  br i1 %cmpgt, label %swap, label %inner.inc

swap: ; preds = %inner.body
  store i32 %valj1, i32* %idxj, align 4
  store i32 %valj, i32* %idxj1, align 4
  br label %inner.inc

inner.inc: ; preds = %swap, %inner.body
  %j.next = add i64 %j, 1
  br label %inner.cond

outer.inc: ; preds = %inner.cond
  %i.next = add i64 %i, 1
  br label %outer.cond

ret: ; preds = %outer.cond
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
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
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr0, i64 %lenv)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond: ; preds = %loop.body, %entry
  %i.val = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %i.val, %lenv2
  br i1 %cmp, label %loop.body, label %after.loop

loop.body: ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.val
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %val)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

after.loop: ; preds = %loop.cond
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}