; ModuleID = 'binary_search'
source_filename = "binary_search"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr nounwind {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low, %setHigh ], [ %low.next, %setLow ]
  %high = phi i64 [ %n, %entry ], [ %mid, %setHigh ], [ %high, %setLow ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %after

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %key, %elt
  br i1 %le, label %setHigh, label %setLow

setHigh:
  br label %loop

setLow:
  %low.next = add i64 %mid, 1
  br label %loop

after:
  %in.range = icmp ult i64 %low, %n
  br i1 %in.range, label %check, label %ret.neg1

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:
  ret i64 %low

ret.neg1:
  ret i64 -1
}