; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 encrypt a single 16-byte block (ECB-like), using provided key expansion and round ops (confidence=0.93). Evidence: calls to key_expansion/add_round_key/_sub_bytes/shift_rows/mix_columns; 10 rounds with final key offset 0xA0.
; Preconditions: out, in, key are valid pointers; at least 16 bytes readable from in and writable to out; key usable by key_expansion.
; Postconditions: Writes 16-byte ciphertext to out.

@__stack_chk_guard = external global i64

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @__stack_chk_fail()

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %round_keys = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  ; Copy input block into state
  store i32 0, i32* %i, align 4
  br label %copy_in.cond

copy_in.cond:                                      ; preds = %copy_in.body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp.in = icmp sle i32 %i.val, 15
  br i1 %cmp.in, label %copy_in.body, label %after_copy_in

copy_in.body:                                      ; preds = %copy_in.cond
  %i64 = sext i32 %i.val to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i64
  %b = load i8, i8* %in.ptr, align 1
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %state.elem = getelementptr inbounds i8, i8* %state.base, i64 %i64
  store i8 %b, i8* %state.elem, align 1
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %copy_in.cond

after_copy_in:                                     ; preds = %copy_in.cond
  ; Key expansion
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %round_keys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)

  ; Initial AddRoundKey with round key 0
  %state.ptr0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.ptr0, i8* %rk.base)

  ; Rounds 1..9
  store i32 1, i32* %round, align 4
  br label %rounds.cond

rounds.cond:                                       ; preds = %rounds.body, %after_copy_in
  %r = load i32, i32* %round, align 4
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %rounds.body, label %after_rounds

rounds.body:                                       ; preds = %rounds.cond
  ; SubBytes, ShiftRows, MixColumns
  call void @_sub_bytes(i8* %state.ptr0)
  call void @shift_rows(i8* %state.ptr0)
  call void @mix_columns(i8* %state.ptr0)
  ; AddRoundKey with offset r*16
  %r64 = sext i32 %r to i64
  %off = shl nsw i64 %r64, 4
  %rk.r = getelementptr inbounds i8, i8* %rk.base, i64 %off
  call void @add_round_key(i8* %state.ptr0, i8* %rk.r)
  %r.next = add nsw i32 %r, 1
  store i32 %r.next, i32* %round, align 4
  br label %rounds.cond

after_rounds:                                      ; preds = %rounds.cond
  ; Final round (no MixColumns), key offset 160 (0xA0)
  call void @_sub_bytes(i8* %state.ptr0)
  call void @shift_rows(i8* %state.ptr0)
  %rk.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.ptr0, i8* %rk.final)

  ; Copy state to output
  store i32 0, i32* %i, align 4
  br label %copy_out.cond

copy_out.cond:                                     ; preds = %copy_out.body, %after_rounds
  %j.val = load i32, i32* %i, align 4
  %cmp.out = icmp sle i32 %j.val, 15
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:                                     ; preds = %copy_out.cond
  %j64 = sext i32 %j.val to i64
  %s.elem = getelementptr inbounds i8, i8* %state.ptr0, i64 %j64
  %byte = load i8, i8* %s.elem, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %byte, i8* %out.ptr, align 1
  %j.inc = add nsw i32 %j.val, 1
  store i32 %j.inc, i32* %i, align 4
  br label %copy_out.cond

epilogue:                                          ; preds = %copy_out.cond
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %canary.cur = load i64, i64* %canary.slot, align 8
  %chk = icmp eq i64 %guard.end, %canary.cur
  br i1 %chk, label %ret, label %fail

fail:                                              ; preds = %epilogue
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %epilogue
  ret void
}