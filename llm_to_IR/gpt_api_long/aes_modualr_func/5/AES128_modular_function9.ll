; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 encrypt one 16-byte block (confidence=0.98). Evidence: calls key_expansion/sub_bytes/shift_rows/mix_columns/add_round_key; 10-round structure with 0xA0 final round key offset.
; Preconditions: %out, %in, %key point to at least 16 bytes; helpers follow conventional AES semantics; temporary round key buffer of 176 bytes is valid.
; Postconditions: Writes 16-byte ciphertext to %out.

; Only the needed extern declarations:
declare void @key_expansion(i8* nocapture readonly, i8* nocapture)
declare void @add_round_key(i8* nocapture, i8* nocapture readonly)
declare void @_sub_bytes(i8* nocapture)
declare void @shift_rows(i8* nocapture)
declare void @mix_columns(i8* nocapture)

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16

  br label %copy_in.loop

copy_in.loop:                                     ; i from 0 to 15
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy_in.iter ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %copy_in.body, label %after_copy_in

copy_in.body:
  %i64 = zext i32 %i to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i64
  %b = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i64
  store i8 %b, i8* %state.elem, align 1
  br label %copy_in.iter

copy_in.iter:
  %i.next = add i32 %i, 1
  br label %copy_in.loop

after_copy_in:
  %rk.ptr = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 0
  %state.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.ptr)
  call void @add_round_key(i8* %state.ptr, i8* %rk.ptr)

  br label %round.loop

round.loop:                                       ; round from 1 to 9
  %round = phi i32 [ 1, %after_copy_in ], [ %round.next, %round.iter ]
  %cmp2 = icmp sle i32 %round, 9
  br i1 %cmp2, label %round.body, label %after_rounds

round.body:
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  call void @mix_columns(i8* %state.ptr)
  %off32 = shl i32 %round, 4
  %off64 = sext i32 %off32 to i64
  %rk.off = getelementptr inbounds i8, i8* %rk.ptr, i64 %off64
  call void @add_round_key(i8* %state.ptr, i8* %rk.off)
  br label %round.iter

round.iter:
  %round.next = add i32 %round, 1
  br label %round.loop

after_rounds:
  call void @_sub_bytes(i8* %state.ptr)
  call void @shift_rows(i8* %state.ptr)
  %last.off = getelementptr inbounds i8, i8* %rk.ptr, i64 160
  call void @add_round_key(i8* %state.ptr, i8* %last.off)

  br label %copy_out.loop

copy_out.loop:                                    ; j from 0 to 15
  %j = phi i32 [ 0, %after_rounds ], [ %j.next, %copy_out.iter ]
  %cmp3 = icmp sle i32 %j, 15
  br i1 %cmp3, label %copy_out.body, label %ret

copy_out.body:
  %j64 = zext i32 %j to i64
  %state.e2 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j64
  %bv = load i8, i8* %state.e2, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %bv, i8* %out.ptr, align 1
  br label %copy_out.iter

copy_out.iter:
  %j.next = add i32 %j, 1
  br label %copy_out.loop

ret:
  ret void
}