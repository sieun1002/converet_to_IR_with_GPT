; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 single-block encryption using helper routines (confidence=0.98). Evidence: 10-round structure with SubBytes/ShiftRows/MixColumns and round key schedule via key_expansion.
; Preconditions: %out, %in, %key each point to at least 16 bytes.
; Postconditions: Writes 16-byte ciphertext to %out.

; Only the needed extern declarations:
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rkbuf = alloca [176 x i8], align 16

  ; state_ptr = &state[0]
  %state.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  ; rk_ptr = &rkbuf[0]
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rkbuf, i64 0, i64 0

  ; Copy 16 bytes from input to local state
  br label %copy_in.loop

copy_in.loop:                                      ; i in [0,16)
  %i.in = phi i64 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %cond.in = icmp ule i64 %i.in, 15
  br i1 %cond.in, label %copy_in.body, label %copy_in.done

copy_in.body:
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.in
  %val.i = load i8, i8* %in.ptr.i, align 1
  %st.ptr.i = getelementptr inbounds i8, i8* %state.ptr, i64 %i.in
  store i8 %val.i, i8* %st.ptr.i, align 1
  %i.next = add i64 %i.in, 1
  br label %copy_in.loop

copy_in.done:
  ; Expand key into round keys buffer
  call void @key_expansion(i8* %key, i8* %rk.ptr)

  ; Initial AddRoundKey with round key 0
  call void @add_round_key(i8* %state.ptr, i8* %rk.ptr)

  ; round = 1
  br label %round.loop

round.loop:
  %round.ctr = phi i32 [ 1, %copy_in.done ], [ %round.next, %round.body_done ]
  %round.cond = icmp sle i32 %round.ctr, 9
  br i1 %round.cond, label %round.body, label %final_round.prelude

round.body:
  ; SubBytes, ShiftRows, MixColumns
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  call void @mix_columns(i8* %state.ptr)

  ; AddRoundKey with offset = round*16
  %round.zext = zext i32 %round.ctr to i64
  %rk.off = shl i64 %round.zext, 4
  %rk.round.ptr = getelementptr inbounds i8, i8* %rk.ptr, i64 %rk.off
  call void @add_round_key(i8* %state.ptr, i8* %rk.round.ptr)

  %round.next = add i32 %round.ctr, 1
  br label %round.body_done

round.body_done:
  br label %round.loop

final_round.prelude:
  ; Final round: SubBytes, ShiftRows, AddRoundKey with offset 0xA0 (160)
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  %rk.final.ptr = getelementptr inbounds i8, i8* %rk.ptr, i64 160
  call void @add_round_key(i8* %state.ptr, i8* %rk.final.ptr)

  ; Copy 16 bytes from state to output
  br label %copy_out.loop

copy_out.loop:
  %i.out = phi i64 [ 0, %final_round.prelude ], [ %i.out.next, %copy_out.body ]
  %cond.out = icmp ule i64 %i.out, 15
  br i1 %cond.out, label %copy_out.body, label %copy_out.done

copy_out.body:
  %st.ptr.o = getelementptr inbounds i8, i8* %state.ptr, i64 %i.out
  %val.o = load i8, i8* %st.ptr.o, align 1
  %out.ptr.o = getelementptr inbounds i8, i8* %out, i64 %i.out
  store i8 %val.o, i8* %out.ptr.o, align 1
  %i.out.next = add i64 %i.out, 1
  br label %copy_out.loop

copy_out.done:
  ret void
}