; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %target) {
entry:
  br label %loop.cond

loop.cond:
  %low.cur = phi i64 [ 0, %entry ], [ %low.pass, %set_high ], [ %low.next, %set_low ]
  %high.cur = phi i64 [ %n, %entry ], [ %mid, %set_high ], [ %high.pass, %set_low ]
  %cmp = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %high.cur, %low.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.cur, %half
  %low.pass = add i64 %low.cur, 0
  %high.pass = add i64 %high.cur, 0
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %ptr, align 4
  %le = icmp sle i32 %target, %elem
  br i1 %le, label %set_high, label %set_low

set_high:
  br label %loop.cond

set_low:
  %low.next = add i64 %mid, 1
  br label %loop.cond

after.loop:
  %cmp_end = icmp uge i64 %low.cur, %n
  br i1 %cmp_end, label %ret_notfound, label %check

check:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %elem2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %target, %elem2
  br i1 %eq, label %ret_found, label %ret_notfound

ret_found:
  ret i64 %low.cur

ret_notfound:
  ret i64 4294967295
}