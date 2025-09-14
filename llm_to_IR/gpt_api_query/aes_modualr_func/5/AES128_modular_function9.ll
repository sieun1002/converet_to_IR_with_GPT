; ModuleID = 'aes_module'
source_filename = "aes_module.ll"
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64

declare void @key_expansion(i8* %key, i8* %roundkeys)
declare void @add_round_key(i8* %state, i8* %roundkey)
declare void @_sub_bytes(i8* %state)
declare void @shift_rows(i8* %state)
declare void @mix_columns(i8* %state)
declare void @___stack_chk_fail()

define void @aes128_encrypt(i8* %out, i8* %in, i8* %key) {
entry:
  %state = alloca [16 x i8], align 16
  %roundkeys = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %j = alloca i32, align 4
  %guard.slot = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %guard.slot, align 8

  store i32 0, i32* %i, align 4
  br label %load_loop.cond

load_loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp.i = icmp sle i32 %i.val, 15
  br i1 %cmp.i, label %load_loop.body, label %load_loop.end

load_loop.body:
  %idxprom = sext i32 %i.val to i64
  %in.elem.ptr = getelementptr inbounds i8, i8* %in, i64 %idxprom
  %in.byte = load i8, i8* %in.elem.ptr, align 1
  %state.elem.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idxprom
  store i8 %in.byte, i8* %state.elem.ptr, align 1
  %inc.i = add i32 %i.val, 1
  store i32 %inc.i, i32* %i, align 4
  br label %load_loop.cond

load_loop.end:
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)

  store i32 1, i32* %round, align 4
  br label %round_loop.cond

round_loop.cond:
  %r = load i32, i32* %round, align 4
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %round_loop.body, label %round_loop.end

round_loop.body:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)

  %shl = shl i32 %r, 4
  %off = sext i32 %shl to i64
  %rk.ptr = getelementptr inbounds i8, i8* %rk.base, i64 %off
  call void @add_round_key(i8* %state.base, i8* %rk.ptr)

  %inc.r = add i32 %r, 1
  store i32 %inc.r, i32* %round, align 4
  br label %round_loop.cond

round_loop.end:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.last = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.last)

  store i32 0, i32* %j, align 4
  br label %store_loop.cond

store_loop.cond:
  %j.val = load i32, i32* %j, align 4
  %cmp.j = icmp sle i32 %j.val, 15
  br i1 %cmp.j, label %store_loop.body, label %epilogue

store_loop.body:
  %idxprom2 = sext i32 %j.val to i64
  %state.out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idxprom2
  %byte.out = load i8, i8* %state.out.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %idxprom2
  store i8 %byte.out, i8* %out.ptr, align 1
  %inc.j = add i32 %j.val, 1
  store i32 %inc.j, i32* %j, align 4
  br label %store_loop.cond

epilogue:
  %guard.cur = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %guard.slot, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.cur
  br i1 %guard.ok, label %ret, label %stack_fail

stack_fail:
  call void @___stack_chk_fail()
  br label %ret

ret:
  ret void
}