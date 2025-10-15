target triple = "x86_64-pc-windows-msvc"

define dso_local void @insertion_sort(i32* %a, i64 %n) {
entry:
  %array = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %j.addr = alloca i64, align 8
  %key.addr = alloca i32, align 4
  store i32* %a, i32** %array, align 8
  store i64 %n, i64* %n.addr, align 8
  store i64 1, i64* %i.addr, align 8
  br label %outer.check

outer.body:
  %i0 = load i64, i64* %i.addr, align 8
  %arr0 = load i32*, i32** %array, align 8
  %idxptr0 = getelementptr inbounds i32, i32* %arr0, i64 %i0
  %val0 = load i32, i32* %idxptr0, align 4
  store i32 %val0, i32* %key.addr, align 4
  store i64 %i0, i64* %j.addr, align 8
  br label %inner.check

inner.shift:
  %j1 = load i64, i64* %j.addr, align 8
  %jm1 = sub i64 %j1, 1
  %arr1 = load i32*, i32** %array, align 8
  %addr_jm1 = getelementptr inbounds i32, i32* %arr1, i64 %jm1
  %v_jm1 = load i32, i32* %addr_jm1, align 4
  %arr2 = load i32*, i32** %array, align 8
  %addr_j = getelementptr inbounds i32, i32* %arr2, i64 %j1
  store i32 %v_jm1, i32* %addr_j, align 4
  store i64 %jm1, i64* %j.addr, align 8
  br label %inner.check

inner.check:
  %j2 = load i64, i64* %j.addr, align 8
  %cmp0 = icmp eq i64 %j2, 0
  br i1 %cmp0, label %place, label %check2

check2:
  %j3 = load i64, i64* %j.addr, align 8
  %jm1b = sub i64 %j3, 1
  %arr3 = load i32*, i32** %array, align 8
  %addr_jm1b = getelementptr inbounds i32, i32* %arr3, i64 %jm1b
  %a_jm1 = load i32, i32* %addr_jm1b, align 4
  %key0 = load i32, i32* %key.addr, align 4
  %cmp1 = icmp slt i32 %key0, %a_jm1
  br i1 %cmp1, label %inner.shift, label %place

place:
  %j4 = load i64, i64* %j.addr, align 8
  %arr4 = load i32*, i32** %array, align 8
  %addr_j2 = getelementptr inbounds i32, i32* %arr4, i64 %j4
  %key1 = load i32, i32* %key.addr, align 4
  store i32 %key1, i32* %addr_j2, align 4
  %i1 = load i64, i64* %i.addr, align 8
  %iinc = add i64 %i1, 1
  store i64 %iinc, i64* %i.addr, align 8
  br label %outer.check

outer.check:
  %i2 = load i64, i64* %i.addr, align 8
  %n0 = load i64, i64* %n.addr, align 8
  %cmp2 = icmp ult i64 %i2, %n0
  br i1 %cmp2, label %outer.body, label %ret

ret:
  ret void
}