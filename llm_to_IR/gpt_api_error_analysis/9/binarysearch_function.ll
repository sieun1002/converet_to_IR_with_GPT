target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %cond

cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %back ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %back ]
  %cmp.lohi = icmp ult i64 %low, %high
  br i1 %cmp.lohi, label %body, label %after

body:
  %range = sub i64 %high, %low
  %half = lshr i64 %range, 1
  %mid = add i64 %low, %half
  %ptr.mid = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val.mid = load i32, i32* %ptr.mid, align 4
  %cmp.key.le = icmp sle i32 %key, %val.mid
  br i1 %cmp.key.le, label %set_high, label %set_low

set_high:
  br label %back

set_low:
  %mid.plus1 = add i64 %mid, 1
  br label %back

back:
  %low.next = phi i64 [ %low, %set_high ], [ %mid.plus1, %set_low ]
  %high.next = phi i64 [ %mid, %set_high ], [ %high, %set_low ]
  br label %cond

after:
  %check.in.bounds = icmp ult i64 %low, %n
  br i1 %check.in.bounds, label %maybe_equal, label %not_found

maybe_equal:
  %ptr.low = getelementptr inbounds i32, i32* %arr, i64 %low
  %val.low = load i32, i32* %ptr.low, align 4
  %eq = icmp eq i32 %key, %val.low
  br i1 %eq, label %found, label %not_found

found:
  ret i64 %low

not_found:
  ret i64 -1
}