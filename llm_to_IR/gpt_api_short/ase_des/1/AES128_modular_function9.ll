; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 single-block encryption (confidence=0.98). Evidence: calls to key_expansion, _sub_bytes/shift_rows/mix_columns, add_round_key with 10 rounds.
; Preconditions: out, in, key each point to at least 16 readable/writable bytes; key is 16 bytes.
; Postconditions: out[0..15] contains AES-128 encryption of in[0..15] under key.

@__stack_chk_guard = external global i64

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @___stack_chk_fail()

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  ; stack canary
  %canary.load = load i64, i64* @__stack_chk_guard, align 8
  %canary.slot = alloca i64, align 8
  store i64 %canary.load, i64* %canary.slot, align 8

  %state = alloca [16 x i8], align 16
  %roundkeys = alloca [176 x i8], align 16

  ; copy input block into state
  br label %copy_in.loop

copy_in.loop:                                         ; preds = %copy_in.loop, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy_in.loop ]
  %i.zext = zext i32 %i to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.zext
  %byte = load i8, i8* %in.ptr.i, align 1
  %state.ptr.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.zext
  store i8 %byte, i8* %state.ptr.i, align 1
  %i.next = add nuw nsw i32 %i, 1
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %copy_in.loop, label %after_copy_in

after_copy_in:                                        ; preds = %copy_in.loop
  ; expand key into roundkeys
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  ; initial AddRoundKey with round 0 key
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)

  ; rounds 1..9
  br label %rounds.loop

rounds.loop:                                          ; preds = %rounds.loop, %after_copy_in
  %r = phi i32 [ 1, %after_copy_in ], [ %r.next, %rounds.loop ]
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %r.off.bytes = mul nuw nsw i32 %r, 16
  %r.off.zext = zext i32 %r.off.bytes to i64
  %rk.r.ptr = getelementptr inbounds i8, i8* %rk.base, i64 %r.off.zext
  call void @add_round_key(i8* %state.base, i8* %rk.r.ptr)
  %r.next = add nuw nsw i32 %r, 1
  %rounds.cont = icmp sle i32 %r.next, 9
  br i1 %rounds.cont, label %rounds.loop, label %after_rounds

after_rounds:                                         ; preds = %rounds.loop
  ; final round: SubBytes, ShiftRows, AddRoundKey with round 10 key (+0xA0)
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final)

  ; copy state to out
  br label %copy_out.loop

copy_out.loop:                                        ; preds = %copy_out.loop, %after_rounds
  %j = phi i32 [ 0, %after_rounds ], [ %j.next, %copy_out.loop ]
  %j.z = zext i32 %j to i64
  %s.ptr.j = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j.z
  %s.byte = load i8, i8* %s.ptr.j, align 1
  %out.ptr.j = getelementptr inbounds i8, i8* %out, i64 %j.z
  store i8 %s.byte, i8* %out.ptr.j, align 1
  %j.next = add nuw nsw i32 %j, 1
  %out.cont = icmp sle i32 %j.next, 15
  br i1 %out.cont, label %copy_out.loop, label %canary.check

canary.check:                                         ; preds = %copy_out.loop
  %canary.reload = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary.reload, %guard.now
  br i1 %ok, label %ret, label %stackfail

stackfail:                                            ; preds = %canary.check
  call void @___stack_chk_fail()
  unreachable

ret:                                                  ; preds = %canary.check
  ret void
}