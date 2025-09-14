; ModuleID = 'selection_sort'
source_filename = "selection_sort"
target triple = "x86_64-unknown-linux-gnu"

define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer

outer:
  %i.val = load i32, i32* %i, align 4
  %nMinus1 = add nsw i32 %n, -1
  %cond = icmp slt i32 %i.val, %nMinus1
  br i1 %cond, label %outer.body, label %exit

outer.body:
  store i32 %i.val, i32* %min, align 4
  %i.plus1 = add nsw i32 %i.val, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %inner

inner:
  %j.val = load i32, i32* %j, align 4
  %cmpj = icmp slt i32 %j.val, %n
  br i1 %cmpj, label %inner.body, label %after.inner

inner.body:
  %j.idx64 = sext i32 %j.val to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %aj = load i32, i32* %j.ptr, align 4

  %min.val = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.val to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %amin = load i32, i32* %min.ptr, align 4

  %lt = icmp slt i32 %aj, %amin
  br i1 %lt, label %updateMin, label %noUpdate

updateMin:
  store i32 %j.val, i32* %min, align 4
  br label %noUpdate

noUpdate:
  %j.val2 = load i32, i32* %j, align 4
  %j.next = add nsw i32 %j.val2, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner

after.inner:
  %i.idx64 = sext i32 %i.val to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %ai = load i32, i32* %i.ptr, align 4
  store i32 %ai, i32* %tmp, align 4

  %min.val2 = load i32, i32* %min, align 4
  %min.idx64.2 = sext i32 %min.val2 to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.idx64.2
  %amin2 = load i32, i32* %min.ptr2, align 4
  store i32 %amin2, i32* %i.ptr, align 4

  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %min.ptr2, align 4

  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer

exit:
  ret void
}