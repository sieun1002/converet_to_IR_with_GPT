target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %key.addr = alloca i32, align 4
  store i64 1, i64* %i.addr, align 8
  br label %outer.cond

outer.cond:                                       ; preds = %insert, %entry
  %i.load = load i64, i64* %i.addr, align 8
  %cmp = icmp ult i64 %i.load, %n
  br i1 %cmp, label %outer.body, label %outer.end

outer.body:                                       ; preds = %outer.cond
  %i.cur = load i64, i64* %i.addr, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %elem.val = load i32, i32* %elem.ptr, align 4
  store i32 %elem.val, i32* %key.addr, align 4
  store i64 %i.cur, i64* %j.addr, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %shift, %outer.body
  %j.load = load i64, i64* %j.addr, align 8
  %j.is.zero = icmp eq i64 %j.load, 0
  br i1 %j.is.zero, label %insert, label %cmp.key

cmp.key:                                          ; preds = %inner.cond
  %j.load2 = load i64, i64* %j.addr, align 8
  %j.minus1 = add i64 %j.load2, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key.load = load i32, i32* %key.addr, align 4
  %key.lt = icmp slt i32 %key.load, %val.jm1
  br i1 %key.lt, label %shift, label %insert

shift:                                            ; preds = %cmp.key
  %j.load3 = load i64, i64* %j.addr, align 8
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.load3
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j.load3, -1
  store i64 %j.dec, i64* %j.addr, align 8
  br label %inner.cond

insert:                                           ; preds = %cmp.key, %inner.cond
  %j.load4 = load i64, i64* %j.addr, align 8
  %ptr.dest = getelementptr inbounds i32, i32* %arr, i64 %j.load4
  %key.load2 = load i32, i32* %key.addr, align 4
  store i32 %key.load2, i32* %ptr.dest, align 4
  %i.load2 = load i64, i64* %i.addr, align 8
  %i.inc = add i64 %i.load2, 1
  store i64 %i.inc, i64* %i.addr, align 8
  br label %outer.cond

outer.end:                                        ; preds = %outer.cond
  ret void
}