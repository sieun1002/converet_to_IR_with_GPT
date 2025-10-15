; ModuleID = 'insertion_sort'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %jzero = icmp eq i64 %j, 0
  br i1 %jzero, label %insert, label %check

check:                                            ; preds = %while.cond
  %jm1 = add i64 %j, -1
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %elem = load i32, i32* %elem.ptr, align 4
  %cmp2 = icmp slt i32 %key, %elem
  br i1 %cmp2, label %while.body, label %insert

while.body:                                       ; preds = %check
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %elem, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

insert:                                           ; preds = %check, %while.cond
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %check ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:                                          ; preds = %insert
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}