; ModuleID = 'aes128_encrypt.ll'
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @__stack_chk_fail() noreturn

define void @aes128_encrypt(i8* %out, i8* %in, i8* %key) {
entry:
  %canary = alloca i64, align 8
  %state = alloca [16 x i8], align 16
  %roundkeys = alloca [176 x i8], align 16
  %i_in = alloca i32, align 4
  %round = alloca i32, align 4
  %i_out = alloca i32, align 4

  %guardval = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guardval, i64* %canary, align 8

  store i32 0, i32* %i_in, align 4
  br label %copy_in.cond

copy_in.cond:
  %iv = load i32, i32* %i_in, align 4
  %cmp.in = icmp sle i32 %iv, 15
  br i1 %cmp.in, label %copy_in.body, label %copy_in.end

copy_in.body:
  %idx64 = sext i32 %iv to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %idx64
  %byte = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx64
  store i8 %byte, i8* %state.elem, align 1
  %iv.next = add i32 %iv, 1
  store i32 %iv.next, i32* %i_in, align 4
  br label %copy_in.cond

copy_in.end:
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)

  store i32 1, i32* %round, align 4
  br label %rounds.cond

rounds.cond:
  %r = load i32, i32* %round, align 4
  %cmp.round = icmp sle i32 %r, 9
  br i1 %cmp.round, label %rounds.body, label %rounds.end

rounds.body:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %rk.off.shl = shl i32 %r, 4
  %rk.off = sext i32 %rk.off.shl to i64
  %rk.n = getelementptr inbounds i8, i8* %rk.base, i64 %rk.off
  call void @add_round_key(i8* %state.base, i8* %rk.n)
  %r.next = add i32 %r, 1
  store i32 %r.next, i32* %round, align 4
  br label %rounds.cond

rounds.end:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final)

  store i32 0, i32* %i_out, align 4
  br label %copy_out.cond

copy_out.cond:
  %jo = load i32, i32* %i_out, align 4
  %cmp.out = icmp sle i32 %jo, 15
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:
  %jo64 = sext i32 %jo to i64
  %state.read = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %jo64
  %val = load i8, i8* %state.read, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %jo64
  store i8 %val, i8* %out.ptr, align 1
  %jo.next = add i32 %jo, 1
  store i32 %jo.next, i32* %i_out, align 4
  br label %copy_out.cond

epilogue:
  %guardval.end = load i64, i64* @__stack_chk_guard, align 8
  %guardval.saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guardval.end, %guardval.saved
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret void
}