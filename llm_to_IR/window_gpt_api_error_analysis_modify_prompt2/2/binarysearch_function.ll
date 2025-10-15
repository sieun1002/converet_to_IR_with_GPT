; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %count, i32 %key) {
entry:
  br label %cond

cond:                                             ; preds = %entry, %latch
  %low = phi i64 [ 0, %entry ], [ %low.next, %latch ]
  %high = phi i64 [ %count, %entry ], [ %high.next, %latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %cond
  %sub = sub i64 %high, %low
  %half = lshr i64 %sub, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %is_gt = icmp sgt i32 %key, %val
  br i1 %is_gt, label %setlow, label %sethigh

setlow:                                           ; preds = %body
  %mid.plus1 = add i64 %mid, 1
  br label %latch

sethigh:                                          ; preds = %body
  br label %latch

latch:                                            ; preds = %setlow, %sethigh
  %low.next = phi i64 [ %mid.plus1, %setlow ], [ %low, %sethigh ]
  %high.next = phi i64 [ %high, %setlow ], [ %mid, %sethigh ]
  br label %cond

after:                                            ; preds = %cond
  %inrange = icmp ult i64 %low, %count
  br i1 %inrange, label %checkeq, label %retneg1

checkeq:                                          ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %retlow, label %retneg1

retlow:                                           ; preds = %checkeq
  ret i64 %low

retneg1:                                          ; preds = %after, %checkeq
  ret i64 4294967295
}