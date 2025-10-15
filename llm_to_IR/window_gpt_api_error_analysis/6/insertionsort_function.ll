; ModuleID = 'insertion_sort'
source_filename = "insertion_sort.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                          ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                          ; preds = %for.cond
  %idx.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %idx.ptr, align 4
  br label %while.cond

while.cond:                                        ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %jzero = icmp eq i64 %j, 0
  br i1 %jzero, label %while.end, label %compare

compare:                                           ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %p_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val_jm1 = load i32, i32* %p_jm1, align 4
  %lt = icmp slt i32 %key, %val_jm1
  br i1 %lt, label %while.body, label %while.end

while.body:                                        ; preds = %compare
  %p_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val_jm1, i32* %p_j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                         ; preds = %compare, %while.cond
  %j.final = phi i64 [ %j, %compare ], [ %j, %while.cond ]
  %p_jfinal = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %p_jfinal, align 4
  br label %for.inc

for.inc:                                           ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                           ; preds = %for.cond
  ret void
}