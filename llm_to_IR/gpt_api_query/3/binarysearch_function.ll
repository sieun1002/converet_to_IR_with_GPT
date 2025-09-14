; ModuleID = 'binary_search'
source_filename = "binary_search.ll"
target triple = "x86_64-unknown-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr nounwind {
entry:
  br label %while.cond

while.cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %while.latch ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %while.latch ]
  %cmp = icmp ult i64 %low, %hi
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %diff = sub i64 %hi, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %key_le_val = icmp sle i32 %key, %val
  br i1 %key_le_val, label %if.hi, label %if.low

if.hi:
  br label %while.latch

if.low:
  %mid.plus1 = add i64 %mid, 1
  br label %while.latch

while.latch:
  %low.next = phi i64 [ %low, %if.hi ], [ %mid.plus1, %if.low ]
  %hi.next = phi i64 [ %mid, %if.hi ], [ %hi, %if.low ]
  br label %while.cond

while.end:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.neg

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.index, label %ret.neg

ret.index:
  ret i64 %low

ret.neg:
  ret i64 -1
}