; ModuleID = 'binary_search.ll'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:
  %lo = phi i64 [ 0, %entry ], [ %mid.plus1, %update_lo ], [ %lo, %update_hi ]
  %hi = phi i64 [ %n, %entry ], [ %hi, %update_lo ], [ %mid, %update_hi ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %update_hi, label %update_lo

update_lo:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.cond

update_hi:
  br label %loop.cond

after.loop:
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check.eq, label %notfound

check.eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %lo

notfound:
  ret i64 -1 }