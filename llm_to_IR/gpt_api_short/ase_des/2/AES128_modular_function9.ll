; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt ; Address: 0x178A
; Intent: AES-128 single-block encryption (confidence=0.98). Evidence: calls _sub_bytes/shift_rows/mix_columns/add_round_key with 10 rounds, key_expansion and 16-byte state I/O.
; Preconditions: out, in, key must each point to at least 16 bytes.
; Postconditions: Writes 16-byte ciphertext to out.

; Only the necessary external declarations:
declare void @key_expansion(i8*, i8*) local_unnamed_addr
declare void @add_round_key(i8*, i8*) local_unnamed_addr
declare void @_sub_bytes(i8*) local_unnamed_addr
declare void @shift_rows(i8*) local_unnamed_addr
declare void @mix_columns(i8*) local_unnamed_addr

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  br label %copy_in

copy_in:                                          ; i = 0..15
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy_in.body_end ]
  %cmp.in = icmp sle i32 %i, 15
  br i1 %cmp.in, label %copy_in.body, label %copy_in.done

copy_in.body:
  %i64 = sext i32 %i to i64
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i64
  %b = load i8, i8* %in.ptr, align 1
  %state.elem = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i64
  store i8 %b, i8* %state.elem, align 1
  %i.next = add nsw i32 %i, 1
  br label %copy_in

copy_in.body_end:                                 ; unreachable

copy_in.done:
  %rk.i8 = bitcast [176 x i8]* %rk to i8*
  %state.i8 = bitcast [16 x i8]* %state to i8*
  ; key expansion
  call void @key_expansion(i8* %key, i8* %rk.i8)
  ; initial AddRoundKey (round 0)
  call void @add_round_key(i8* %state.i8, i8* %rk.i8)
  br label %rounds

rounds:
  %r = phi i32 [ 1, %copy_in.done ], [ %r.next, %rounds.cont ]
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %rounds.body, label %rounds.done

rounds.body:
  call void @_sub_bytes(i8* %state.i8)
  call void @shift_rows(i8* %state.i8)
  call void @mix_columns(i8* %state.i8)
  %off16 = shl i32 %r, 4
  %off64 = sext i32 %off16 to i64
  %rk.round = getelementptr inbounds i8, i8* %rk.i8, i64 %off64
  call void @add_round_key(i8* %state.i8, i8* %rk.round)
  %r.next = add nsw i32 %r, 1
  br label %rounds

rounds.cont:                                       ; unreachable

rounds.done:
  call void @_sub_bytes(i8* %state.i8)
  call void @shift_rows(i8* %state.i8)
  %rk.final = getelementptr inbounds i8, i8* %rk.i8, i64 160
  call void @add_round_key(i8* %state.i8, i8* %rk.final)
  br label %copy_out

copy_out:                                         ; i = 0..15
  %j = phi i32 [ 0, %rounds.done ], [ %j.next, %copy_out.body_end ]
  %cmp.out = icmp sle i32 %j, 15
  br i1 %cmp.out, label %copy_out.body, label %copy_out.done

copy_out.body:
  %j64 = sext i32 %j to i64
  %state.elem.rd = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j64
  %bv = load i8, i8* %state.elem.rd, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j64
  store i8 %bv, i8* %out.ptr, align 1
  %j.next = add nsw i32 %j, 1
  br label %copy_out

copy_out.body_end:                                 ; unreachable

copy_out.done:
  ret void
}