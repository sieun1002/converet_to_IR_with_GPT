target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.head

loop.head:
  %low.cur = phi i64 [ 0, %entry ], [ %low.cur, %sethigh ], [ %low.next, %setlow ]
  %high.cur = phi i64 [ %n, %entry ], [ %mid, %sethigh ], [ %high.cur, %setlow ]
  %cmp = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp, label %loop.body, label %after

loop.body:
  %diff = sub i64 %high.cur, %low.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %sethigh, label %setlow

setlow:
  %low.next = add i64 %mid, 1
  br label %loop.head

sethigh:
  br label %loop.head

after:
  %inrange = icmp ult i64 %low.cur, %n
  br i1 %inrange, label %checkval, label %ret_fail

checkval:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret_ok, label %ret_fail

ret_ok:
  ret i64 %low.cur

ret_fail:
  ret i64 4294967295
}