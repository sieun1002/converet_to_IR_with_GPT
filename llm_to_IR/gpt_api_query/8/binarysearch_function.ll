; ModuleID = 'binary_search'
source_filename = "binary_search"

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                           ; preds = %loop.latch, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                           ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %sethigh, label %setlow

setlow:                                              ; preds = %loop.body
  %mid.plus = add i64 %mid, 1
  br label %loop.latch

sethigh:                                             ; preds = %loop.body
  br label %loop.latch

loop.latch:                                          ; preds = %sethigh, %setlow
  %low.next = phi i64 [ %mid.plus, %setlow ], [ %low, %sethigh ]
  %high.next = phi i64 [ %high, %setlow ], [ %mid, %sethigh ]
  br label %loop.cond

loop.end:                                            ; preds = %loop.cond
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %check, label %ret.notfound

check:                                               ; preds = %loop.end
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:                                           ; preds = %check
  ret i64 %low

ret.notfound:                                        ; preds = %check, %loop.end
  ret i64 -1
}