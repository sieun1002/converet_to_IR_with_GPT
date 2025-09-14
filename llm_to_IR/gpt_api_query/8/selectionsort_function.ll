; ModuleID = 'selection_sort'
source_filename = "selection_sort.c"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* %a, i32 %n) {
entry:
  %i = alloca i32, align 4
  %min = alloca i32, align 4
  %j = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %outer.test

outer.test:
  %i.val = load i32, i32* %i, align 4
  %nminus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %i.val, %nminus1
  br i1 %cmp.outer, label %outer.body, label %exit

outer.body:
  store i32 %i.val, i32* %min, align 4
  %i.val2 = load i32, i32* %i, align 4
  %jstart = add nsw i32 %i.val2, 1
  store i32 %jstart, i32* %j, align 4
  br label %inner.test

inner.test:
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp slt i32 %j.val, %n
  br i1 %cmp.j, label %inner.body, label %after.inner

inner.body:
  %j.val2 = load i32, i32* %j, align 4
  %j.idx64 = sext i32 %j.val2 to i64
  %j.ptr = getelementptr inbounds i32, i32* %a, i64 %j.idx64
  %aj = load i32, i32* %j.ptr, align 4

  %min.val = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.val to i64
  %min.ptr = getelementptr inbounds i32, i32* %a, i64 %min.idx64
  %amin = load i32, i32* %min.ptr, align 4

  %cmp = icmp slt i32 %aj, %amin
  br i1 %cmp, label %update.min, label %no.update

update.min:
  %j.val3 = load i32, i32* %j, align 4
  store i32 %j.val3, i32* %min, align 4
  br label %no.update

no.update:
  %j.val4 = load i32, i32* %j, align 4
  %j.next = add nsw i32 %j.val4, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.test

after.inner:
  %i.val3 = load i32, i32* %i, align 4
  %i.idx64 = sext i32 %i.val3 to i64
  %i.ptr = getelementptr inbounds i32, i32* %a, i64 %i.idx64
  %ai = load i32, i32* %i.ptr, align 4
  store i32 %ai, i32* %tmp, align 4

  %min.val2 = load i32, i32* %min, align 4
  %min.idx64.2 = sext i32 %min.val2 to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %a, i64 %min.idx64.2
  %avalmin = load i32, i32* %min.ptr2, align 4
  store i32 %avalmin, i32* %i.ptr, align 4

  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %min.ptr2, align 4

  %i.val4 = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.val4, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.test

exit:
  ret void
}