; ModuleID = 'binary_search'
define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next, %body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %body, label %after_loop

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %key, %val
  %mid.plus1 = add i64 %mid, 1
  %low.next = select i1 %le, i64 %low, i64 %mid.plus1
  %high.next = select i1 %le, i64 %mid, i64 %high
  br label %loop

after_loop:
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %check_eq, label %ret_notfound

check_eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_found, label %ret_notfound

ret_found:
  ret i64 %low

ret_notfound:
  ret i64 -1
}