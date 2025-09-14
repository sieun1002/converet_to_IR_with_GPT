; ModuleID = 'recovered'
source_filename = "recovered"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop

loop:                                             ; preds = %set_low, %set_high, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %set_low ], [ %low, %set_high ]
  %high = phi i64 [ %n, %entry ], [ %high, %set_low ], [ %mid, %set_high ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp_le = icmp sle i32 %key, %val
  br i1 %cmp_le, label %set_high, label %set_low

set_high:                                         ; preds = %body
  br label %loop

set_low:                                          ; preds = %body
  %low.next = add i64 %mid, 1
  br label %loop

after:                                            ; preds = %loop
  %low.exit = phi i64 [ %low, %loop ]
  %lt_n = icmp ult i64 %low.exit, %n
  br i1 %lt_n, label %checkval, label %notfound

checkval:                                         ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.exit
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:                                            ; preds = %checkval
  ret i64 %low.exit

notfound:                                         ; preds = %checkval, %after
  ret i64 -1
}