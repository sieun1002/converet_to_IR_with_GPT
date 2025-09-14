; ModuleID = 'binary_search'
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %body ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %body ]
  %cond = icmp ult i64 %lo, %hi
  br i1 %cond, label %body, label %after

body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val.mid = load i32, i32* %ptr.mid, align 4
  %le = icmp sle i32 %key, %val.mid
  %hi.next = select i1 %le, i64 %mid, i64 %hi
  %mid.plus = add i64 %mid, 1
  %lo.next = select i1 %le, i64 %lo, i64 %mid.plus
  br label %loop

after:
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check, label %ret.neg

check:
  %ptr.lo = getelementptr inbounds i32, i32* %arr, i64 %lo
  %val.lo = load i32, i32* %ptr.lo, align 4
  %eq = icmp eq i32 %key, %val.lo
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:
  ret i64 %lo

ret.neg:
  ret i64 -1
}