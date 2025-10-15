; ModuleID: bubble_sort_module
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @bubble_sort(i32* %arr, i64 %len) {
entry:
  br label %outer.cond

outer.cond:                                         ; preds = %outer.inc, %entry
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp ult i64 %i.phi, %len
  br i1 %cmp.outer, label %inner.setup, label %ret

inner.setup:                                        ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                         ; preds = %inner.body.end, %inner.setup
  %j.phi = phi i64 [ 0, %inner.setup ], [ %j.next, %inner.body.end ]
  %limit = sub i64 %len, %i.phi
  %jplus1 = add i64 %j.phi, 1
  %cond.inner = icmp ult i64 %jplus1, %limit
  br i1 %cond.inner, label %inner.body, label %outer.inc

inner.body:                                         ; preds = %inner.cond
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j.phi
  %valj = load i32, i32* %ptrj, align 4
  %ptrjp1 = getelementptr inbounds i32, i32* %arr, i64 %jplus1
  %valjp1 = load i32, i32* %ptrjp1, align 4
  %cmp.swap = icmp sgt i32 %valj, %valjp1
  br i1 %cmp.swap, label %swap, label %noswap

swap:                                               ; preds = %inner.body
  store i32 %valjp1, i32* %ptrj, align 4
  store i32 %valj, i32* %ptrjp1, align 4
  br label %inner.body.end

noswap:                                             ; preds = %inner.body
  br label %inner.body.end

inner.body.end:                                     ; preds = %noswap, %swap
  %j.next = add i64 %j.phi, 1
  br label %inner.cond

outer.inc:                                          ; preds = %inner.cond
  %i.next = add i64 %i.phi, 1
  br label %outer.cond

ret:                                                ; preds = %outer.cond
  ret void
}

define dso_local i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %idx = alloca i64, align 8
  %len = alloca i64, align 8
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %len, align 8
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %lenload = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %base, i64 %lenload)
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:                                          ; preds = %loop.body, %entry
  %idxv = load i64, i64* %idx, align 8
  %len2 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idxv, %len2
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                          ; preds = %loop.cond
  %ptr = getelementptr inbounds i32, i32* %base, i64 %idxv
  %val = load i32, i32* %ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %val)
  %inc = add i64 %idxv, 1
  store i64 %inc, i64* %idx, align 8
  br label %loop.cond

after.loop:                                         ; preds = %loop.cond
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}