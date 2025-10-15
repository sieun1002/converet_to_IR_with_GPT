; ModuleID = 'insertion_sort_module'
source_filename = "insertion_sort.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %key = alloca i32, align 4
  store i64 1, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %while.end, %entry
  %i.load = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.load, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %idxptr = getelementptr inbounds i32, i32* %arr, i64 %i.load
  %val = load i32, i32* %idxptr, align 4
  store i32 %val, i32* %key, align 4
  %jstart = add i64 %i.load, -1
  store i64 %jstart, i64* %j, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j.cur = load i64, i64* %j, align 8
  %cmpj = icmp sge i64 %j.cur, 0
  br i1 %cmpj, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %elt = load i32, i32* %eltptr, align 4
  %key.cur = load i32, i32* %key, align 4
  %gt = icmp sgt i32 %elt, %key.cur
  br i1 %gt, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %jplus1 = add i64 %j.cur, 1
  %destptr = getelementptr inbounds i32, i32* %arr, i64 %jplus1
  store i32 %elt, i32* %destptr, align 4
  %j.next = add i64 %j.cur, -1
  store i64 %j.next, i64* %j, align 8
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.end = load i64, i64* %j, align 8
  %j.end.plus1 = add i64 %j.end, 1
  %dest.insert = getelementptr inbounds i32, i32* %arr, i64 %j.end.plus1
  %key.end = load i32, i32* %key, align 4
  store i32 %key.end, i32* %dest.insert, align 4
  %i.next = add i64 %i.load, 1
  store i64 %i.next, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %first = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %first, align 4
  %idx1 = getelementptr inbounds i32, i32* %first, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %first, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %first, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %first, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %first, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %first, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %first, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %first, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %first, i64 9
  store i32 0, i32* %idx9, align 4
  call void @insertion_sort(i32* %first, i64 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %first, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  br label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}