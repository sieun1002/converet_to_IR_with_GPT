; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str_d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local dllimport i32 @printf(i8*, ...)

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %n1 = add nsw i32 %n, -1
  %haswork = icmp sgt i32 %n, 1
  br i1 %haswork, label %outer.cond, label %end

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp = icmp slt i32 %i, %n1
  br i1 %cmp, label %outer.body, label %end

outer.body:
  %i.plus1 = add nsw i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %i.plus1, %outer.body ], [ %j.next, %inner.inc ]
  %minidx = phi i32 [ %i, %outer.body ], [ %minidx.next, %inner.inc ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %inner.body, label %inner.end

inner.body:
  %j64 = sext i32 %j to i64
  %min64.hdr = sext i32 %minidx to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j64
  %min.ptr.hdr = getelementptr inbounds i32, i32* %arr, i64 %min64.hdr
  %valj = load i32, i32* %j.ptr, align 4
  %valmin = load i32, i32* %min.ptr.hdr, align 4
  %lt = icmp slt i32 %valj, %valmin
  br label %inner.inc

inner.inc:
  %minidx.next = select i1 %lt, i32 %j, i32 %minidx
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

inner.end:
  %minidx.final = phi i32 [ %minidx, %inner.cond ]
  %need.swap = icmp ne i32 %minidx.final, %i
  br i1 %need.swap, label %do.swap, label %outer.inc

do.swap:
  %i64 = sext i32 %i to i64
  %min64 = sext i32 %minidx.final to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min64
  %ai = load i32, i32* %i.ptr, align 4
  %amin = load i32, i32* %min.ptr, align 4
  store i32 %amin, i32* %i.ptr, align 4
  store i32 %ai, i32* %min.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

end:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [5 x i32], align 16
  %i.var = alloca i32, align 4
  %arr0 = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 0
  store i32 29, i32* %arr0, align 16
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 10, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 14, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 37, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 13, i32* %p4, align 4
  call void @selection_sort(i32* %arr0, i32 5)
  %fmt = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt)
  store i32 0, i32* %i.var, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i.var, align 4
  %cmpi = icmp slt i32 %i.cur, 5
  br i1 %cmpi, label %loop.body, label %after.loop

loop.body:
  %i64b = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i64 0, i64 %i64b
  %val = load i32, i32* %elem.ptr, align 4
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_d, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %val)
  %i.next2 = add nsw i32 %i.cur, 1
  store i32 %i.next2, i32* %i.var, align 4
  br label %loop.cond

after.loop:
  ret i32 0
}