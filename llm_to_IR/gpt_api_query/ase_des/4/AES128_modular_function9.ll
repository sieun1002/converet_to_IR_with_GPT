; ModuleID = 'aes128_encrypt.ll'

@__stack_chk_guard = external global i64
declare void @___stack_chk_fail()
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)

define void @aes128_encrypt(i8* %out, i8* %in, i8* %key) {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %j = alloca i32, align 4
  %canary.slot = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  store i32 0, i32* %i, align 4
  br label %copy_in.cond

copy_in.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp.in = icmp sle i32 %i.val, 15
  br i1 %cmp.in, label %copy_in.body, label %copy_in.end

copy_in.body:
  %idx64 = sext i32 %i.val to i64
  %in.elem.ptr = getelementptr inbounds i8, i8* %in, i64 %idx64
  %b = load i8, i8* %in.elem.ptr, align 1
  %state.elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx64
  store i8 %b, i8* %state.elem.ptr, align 1
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %copy_in.cond

copy_in.end:
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)

  store i32 1, i32* %round, align 4
  br label %round.cond

round.cond:
  %r = load i32, i32* %round, align 4
  %cmp.round = icmp sle i32 %r, 9
  br i1 %cmp.round, label %round.body, label %round.end

round.body:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)

  %r.shl = shl i32 %r, 4
  %r.off = sext i32 %r.shl to i64
  %rk.round = getelementptr inbounds i8, i8* %rk.base, i64 %r.off
  call void @add_round_key(i8* %state.base, i8* %rk.round)

  %r.next = add i32 %r, 1
  store i32 %r.next, i32* %round, align 4
  br label %round.cond

round.end:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final)

  store i32 0, i32* %j, align 4
  br label %copy_out.cond

copy_out.cond:
  %j.val = load i32, i32* %j, align 4
  %cmp.out = icmp sle i32 %j.val, 15
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:
  %j64 = sext i32 %j.val to i64
  %state.rd.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j64
  %sb = load i8, i8* %state.rd.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %sb, i8* %out.ptr, align 1
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %copy_out.cond

epilogue:
  %end.canary = load i64, i64* %canary.slot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %end.canary, %guard2
  br i1 %ok, label %ret, label %fail

fail:
  call void @___stack_chk_fail()
  br label %ret

ret:
  ret void
}