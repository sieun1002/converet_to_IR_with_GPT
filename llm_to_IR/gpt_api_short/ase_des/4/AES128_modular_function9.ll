; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 single-block encryption (confidence=0.90). Evidence: 16-byte state, 176-byte key schedule, 10 rounds with SubBytes/ShiftRows/MixColumns/AddRoundKey
; Preconditions: out, in, key each point to at least 16 bytes; key_expansion populates 176-byte schedule
; Postconditions: Writes 16 bytes of ciphertext to out

; Only the necessary external declarations:
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @___stack_chk_fail()
@__stack_chk_guard = external global i64

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %roundkeys = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %j = alloca i32, align 4
  %guardslot = alloca i64, align 8
  %guard.load = load i64, i64* @__stack_chk_guard
  store i64 %guard.load, i64* %guardslot, align 8
  store i32 0, i32* %i, align 4
  br label %copy_in

copy_in:                                          ; preds = %copy_body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %copy_body, label %after_copy

copy_body:                                        ; preds = %copy_in
  %idx64 = sext i32 %i.val to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %idx64
  %byte = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx64
  store i8 %byte, i8* %state.elem, align 1
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %copy_in

after_copy:                                       ; preds = %copy_in
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %rk.base)
  store i32 1, i32* %round, align 4
  br label %round_loop

round_loop:                                       ; preds = %round_body, %after_copy
  %r = load i32, i32* %round, align 4
  %cmp9 = icmp sle i32 %r, 9
  br i1 %cmp9, label %round_body, label %after_rounds

round_body:                                       ; preds = %round_loop
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %rshl = shl i32 %r, 4
  %rshl64 = sext i32 %rshl to i64
  %rk.off = getelementptr inbounds i8, i8* %rk.base, i64 %rshl64
  call void @add_round_key(i8* %state.base, i8* %rk.off)
  %rnext = add i32 %r, 1
  store i32 %rnext, i32* %round, align 4
  br label %round_loop

after_rounds:                                     ; preds = %round_loop
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final)
  store i32 0, i32* %j, align 4
  br label %copy_out

copy_out:                                         ; preds = %copy_out_body, %after_rounds
  %jv = load i32, i32* %j, align 4
  %cmpo = icmp sle i32 %jv, 15
  br i1 %cmpo, label %copy_out_body, label %ret_chk

copy_out_body:                                    ; preds = %copy_out
  %j64 = sext i32 %jv to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j64
  %b = load i8, i8* %byteptr, align 1
  %outptr = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %b, i8* %outptr, align 1
  %jinc = add i32 %jv, 1
  store i32 %jinc, i32* %j, align 4
  br label %copy_out

ret_chk:                                          ; preds = %copy_out
  %guard.curr = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %guardslot, align 8
  %guard.ok = icmp eq i64 %guard.curr, %guard.saved
  br i1 %guard.ok, label %ret, label %stack_fail

stack_fail:                                       ; preds = %ret_chk
  call void @___stack_chk_fail()
  br label %ret

ret:                                              ; preds = %stack_fail, %ret_chk
  ret void
}