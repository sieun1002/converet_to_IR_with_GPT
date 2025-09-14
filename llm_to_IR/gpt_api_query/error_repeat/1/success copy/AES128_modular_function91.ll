; ModuleID = 'aes128_encrypt.ll'
source_filename = "aes128_encrypt"

declare void @key_expansion(i8* nocapture, i8* nocapture) local_unnamed_addr
declare void @add_round_key(i8* nocapture, i8* nocapture) local_unnamed_addr
declare void @_sub_bytes(i8* nocapture) local_unnamed_addr
declare void @shift_rows(i8* nocapture) local_unnamed_addr
declare void @mix_columns(i8* nocapture) local_unnamed_addr
declare void @__stack_chk_fail() local_unnamed_addr noreturn

@__stack_chk_guard = external global i64

define void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %round_keys = alloca [176 x i8], align 16
  %canary.slot = alloca i64, align 8

  ; stack canary prologue
  %canary_global0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %canary_global0, i64* %canary.slot, align 8

  ; copy input block into state (16 bytes)
  br label %copy_in.loop

copy_in.loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %cmp.in = icmp slt i32 %i, 16
  br i1 %cmp.in, label %copy_in.body, label %post_copy_in

copy_in.body:
  %i64 = sext i32 %i to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i64
  %in.val = load i8, i8* %in.ptr.i, align 1
  %st.ptr.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i64
  store i8 %in.val, i8* %st.ptr.i, align 1
  %i.next = add nuw nsw i32 %i, 1
  br label %copy_in.loop

post_copy_in:
  ; expand key into round_keys
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %round_keys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  ; initial AddRoundKey with round key 0
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)

  ; rounds 1..9
  br label %rounds.loop

rounds.loop:
  %r = phi i32 [ 1, %post_copy_in ], [ %r.next, %rounds.body ]
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %rounds.body, label %after_rounds

rounds.body:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %r.shl = shl i32 %r, 4
  %r.off = sext i32 %r.shl to i64
  %rk.ptr.r = getelementptr inbounds i8, i8* %rk.base, i64 %r.off
  call void @add_round_key(i8* %state.base, i8* %rk.ptr.r)
  %r.next = add nuw nsw i32 %r, 1
  br label %rounds.loop

after_rounds:
  ; final round (round 10): SubBytes, ShiftRows, AddRoundKey with offset 0xA0
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.ptr.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.ptr.final)

  ; copy state to output (16 bytes)
  br label %copy_out.loop

copy_out.loop:
  %j = phi i32 [ 0, %after_rounds ], [ %j.next, %copy_out.body ]
  %cmp.out = icmp slt i32 %j, 16
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:
  %j64 = sext i32 %j to i64
  %st.ptr.o = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j64
  %byte = load i8, i8* %st.ptr.o, align 1
  %out.ptr.o = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %byte, i8* %out.ptr.o, align 1
  %j.next = add nuw nsw i32 %j, 1
  br label %copy_out.loop

epilogue:
  ; stack canary epilogue
  %canary.end = load i64, i64* %canary.slot, align 8
  %canary.global = load i64, i64* @__stack_chk_guard, align 8
  %canary.ok = icmp eq i64 %canary.end, %canary.global
  br i1 %canary.ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret void
}