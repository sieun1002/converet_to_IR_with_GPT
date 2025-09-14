; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 single-block encryption (ECB-like) (confidence=0.90). Evidence: 10 rounds with SubBytes/ShiftRows/MixColumns, 176-byte key schedule.
; Preconditions: out,in,key are non-null pointers to at least 16 bytes (in,key read; out written). Key expansion writes 176 bytes to local schedule.
; Postconditions: Writes 16 encrypted bytes to out.

; Only the necessary external declarations:
@__stack_chk_guard = external global i64
declare void @___stack_chk_fail()

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %roundkeys = alloca [176 x i8], align 16
  %canary = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %canary, align 8

  ; copy input -> state[16]
  br label %copy_in.loop

copy_in.loop: ; i in [0..15]
  %i.in = phi i64 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %cmp.in = icmp ule i64 %i.in, 15
  br i1 %cmp.in, label %copy_in.body, label %after.copy_in

copy_in.body:
  %in.ptr = getelementptr i8, i8* %in, i64 %i.in
  %b = load i8, i8* %in.ptr, align 1
  %st.elem = getelementptr [16 x i8], [16 x i8]* %state, i64 0, i64 %i.in
  store i8 %b, i8* %st.elem, align 1
  %i.next = add i64 %i.in, 1
  br label %copy_in.loop

after.copy_in:
  ; key expansion and initial add_round_key
  %rk.base = getelementptr [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)
  %st.base = getelementptr [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %st.base, i8* %rk.base)

  ; rounds 1..9
  br label %rounds.loop

rounds.loop:
  %r = phi i32 [ 1, %after.copy_in ], [ %r.next, %rounds.body ]
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %rounds.body, label %after.rounds

rounds.body:
  call void @_sub_bytes(i8* %st.base)
  call void @shift_rows(i8* %st.base)
  call void @mix_columns(i8* %st.base)
  %r64 = sext i32 %r to i64
  %off = mul i64 %r64, 16
  %rk.ptr = getelementptr i8, i8* %rk.base, i64 %off
  call void @add_round_key(i8* %st.base, i8* %rk.ptr)
  %r.next = add i32 %r, 1
  br label %rounds.loop

after.rounds:
  ; final round (no mix_columns), use round key at offset 0xA0 (160)
  call void @_sub_bytes(i8* %st.base)
  call void @shift_rows(i8* %st.base)
  %rk.last = getelementptr i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %st.base, i8* %rk.last)

  ; copy state -> out[16]
  br label %copy_out.loop

copy_out.loop: ; j in [0..15]
  %j = phi i64 [ 0, %after.rounds ], [ %j.next, %copy_out.body ]
  %cmp.out = icmp ule i64 %j, 15
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:
  %st.read = getelementptr [16 x i8], [16 x i8]* %state, i64 0, i64 %j
  %v = load i8, i8* %st.read, align 1
  %out.ptr = getelementptr i8, i8* %out, i64 %j
  store i8 %v, i8* %out.ptr, align 1
  %j.next = add i64 %j, 1
  br label %copy_out.loop

epilogue:
  %saved = load i64, i64* %canary, align 8
  %guard.now = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %saved, %guard.now
  br i1 %ok, label %ret, label %stkfail

stkfail:
  call void @___stack_chk_fail()
  br label %ret

ret:
  ret void
}