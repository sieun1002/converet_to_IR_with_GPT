; ModuleID = 'selection_sort'
define void @selection_sort(i32* %arr, i32 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr   = alloca i32,  align 4
  %i        = alloca i32,  align 4
  %j        = alloca i32,  align 4
  %min      = alloca i32,  align 4
  %tmp      = alloca i32,  align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i32 %n, i32* %n.addr, align 4
  store i32 0, i32* %i, align 4
  br label %outer.cond

outer.cond:                                        ; i < n-1
  %i.val.oc = load i32, i32* %i, align 4
  %n.val.oc = load i32, i32* %n.addr, align 4
  %n.minus1 = add i32 %n.val.oc, -1
  %outer.cmp = icmp slt i32 %i.val.oc, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:
  ; min = i
  store i32 %i.val.oc, i32* %min, align 4
  ; j = i + 1
  %ip1 = add i32 %i.val.oc, 1
  store i32 %ip1, i32* %j, align 4
  br label %inner.cond

inner.cond:                                        ; j < n
  %j.val.ic = load i32, i32* %j, align 4
  %n.val.ic = load i32, i32* %n.addr, align 4
  %inner.cmp = icmp slt i32 %j.val.ic, %n.val.ic
  br i1 %inner.cmp, label %inner.body, label %after.inner

inner.body:
  %arr.ld1 = load i32*, i32** %arr.addr, align 8

  ; load a[j]
  %j.idx64 = sext i32 %j.val.ic to i64
  %j.ptr   = getelementptr inbounds i32, i32* %arr.ld1, i64 %j.idx64
  %aj      = load i32, i32* %j.ptr, align 4

  ; load a[min]
  %min.idx = load i32, i32* %min, align 4
  %min.idx64 = sext i32 %min.idx to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr.ld1, i64 %min.idx64
  %amin    = load i32, i32* %min.ptr, align 4

  ; if (a[j] < a[min]) min = j
  %lt = icmp slt i32 %aj, %amin
  br i1 %lt, label %update.min, label %no.update

update.min:
  store i32 %j.val.ic, i32* %min, align 4
  br label %no.update

no.update:
  ; j++
  %j.next = add i32 %j.val.ic, 1
  store i32 %j.next, i32* %j, align 4
  br label %inner.cond

after.inner:
  ; swap a[i] and a[min]
  %arr.ld2 = load i32*, i32** %arr.addr, align 8
  %i.cur   = load i32, i32* %i, align 4
  %i.idx64 = sext i32 %i.cur to i64
  %i.ptr   = getelementptr inbounds i32, i32* %arr.ld2, i64 %i.idx64
  %ai      = load i32, i32* %i.ptr, align 4
  store i32 %ai, i32* %tmp, align 4

  %min.idx2 = load i32, i32* %min, align 4
  %min.idx64b = sext i32 %min.idx2 to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr.ld2, i64 %min.idx64b
  %amin2   = load i32, i32* %min.ptr2, align 4
  store i32 %amin2, i32* %i.ptr, align 4

  %tmp.val = load i32, i32* %tmp, align 4
  store i32 %tmp.val, i32* %min.ptr2, align 4

  ; i++
  %i.next = add i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %outer.cond

exit:
  ret void
}