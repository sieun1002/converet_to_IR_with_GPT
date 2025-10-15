; ModuleID = 'insertion_sort'
target triple = "x86_64-pc-windows-msvc"

define void @insertion_sort(i32* %arg0, i64 %arg1) {
entry:
  %key = alloca i32, align 4
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  store i64 1, i64* %i, align 8
  br label %loop_cond

loop_body:                                           ; loc_14000146D
  %i.val = load i64, i64* %i, align 8
  %arr_i_ptr = getelementptr inbounds i32, i32* %arg0, i64 %i.val
  %arr_i = load i32, i32* %arr_i_ptr, align 4
  store i32 %arr_i, i32* %key, align 4
  store i64 %i.val, i64* %j, align 8
  br label %inner_check

inner_move:                                          ; loc_14000148F
  %j.cur = load i64, i64* %j, align 8
  %jminus1 = add i64 %j.cur, -1
  %src_ptr = getelementptr inbounds i32, i32* %arg0, i64 %jminus1
  %src_val = load i32, i32* %src_ptr, align 4
  %dst_ptr = getelementptr inbounds i32, i32* %arg0, i64 %j.cur
  store i32 %src_val, i32* %dst_ptr, align 4
  %j.dec = add i64 %j.cur, -1
  store i64 %j.dec, i64* %j, align 8
  br label %inner_check

inner_check:                                         ; loc_1400014BE
  %j.chk = load i64, i64* %j, align 8
  %j.iszero = icmp eq i64 %j.chk, 0
  br i1 %j.iszero, label %place_key, label %nonzero

nonzero:
  %j.chk2 = load i64, i64* %j, align 8
  %jm1.chk2 = add i64 %j.chk2, -1
  %cmp_ptr = getelementptr inbounds i32, i32* %arg0, i64 %jm1.chk2
  %cmp_val = load i32, i32* %cmp_ptr, align 4
  %key.val = load i32, i32* %key, align 4
  %key_lt = icmp slt i32 %key.val, %cmp_val
  br i1 %key_lt, label %inner_move, label %place_key

place_key:                                           ; loc_1400014DF
  %j.final = load i64, i64* %j, align 8
  %dest_ptr = getelementptr inbounds i32, i32* %arg0, i64 %j.final
  %key.to.store = load i32, i32* %key, align 4
  store i32 %key.to.store, i32* %dest_ptr, align 4
  %i.old = load i64, i64* %i, align 8
  %i.next = add i64 %i.old, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop_cond

loop_cond:                                           ; loc_1400014FC
  %i.now = load i64, i64* %i, align 8
  %cond = icmp ult i64 %i.now, %arg1
  br i1 %cond, label %loop_body, label %exit

exit:
  ret void
}