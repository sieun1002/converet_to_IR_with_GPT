define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %cond

cond:
  %low = phi i64 [ 0, %entry ], [ %mid_plus1, %update_low ], [ %low, %update_high ]
  %high = phi i64 [ %n, %entry ], [ %high, %update_low ], [ %mid, %update_high ]
  %cond_lt = icmp ult i64 %low, %high
  br i1 %cond_lt, label %loop, label %post

loop:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %le = icmp sle i32 %key, %elt
  br i1 %le, label %update_high, label %update_low

update_low:
  %mid_plus1 = add i64 %mid, 1
  br label %cond

update_high:
  br label %cond

post:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %notfound

check:
  %elt2.ptr = getelementptr inbounds i32, i32* %arr, i64 %low
  %elt2 = load i32, i32* %elt2.ptr, align 4
  %eq = icmp eq i32 %key, %elt2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low

notfound:
  ret i64 -1
}