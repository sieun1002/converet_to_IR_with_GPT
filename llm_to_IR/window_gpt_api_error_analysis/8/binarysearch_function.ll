; ModuleID = 'binary_search'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %body ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %body ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %body, label %after

body:
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  %midp1 = add i64 %mid, 1
  %lo.next = select i1 %le, i64 %lo, i64 %midp1
  %hi.next = select i1 %le, i64 %mid, i64 %hi
  br label %loop

after:
  %final_lo = phi i64 [ %lo, %loop ]
  %inrange = icmp ult i64 %final_lo, %n
  br i1 %inrange, label %check, label %ret.notfound

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %final_lo
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:
  ret i64 %final_lo

ret.notfound:
  %nf = zext i32 -1 to i64
  ret i64 %nf
}