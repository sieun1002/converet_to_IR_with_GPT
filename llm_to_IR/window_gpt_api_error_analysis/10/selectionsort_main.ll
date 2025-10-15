; ModuleID = 'fixed-module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)

define void @__main() {
entry:
  ret void
}

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                          ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i, %nminus1
  br i1 %cmp.outer, label %outer.body, label %outer.end

outer.body:                                          ; preds = %outer.cond
  %j.init = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:                                          ; preds = %inner.inc, %outer.body
  %min.cur = phi i32 [ %i, %outer.body ], [ %min.cand, %inner.inc ]
  %j.cur = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %cmp.j = icmp slt i32 %j.cur, %n
  br i1 %cmp.j, label %inner.body, label %inner.end

inner.body:                                          ; preds = %inner.cond
  %j64 = sext i32 %j.cur to i64
  %min64 = sext i32 %min.cur to i64
  %p.j = getelementptr inbounds i32, i32* %arr, i64 %j64
  %p.min = getelementptr inbounds i32, i32* %arr, i64 %min64
  %v.j = load i32, i32* %p.j, align 4
  %v.min = load i32, i32* %p.min, align 4
  %less = icmp slt i32 %v.j, %v.min
  %min.cand = select i1 %less, i32 %j.cur, i32 %min.cur
  br label %inner.inc

inner.inc:                                           ; preds = %inner.body
  %j.next = add nsw i32 %j.cur, 1
  br label %inner.cond

inner.end:                                           ; preds = %inner.cond
  %neq = icmp ne i32 %min.cur, %i
  br i1 %neq, label %swap, label %outer.inc

swap:                                                ; preds = %inner.end
  %i64 = sext i32 %i to i64
  %min64b = sext i32 %min.cur to i64
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i64
  %p.m2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %v.i = load i32, i32* %p.i, align 4
  %v.m2 = load i32, i32* %p.m2, align 4
  store i32 %v.m2, i32* %p.i, align 4
  store i32 %v.i, i32* %p.m2, align 4
  br label %outer.inc

outer.inc:                                           ; preds = %swap, %inner.end
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

outer.end:                                           ; preds = %outer.cond
  ret void
}

define i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %n.addr = alloca i32, align 4
  %i.addr = alloca i32, align 4
  %arr0.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  %arr1.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 1
  %arr2.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 2
  %arr3.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 3
  %arr4.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 4
  store i32 29, i32* %arr0.ptr, align 4
  store i32 10, i32* %arr1.ptr, align 4
  store i32 14, i32* %arr2.ptr, align 4
  store i32 37, i32* %arr3.ptr, align 4
  store i32 13, i32* %arr4.ptr, align 4
  store i32 5, i32* %n.addr, align 4
  %n.load = load i32, i32* %n.addr, align 4
  call void @selection_sort(i32* %arr0.ptr, i32 %n.load)
  %fmt0.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt0.ptr)
  store i32 0, i32* %i.addr, align 4
  br label %loop.cond

loop.cond:                                           ; preds = %loop.body, %entry
  %i.cur = load i32, i32* %i.addr, align 4
  %n.cur = load i32, i32* %n.addr, align 4
  %cmp.i = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp.i, label %loop.body, label %loop.end

loop.body:                                           ; preds = %loop.cond
  %i64 = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr0.ptr, i64 %i64
  %val = load i32, i32* %elem.ptr, align 4
  %fmt1.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i32 %val)
  %i.next2 = add nsw i32 %i.cur, 1
  store i32 %i.next2, i32* %i.addr, align 4
  br label %loop.cond

loop.end:                                            ; preds = %loop.cond
  ret i32 0
}