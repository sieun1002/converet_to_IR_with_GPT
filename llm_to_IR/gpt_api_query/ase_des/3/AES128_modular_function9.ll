; ModuleID = 'aes128_encrypt.ll'
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64, align 8

declare void @key_expansion(i8* noundef, i8* noundef)
declare void @add_round_key(i8* noundef, i8* noundef)
declare void @_sub_bytes(i8* noundef)
declare void @shift_rows(i8* noundef)
declare void @mix_columns(i8* noundef)
declare void @__stack_chk_fail() noreturn

define void @aes128_encrypt(i8* noundef %out, i8* noundef %in, i8* noundef %key) {
entry:
  %canary.slot = alloca i64, align 8
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %j = alloca i32, align 4

  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary.slot, align 8

  store i32 0, i32* %i, align 4
  br label %copyin.cond

copyin.cond:                                        ; preds = %copyin.body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp.in = icmp sle i32 %i.val, 15
  br i1 %cmp.in, label %copyin.body, label %after.copyin

copyin.body:                                        ; preds = %copyin.cond
  %idx64 = sext i32 %i.val to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %idx64
  %b = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx64
  store i8 %b, i8* %state.elem, align 1
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %copyin.cond

after.copyin:                                       ; preds = %copyin.cond
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 0
  call void @key_expansion(i8* noundef %key, i8* noundef %rk.base)

  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.base)

  store i32 1, i32* %round, align 4
  br label %round.cond

round.cond:                                         ; preds = %round.body, %after.copyin
  %r = load i32, i32* %round, align 4
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %round.body, label %after.rounds

round.body:                                         ; preds = %round.cond
  call void @_sub_bytes(i8* noundef %state.base)
  call void @shift_rows(i8* noundef %state.base)
  call void @mix_columns(i8* noundef %state.base)
  %rk.off32 = shl i32 %r, 4
  %rk.off64 = sext i32 %rk.off32 to i64
  %rk.rptr = getelementptr inbounds i8, i8* %rk.base, i64 %rk.off64
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.rptr)
  %r.next = add i32 %r, 1
  store i32 %r.next, i32* %round, align 4
  br label %round.cond

after.rounds:                                       ; preds = %round.cond
  call void @_sub_bytes(i8* noundef %state.base)
  call void @shift_rows(i8* noundef %state.base)
  %rk.round10 = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.round10)

  store i32 0, i32* %j, align 4
  br label %copyout.cond

copyout.cond:                                       ; preds = %copyout.body, %after.rounds
  %j.val = load i32, i32* %j, align 4
  %cmp.out = icmp sle i32 %j.val, 15
  br i1 %cmp.out, label %copyout.body, label %epilogue

copyout.body:                                       ; preds = %copyout.cond
  %j.idx64 = sext i32 %j.val to i64
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j.idx64
  %state.read = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j.idx64
  %val = load i8, i8* %state.read, align 1
  store i8 %val, i8* %out.ptr, align 1
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %copyout.cond

epilogue:                                           ; preds = %copyout.cond
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %guard1, %guard.saved
  br i1 %ok, label %ret, label %stackfail

stackfail:                                          ; preds = %epilogue
  call void @__stack_chk_fail()
  unreachable

ret:                                                ; preds = %epilogue
  ret void
}