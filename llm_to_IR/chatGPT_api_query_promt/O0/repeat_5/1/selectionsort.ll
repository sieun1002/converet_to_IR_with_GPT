; ModuleID = 'selection_sort'
source_filename = "selection_sort"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i32, align 4
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                       ; i < n - 1 (signed)
  %i.val = load i32, i32* %i, align 4
  %n.val = load i32, i32* %n.addr, align 4
  %n.minus1 = add i32 %n.val, -1
  %outer.cmp = icmp slt i32 %i.val, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:
  ; min = i
  store i32 %i.val, i32* %min, align 4
  ; j = i + 1
  %j.init = add i32 %i.val, 1
  store i32 %j.init, i32* %j, align 4
  br label %inner.cond

inner.cond:                                       ; j < n (signed)
  %j.val = load i32, i32* %j, align 4
  %n.val2 = load i32, i32* %n.addr, align 4
  %inner.cmp = icmp slt i32 %j.val, %n.val2
  br i1 %inner.cmp, label %inner.body, label %after.inner

inner.body:
  %arr.ptr = load i32*, i32** %arr.addr, align 8
  ; load arr[j]
  %j.ext = sext i32 %j.val to i64
  %j.gep = getelementptr inbounds i32, i32* %arr.ptr, i64 %j.ext
  %aj = load i32, i32* %j.gep, align 4
  ; load arr[min]
  %min.val = load i32, i32* %min, align 4
  %min.ext = sext i32 %min.val to i64
  %min.gep = getelementptr inbounds i32, i32* %arr.ptr, i64 %min.ext
  %amin = load i32, i32* %min.gep, align 4
  ; if (arr[j] < arr[min]) min = j
  %cmp = icmp slt i32 %aj, %amin
  br i1 %cmp, label %set.min, label %no.set.min

set.min:
  store i32 %j.val, i32* %min, align 4
  br label %no.set.min

no.set.min:
  ; j++
  %j.cur = load i32, i32* %j, align 4
  %j.next = add i32 %j.cur, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:
  ; swap arr[i] and arr[min]
  %arr.ptr2 = load i32*, i32** %arr.addr, align 8
  %i.cur = load i32, i32* %i, align 4
  %i.ext = sext i32 %i.cur to i64
  %i.gep = getelementptr inbounds i32, i32* %arr.ptr2, i64 %i.ext
  %ai = load i32, i32* %i.gep, align 4
  store i32 %ai, i32* %tmp, align 4
  %min.cur = load i32, i32* %min, align 4
  %min.ext2 = sext i32 %min.cur to i64
  %min.gep2 = getelementptr inbounds i32, i32* %arr.ptr2, i64 %min.ext2
  %amin2 = load i32, i32* %min.gep2, align 4
  store i32 %amin2, i32* %i.gep, align 4
  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %min.gep2, align 4
  ; i++
  %i.next = add i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

exit:
  ret void
}