; ModuleID = 'binary_search.ll'
source_filename = "binary_search"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) nounwind readonly {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %low = phi i64 [ 0, %entry ], [ %low.upd, %latch ]
  %high = phi i64 [ %n, %entry ], [ %high.upd, %latch ]
  %cmp.lowhigh = icmp ult i64 %low, %high
  br i1 %cmp.lowhigh, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cond = icmp sle i32 %key, %val
  br i1 %cond, label %set_high, label %set_low

set_high:                                         ; preds = %body
  br label %latch

set_low:                                          ; preds = %body
  %low.next = add i64 %mid, 1
  br label %latch

latch:                                            ; preds = %set_low, %set_high
  %low.upd = phi i64 [ %low, %set_high ], [ %low.next, %set_low ]
  %high.upd = phi i64 [ %mid, %set_high ], [ %high, %set_low ]
  br label %loop

after:                                            ; preds = %loop
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret_neg1

check:                                            ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_idx, label %ret_neg1

ret_idx:                                          ; preds = %check
  ret i64 %low

ret_neg1:                                         ; preds = %check, %after
  ret i64 -1
}