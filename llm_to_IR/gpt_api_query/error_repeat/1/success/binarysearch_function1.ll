; ModuleID = 'binary_search'
source_filename = "binary_search"
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %set.high, %set.low, %entry
  %low.cur = phi i64 [ 0, %entry ], [ %low.next, %set.low ], [ %low.cur, %set.high ]
  %high.cur = phi i64 [ %n, %entry ], [ %high.cur, %set.low ], [ %mid, %set.high ]
  %cmp = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.header
  %diff = sub i64 %high.cur, %low.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmpk = icmp sle i32 %key, %val
  br i1 %cmpk, label %set.high, label %set.low

set.low:                                          ; preds = %loop.body
  %low.next = add i64 %mid, 1
  br label %loop.header

set.high:                                         ; preds = %loop.body
  br label %loop.header

after.loop:                                       ; preds = %loop.header
  %in.range = icmp ult i64 %low.cur, %n
  br i1 %in.range, label %check.equal, label %ret.notfound

check.equal:                                      ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:                                        ; preds = %check.equal
  ret i64 %low.cur

ret.notfound:                                     ; preds = %check.equal, %after.loop
  ret i64 -1
}