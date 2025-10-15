target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high, %low
  %halfdiff = lshr i64 %diff, 1
  %mid = add i64 %low, %halfdiff
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %eltptr, align 4
  %le = icmp sle i32 %key, %elt
  br i1 %le, label %sethigh, label %setlow

sethigh:
  br label %loop.latch

setlow:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.latch

loop.latch:
  %low.next = phi i64 [ %low, %sethigh ], [ %mid.plus1, %setlow ]
  %high.next = phi i64 [ %mid, %sethigh ], [ %high, %setlow ]
  br label %loop.header

after.loop:
  %lt_end = icmp ult i64 %low, %n
  br i1 %lt_end, label %check_equal, label %ret_not_found

check_equal:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_success, label %ret_not_found

ret_success:
  %res32 = trunc i64 %low to i32
  ret i32 %res32

ret_not_found:
  ret i32 -1
}