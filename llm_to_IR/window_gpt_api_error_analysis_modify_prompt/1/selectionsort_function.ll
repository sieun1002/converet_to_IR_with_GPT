; ModuleID = 'selection_sort'
source_filename = "selection_sort"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %nminus1 = add i32 %n, -1
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmpi = icmp slt i32 %i, %nminus1
  br i1 %cmpi, label %outer.body, label %exit

outer.body:
  %j.init = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.inc ]
  %minidx = phi i32 [ %i, %outer.body ], [ %min.next, %inner.inc ]
  %cmpj = icmp slt i32 %j, %n
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:
  %j.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %minidx to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %cmpmin = icmp slt i32 %j.val, %min.val
  br i1 %cmpmin, label %inner.inc.set, label %inner.inc

inner.inc.set:
  br label %inner.inc

inner.inc:
  %min.next = phi i32 [ %j, %inner.inc.set ], [ %minidx, %inner.body ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %i.val = load i32, i32* %i.ptr, align 4
  %min2.ext = sext i32 %minidx to i64
  %min2.ptr = getelementptr inbounds i32, i32* %arr, i64 %min2.ext
  %min2.val = load i32, i32* %min2.ptr, align 4
  store i32 %min2.val, i32* %i.ptr, align 4
  store i32 %i.val, i32* %min2.ptr, align 4
  br label %outer.inc

outer.inc:
  %i.next = add i32 %i, 1
  br label %outer.cond

exit:
  ret void
}