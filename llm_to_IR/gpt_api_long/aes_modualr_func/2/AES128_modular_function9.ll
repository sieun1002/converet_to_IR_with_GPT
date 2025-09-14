; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 single-block encryption with inline key schedule and standard rounds (confidence=0.98). Evidence: calls _sub_bytes/shift_rows/mix_columns, 10 round schedule with 16-byte stride and 176-byte key expansion buffer
; Preconditions: out, in, key are non-null; in and out point to at least 16 bytes; key points to at least 16 bytes. Helpers operate on 16-byte state; key_expansion writes 176 bytes into round key buffer.
; Postconditions: Writes 16-byte ciphertext to out.

; Only the needed extern declarations:
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  %state.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 0
  br label %copy_in.header

copy_in.header:                                   ; i in [0..15]
  %i = phi i64 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %cmp.exit = icmp sgt i64 %i, 15
  br i1 %cmp.exit, label %after_copy_in, label %copy_in.body

copy_in.body:
  %in.gep = getelementptr inbounds i8, i8* %in, i64 %i
  %val = load i8, i8* %in.gep, align 1
  %st.gep = getelementptr inbounds i8, i8* %state.ptr, i64 %i
  store i8 %val, i8* %st.gep, align 1
  %i.next = add i64 %i, 1
  br label %copy_in.header

after_copy_in:
  call void @key_expansion(i8* %key, i8* %rk.ptr)
  call void @add_round_key(i8* %state.ptr, i8* %rk.ptr)
  br label %round.header

round.header:                                     ; round in [1..9]
  %round = phi i32 [ 1, %after_copy_in ], [ %round.next, %round.latch ]
  %ex = icmp sgt i32 %round, 9
  br i1 %ex, label %final_round, label %round.body

round.body:
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  call void @mix_columns(i8* %state.ptr)
  %sh = shl i32 %round, 4
  %off = sext i32 %sh to i64
  %rk.off = getelementptr inbounds i8, i8* %rk.ptr, i64 %off
  call void @add_round_key(i8* %state.ptr, i8* %rk.off)
  br label %round.latch

round.latch:
  %round.next = add i32 %round, 1
  br label %round.header

final_round:
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  %rk.final = getelementptr inbounds i8, i8* %rk.ptr, i64 160
  call void @add_round_key(i8* %state.ptr, i8* %rk.final)
  br label %copy_out.header

copy_out.header:                                  ; j in [0..15]
  %j = phi i64 [ 0, %final_round ], [ %j.next, %copy_out.body ]
  %cond.exit2 = icmp sgt i64 %j, 15
  br i1 %cond.exit2, label %ret.block, label %copy_out.body

copy_out.body:
  %st.orig.ptr = getelementptr inbounds i8, i8* %state.ptr, i64 %j
  %byte = load i8, i8* %st.orig.ptr, align 1
  %out.gep = getelementptr inbounds i8, i8* %out, i64 %j
  store i8 %byte, i8* %out.gep, align 1
  %j.next = add i64 %j, 1
  br label %copy_out.header

ret.block:
  ret void
}