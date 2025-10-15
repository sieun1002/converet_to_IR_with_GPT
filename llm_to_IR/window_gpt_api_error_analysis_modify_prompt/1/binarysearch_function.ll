; ModuleID = 'binary_search'
target triple = "x86_64-pc-windows-msvc"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.test

loop.test:
  %low.cur = phi i64 [ 0, %entry ], [ %mid.plus1, %update.low ], [ %low.pass, %update.high ]
  %high.cur = phi i64 [ %n, %entry ], [ %high.pass, %update.low ], [ %mid, %update.high ]
  %cmp.lohi = icmp ult i64 %low.cur, %high.cur
  br i1 %cmp.lohi, label %loop.body, label %after.loop

loop.body:
  %low.pass = add i64 %low.cur, 0
  %high.pass = add i64 %high.cur, 0
  %diff = sub i64 %high.pass, %low.pass
  %half = lshr i64 %diff, 1
  %mid = add i64 %low.pass, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %update.high, label %update.low

update.high:
  br label %loop.test

update.low:
  %mid.plus1 = add i64 %mid, 1
  br label %loop.test

after.loop:
  %in.bounds = icmp ult i64 %low.cur, %n
  br i1 %in.bounds, label %check.eq, label %ret.neg1

check.eq:
  %elem2.ptr = getelementptr inbounds i32, i32* %arr, i64 %low.cur
  %elem2 = load i32, i32* %elem2.ptr, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %ret.idx, label %ret.neg1

ret.idx:
  ret i64 %low.cur

ret.neg1:
  ret i64 4294967295
}