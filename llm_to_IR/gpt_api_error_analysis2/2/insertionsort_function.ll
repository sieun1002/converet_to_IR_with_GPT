; ModuleID = 'insertion_sort.ll'
source_filename = "insertion_sort.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %entry, %for.inc
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body.pre, label %for.end

for.body.pre:                                     ; preds = %for.cond
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:                                       ; preds = %for.body.pre, %while.body
  %j = phi i64 [ %i, %for.body.pre ], [ %j.dec, %while.body ]
  %cmpj0 = icmp sgt i64 %j, 0
  br i1 %cmpj0, label %while.cmp2, label %while.end

while.cmp2:                                       ; preds = %while.cond
  %jm1 = add nsw i64 %j, -1
  %addr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %addr.jm1, align 4
  %lt = icmp slt i32 %key, %val.jm1
  br i1 %lt, label %while.body, label %while.end

while.body:                                       ; preds = %while.cmp2
  %addr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %addr.j, align 4
  %j.dec = add nsw i64 %j, -1
  br label %while.cond

while.end:                                        ; preds = %while.cond, %while.cmp2
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.cmp2 ]
  %addr.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %addr.final, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %i.next = add nuw nsw i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}