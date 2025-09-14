; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 single-block encryption (confidence=0.98). Evidence: calls to key_expansion/mix_columns/add_round_key and 10-round structure
; Preconditions: out and in point to at least 16 writable/readable bytes; key points to 16 readable bytes
; Postconditions: writes 16-byte ciphertext to out

; Only the necessary external declarations:
; declare void @key_expansion(i8*, i8*)
; declare void @add_round_key(i8*, i8*)
; declare void @_sub_bytes(i8*)
; declare void @shift_rows(i8*)
; declare void @mix_columns(i8*)
; declare void @___stack_chk_fail()
; declare i64 @__stack_chk_guard

@__stack_chk_guard = external global i64

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @___stack_chk_fail()

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @aes128_encrypt(i8* nocapture %out, i8* nocapture readonly %in, i8* nocapture readonly %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %exp = alloca [176 x i8], align 16
  %i = alloca i32, align 4
  %round = alloca i32, align 4
  %j = alloca i32, align 4
  %canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8

  ; Copy 16-byte input block into local state
  store i32 0, i32* %i, align 4
  br label %copy.cond

copy.cond:                                        ; preds = %copy.body, %entry
  %i.val = load i32, i32* %i, align 4
  %i.le15 = icmp sle i32 %i.val, 15
  br i1 %i.le15, label %copy.body, label %copy.end

copy.body:                                        ; preds = %copy.cond
  %idx64 = sext i32 %i.val to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %idx64
  %b = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %idx64
  store i8 %b, i8* %st.ptr, align 1
  %i.next = add i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %copy.cond

copy.end:                                         ; preds = %copy.cond
  ; Key expansion
  %exp.base = getelementptr inbounds [176 x i8], [176 x i8]* %exp, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %exp.base)

  ; Initial round key addition (round 0)
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %exp.base)

  ; Rounds 1..9
  store i32 1, i32* %round, align 4
  br label %round.cond

round.cond:                                       ; preds = %round.body, %copy.end
  %r = load i32, i32* %round, align 4
  %r.le9 = icmp sle i32 %r, 9
  br i1 %r.le9, label %round.body, label %round.end

round.body:                                       ; preds = %round.cond
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %r.sext = sext i32 %r to i64
  %rk.off = shl nsw i64 %r.sext, 4
  %rk.ptr = getelementptr inbounds i8, i8* %exp.base, i64 %rk.off
  call void @add_round_key(i8* %state.base, i8* %rk.ptr)
  %r.next = add i32 %r, 1
  store i32 %r.next, i32* %round, align 4
  br label %round.cond

round.end:                                        ; preds = %round.cond
  ; Final round (no mix_columns), add round key at offset 0xA0
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk10.ptr = getelementptr inbounds i8, i8* %exp.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk10.ptr)

  ; Write 16-byte state to output
  store i32 0, i32* %j, align 4
  br label %store.cond

store.cond:                                       ; preds = %store.body, %round.end
  %j.val = load i32, i32* %j, align 4
  %j.le15 = icmp sle i32 %j.val, 15
  br i1 %j.le15, label %store.body, label %store.end

store.body:                                       ; preds = %store.cond
  %j.idx64 = sext i32 %j.val to i64
  %st.rd.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j.idx64
  %sb = load i8, i8* %st.rd.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j.idx64
  store i8 %sb, i8* %out.ptr, align 1
  %j.next = add i32 %j.val, 1
  store i32 %j.next, i32* %j, align 4
  br label %store.cond

store.end:                                        ; preds = %store.cond
  ; Stack canary check
  %guard.saved = load i64, i64* %canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.eq = icmp eq i64 %guard.saved, %guard.now
  br i1 %guard.eq, label %ret, label %stackfail

stackfail:                                        ; preds = %store.end
  call void @___stack_chk_fail()
  br label %ret

ret:                                              ; preds = %stackfail, %store.end
  ret void
}