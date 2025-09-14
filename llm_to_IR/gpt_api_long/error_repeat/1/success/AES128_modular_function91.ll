; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 encrypt one 16-byte block with 128-bit key (confidence=0.95). Evidence: AES round structure with sub_bytes/shift_rows/mix_columns and round key offsets including final +0xA0.
; Preconditions: %out, %in, %key each reference at least 16 bytes; key_expansion writes 176 bytes of round keys into the provided buffer.

@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @___stack_chk_fail()

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %state = alloca [16 x i8], align 1
  %roundkeys = alloca [176 x i8], align 1
  %0 = load i64, i64* @__stack_chk_guard
  store i64 %0, i64* %canary.slot, align 8
  br label %copy_in.loop

copy_in.loop:                                      ; i: 0..15
  %i = phi i32 [ 0, %entry ], [ %i.next, %copy_in.inc ]
  %i.zext = zext i32 %i to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.zext
  %1 = load i8, i8* %in.ptr.i, align 1
  %state.ptr.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i.zext
  store i8 %1, i8* %state.ptr.i, align 1
  br label %copy_in.inc

copy_in.inc:
  %i.next = add nuw nsw i32 %i, 1
  %cmp.in = icmp sle i32 %i.next, 15
  br i1 %cmp.in, label %copy_in.loop, label %after_copy_in

after_copy_in:
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %roundkeys, i64 0, i64 0
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.base)
  call void @add_round_key(i8* %state.base, i8* %rk.base)
  br label %rounds.loop

rounds.loop:                                       ; round = 1..9
  %round = phi i32 [ 1, %after_copy_in ], [ %round.next, %rounds.inc ]
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %round.ext = sext i32 %round to i64
  %offset.bytes = shl nsw i64 %round.ext, 4
  %rk.round.ptr = getelementptr inbounds i8, i8* %rk.base, i64 %offset.bytes
  call void @add_round_key(i8* %state.base, i8* %rk.round.ptr)
  br label %rounds.inc

rounds.inc:
  %round.next = add nuw nsw i32 %round, 1
  %cont = icmp sle i32 %round.next, 9
  br i1 %cont, label %rounds.loop, label %final_round

final_round:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final.ptr = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final.ptr)
  br label %copy_out.loop

copy_out.loop:                                     ; j: 0..15
  %j = phi i32 [ 0, %final_round ], [ %j.next, %copy_out.inc ]
  %j.zext = zext i32 %j to i64
  %state.ptr.j = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j.zext
  %2 = load i8, i8* %state.ptr.j, align 1
  %out.ptr.j = getelementptr inbounds i8, i8* %out, i64 %j.zext
  store i8 %2, i8* %out.ptr.j, align 1
  br label %copy_out.inc

copy_out.inc:
  %j.next = add nuw nsw i32 %j, 1
  %cmp.out = icmp sle i32 %j.next, 15
  br i1 %cmp.out, label %copy_out.loop, label %stack_chk

stack_chk:
  %guard.end = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %guard.saved, %guard.end
  br i1 %ok, label %ret, label %fail

fail:
  call void @___stack_chk_fail()
  br label %ret

ret:
  ret void
}