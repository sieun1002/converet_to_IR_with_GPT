; ModuleID = 'binary_search'
source_filename = "binary_search.ll"

define i64 @binary_search(i32* %arr, i64 %len, i32 %key) local_unnamed_addr {
entry:
  br label %while.cond

while.cond:
  %low = phi i64 [ 0, %entry ], [ %low.next, %while.body.end ]
  %high = phi i64 [ %len, %entry ], [ %high.next, %while.body.end ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %sub = sub i64 %high, %low
  %shr = lshr i64 %sub, 1
  %mid = add i64 %low, %shr
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %set_high, label %set_low

set_high:
  br label %while.body.end

set_low:
  %plus1 = add i64 %mid, 1
  br label %while.body.end

while.body.end:
  %low.next = phi i64 [ %low, %set_high ], [ %plus1, %set_low ]
  %high.next = phi i64 [ %mid, %set_high ], [ %high, %set_low ]
  br label %while.cond

while.end:
  %inb = icmp ult i64 %low, %len
  br i1 %inb, label %check_eq, label %notfound

check_eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low

notfound:
  ret i64 -1
}