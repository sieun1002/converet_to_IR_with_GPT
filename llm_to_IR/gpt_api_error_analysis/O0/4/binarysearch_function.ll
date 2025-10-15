; ModuleID = 'binary_search.ll'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.body ]
  %cmp.loop = icmp ult i64 %low, %high
  br i1 %cmp.loop, label %loop.body, label %postloop

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %cmp.sle = icmp sle i32 %key, %elt
  %mid.plus1 = add i64 %mid, 1
  %high.next = select i1 %cmp.sle, i64 %mid, i64 %high
  %low.next = select i1 %cmp.sle, i64 %low, i64 %mid.plus1
  br label %loop.cond

postloop:
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %checkval, label %ret.neg1

checkval:
  %elt.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %elt2 = load i32, i32* %elt.ptr2, align 4
  %eq = icmp eq i32 %key, %elt2
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:
  ret i64 %low

ret.neg1:
  ret i64 -1
}