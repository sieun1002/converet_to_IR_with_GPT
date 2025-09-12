; ModuleID = 'insertion_sort.ll'
source_filename = "insertion_sort"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @insertion_sort(i32* nocapture %a, i64 %n) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %key = alloca i32, align 4
  store i64 1, i64* %i, align 8
  br label %outer.cond

outer.cond:                                       ; i < n
  %i.val = load i64, i64* %i, align 8
  %cmp = icmp ult i64 %i.val, %n
  br i1 %cmp, label %outer.body, label %exit

outer.body:                                       ; key = a[i]; j = i;
  %gep.i = getelementptr inbounds i32, i32* %a, i64 %i.val
  %key.load = load i32, i32* %gep.i, align 4
  store i32 %key.load, i32* %key, align 4
  store i64 %i.val, i64* %j, align 8
  br label %inner.cond

inner.cond:                                       ; j != 0 ?
  %j.val = load i64, i64* %j, align 8
  %j.nonzero = icmp ne i64 %j.val, 0
  br i1 %j.nonzero, label %inner.check, label %after.inner

inner.check:                                      ; key < a[j-1] (signed)
  %jm1 = add i64 %j.val, -1
  %gep.jm1 = getelementptr inbounds i32, i32* %a, i64 %jm1
  %prev = load i32, i32* %gep.jm1, align 4
  %key.cur = load i32, i32* %key, align 4
  %lt = icmp slt i32 %key.cur, %prev
  br i1 %lt, label %inner.body, label %after.inner

inner.body:                                       ; a[j] = a[j-1]; j--
  %gep.j = getelementptr inbounds i32, i32* %a, i64 %j.val
  store i32 %prev, i32* %gep.j, align 4
  %j.dec = add i64 %j.val, -1
  store i64 %j.dec, i64* %j, align 8
  br label %inner.cond

after.inner:                                      ; a[j] = key; i++
  %j.fin = load i64, i64* %j, align 8
  %gep.j.fin = getelementptr inbounds i32, i32* %a, i64 %j.fin
  %key.fin = load i32, i32* %key, align 4
  store i32 %key.fin, i32* %gep.j.fin, align 4
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %outer.cond

exit:
  ret void
}