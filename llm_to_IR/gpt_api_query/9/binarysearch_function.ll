; ModuleID = 'binary_search.ll'
source_filename = "binary_search.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                           ; preds = %loop.update, %entry
  %low.cur = phi i64 [ 0, %entry ], [ %low.next, %loop.update ]
  %high.cur = phi i64 [ %n, %entry ], [ %high.next, %loop.update ]
  %cmp = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                           ; preds = %loop.cond
  %sub = sub i64 %high.cur, %low.cur
  %half = lshr i64 %sub, 1
  %mid = add i64 %low.cur, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %target, %elem
  br i1 %le, label %setHigh, label %setLow

setLow:                                              ; preds = %loop.body
  %low1 = add i64 %mid, 1
  br label %loop.update

setHigh:                                             ; preds = %loop.body
  %high1 = add i64 %mid, 0
  br label %loop.update

loop.update:                                         ; preds = %setHigh, %setLow
  %low.next = phi i64 [ %low1, %setLow ], [ %low.cur, %setHigh ]
  %high.next = phi i64 [ %high.cur, %setLow ], [ %high1, %setHigh ]
  br label %loop.cond

after.loop:                                          ; preds = %loop.cond
  %ltSize = icmp ult i64 %low.cur, %n
  br i1 %ltSize, label %checkval, label %retneg

checkval:                                            ; preds = %after.loop
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %target, %elem2
  br i1 %eq, label %retlow, label %retneg

retlow:                                              ; preds = %checkval
  ret i64 %low.cur

retneg:                                              ; preds = %checkval, %after.loop
  ret i64 -1
}