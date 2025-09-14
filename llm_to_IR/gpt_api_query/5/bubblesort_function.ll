; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"

define dso_local void @bubble_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %exit, label %outer.init

outer.init:
  %end = alloca i64, align 8
  %j = alloca i64, align 8
  %lastSwap = alloca i64, align 8
  %tmp = alloca i32, align 4
  store i64 %n, i64* %end, align 8
  br label %outer.cond

outer.cond:
  %end.val = load i64, i64* %end, align 8
  %cmp2 = icmp ugt i64 %end.val, 1
  br i1 %cmp2, label %outer.body, label %exit

outer.body:
  store i64 0, i64* %lastSwap, align 8
  store i64 1, i64* %j, align 8
  br label %inner.cond

inner.cond:
  %jval = load i64, i64* %j, align 8
  %endv2 = load i64, i64* %end, align 8
  %cmp3 = icmp ult i64 %jval, %endv2
  br i1 %cmp3, label %inner.body, label %inner.after

inner.body:
  %jminus1 = add i64 %jval, -1
  %ptr_left = getelementptr inbounds i32, i32* %a, i64 %jminus1
  %left = load i32, i32* %ptr_left, align 4
  %ptr_right = getelementptr inbounds i32, i32* %a, i64 %jval
  %right = load i32, i32* %ptr_right, align 4
  %cmpgt = icmp sgt i32 %left, %right
  br i1 %cmpgt, label %do.swap, label %no.swap

do.swap:
  store i32 %left, i32* %tmp, align 4
  store i32 %right, i32* %ptr_left, align 4
  %t = load i32, i32* %tmp, align 4
  store i32 %t, i32* %ptr_right, align 4
  store i64 %jval, i64* %lastSwap, align 8
  br label %no.swap

no.swap:
  %j.next = add i64 %jval, 1
  store i64 %j.next, i64* %j, align 8
  br label %inner.cond

inner.after:
  %ls = load i64, i64* %lastSwap, align 8
  %waszero = icmp eq i64 %ls, 0
  br i1 %waszero, label %exit, label %update.end

update.end:
  store i64 %ls, i64* %end, align 8
  br label %outer.cond

exit:
  ret void
}