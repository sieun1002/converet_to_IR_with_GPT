; ModuleID = 'selection_sort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %nminus1 = add i32 %n, -1
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.inner ]
  %cmpOuter = icmp slt i32 %i, %nminus1
  br i1 %cmpOuter, label %inner.init, label %ret

inner.init:
  %j.start = add i32 %i, 1
  br label %inner.cond

inner.cond:
  %min = phi i32 [ %i, %inner.init ], [ %min.next, %inner.body.end ]
  %j = phi i32 [ %j.start, %inner.init ], [ %j.next, %inner.body.end ]
  %cmpJ = icmp slt i32 %j, %n
  br i1 %cmpJ, label %inner.body, label %after.inner

inner.body:
  %j.idx.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.ext = sext i32 %min to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %cmp = icmp slt i32 %j.val, %min.val
  br i1 %cmp, label %setmin, label %nosetmin

setmin:
  br label %inner.body.end

nosetmin:
  br label %inner.body.end

inner.body.end:
  %min.next = phi i32 [ %j, %setmin ], [ %min, %nosetmin ]
  %j.next = add i32 %j, 1
  br label %inner.cond

after.inner:
  %i.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ext
  %i.val = load i32, i32* %i.ptr, align 4
  %min.ext2 = sext i32 %min to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.ext2
  %min.val2 = load i32, i32* %min.ptr2, align 4
  store i32 %min.val2, i32* %i.ptr, align 4
  store i32 %i.val, i32* %min.ptr2, align 4
  %i.next = add i32 %i, 1
  br label %outer.cond

ret:
  ret void
}