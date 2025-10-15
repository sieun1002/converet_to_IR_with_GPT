target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  %arr.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %var_8 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_14 = alloca i32, align 4
  store i32* %arr, i32** %arr.addr, align 8
  store i64 %n, i64* %n.addr, align 8
  store i64 1, i64* %var_8, align 8
  br label %outer_check

outer_check:                                      ; corresponds to loc_1400014FC
  %i.load = load i64, i64* %var_8, align 8
  %n.load = load i64, i64* %n.addr, align 8
  %cmp = icmp ult i64 %i.load, %n.load
  br i1 %cmp, label %outer_body, label %exit

outer_body:                                       ; corresponds to loc_14000146D
  %i.load2 = load i64, i64* %var_8, align 8
  %arr.load = load i32*, i32** %arr.addr, align 8
  %elem.ptr = getelementptr inbounds i32, i32* %arr.load, i64 %i.load2
  %elem.val = load i32, i32* %elem.ptr, align 4
  store i32 %elem.val, i32* %var_14, align 4
  store i64 %i.load2, i64* %var_10, align 8
  br label %inner_check

inner_check:                                      ; corresponds to loc_1400014BE
  %j.load = load i64, i64* %var_10, align 8
  %j.iszero = icmp eq i64 %j.load, 0
  br i1 %j.iszero, label %inner_exit, label %inner_compare

inner_compare:
  %j.load2 = load i64, i64* %var_10, align 8
  %jm1 = add i64 %j.load2, -1
  %arr.load2 = load i32*, i32** %arr.addr, align 8
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr.load2, i64 %jm1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %key.load = load i32, i32* %var_14, align 4
  %cmp.key = icmp slt i32 %key.load, %val.jm1
  br i1 %cmp.key, label %shift, label %inner_exit

shift:                                            ; corresponds to loc_14000148F
  %j.load3 = load i64, i64* %var_10, align 8
  %arr.load3 = load i32*, i32** %arr.addr, align 8
  %ptr.j = getelementptr inbounds i32, i32* %arr.load3, i64 %j.load3
  %j.load4 = load i64, i64* %var_10, align 8
  %jm1.b = add i64 %j.load4, -1
  %arr.load4 = load i32*, i32** %arr.addr, align 8
  %src.ptr = getelementptr inbounds i32, i32* %arr.load4, i64 %jm1.b
  %src.val = load i32, i32* %src.ptr, align 4
  store i32 %src.val, i32* %ptr.j, align 4
  %j.load5 = load i64, i64* %var_10, align 8
  %j.dec = add i64 %j.load5, -1
  store i64 %j.dec, i64* %var_10, align 8
  br label %inner_check

inner_exit:                                       ; corresponds to loc_1400014DF
  %j.load6 = load i64, i64* %var_10, align 8
  %arr.load5 = load i32*, i32** %arr.addr, align 8
  %dst.ptr = getelementptr inbounds i32, i32* %arr.load5, i64 %j.load6
  %key.load2 = load i32, i32* %var_14, align 4
  store i32 %key.load2, i32* %dst.ptr, align 4
  %i.load3 = load i64, i64* %var_8, align 8
  %i.inc = add i64 %i.load3, 1
  store i64 %i.inc, i64* %var_8, align 8
  br label %outer_check

exit:
  ret void
}