; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 encrypt a single 16-byte block with 11-round key schedule (confidence=0.98). Evidence: calls to _sub_bytes/shift_rows/mix_columns and add_round_key with 16-byte round offsets.
; Preconditions: %out, %in, %key each point to at least 16 bytes.

declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @___stack_chk_fail()

@__stack_chk_guard = external thread_local global i64

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %state = alloca [16 x i8], align 16
  %rk = alloca [176 x i8], align 16
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8
  br label %copy_in.loop

copy_in.loop:                                     ; preds = %copy_in.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %i.le = icmp sle i64 %i, 15
  br i1 %i.le, label %copy_in.body, label %after_copy_in

copy_in.body:                                     ; preds = %copy_in.loop
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i
  %in.byte = load i8, i8* %in.ptr.i, align 1
  %state.ptr.i = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i
  store i8 %in.byte, i8* %state.ptr.i, align 1
  %i.next = add nuw nsw i64 %i, 1
  br label %copy_in.loop

after_copy_in:                                    ; preds = %copy_in.loop
  %rk.ptr0 = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %rk.ptr0)
  %st.ptr0 = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %st.ptr0, i8* %rk.ptr0)
  br label %round.loop.cond

round.loop.cond:                                  ; preds = %round.loop.body, %after_copy_in
  %round = phi i64 [ 1, %after_copy_in ], [ %round.next, %round.loop.body ]
  %round.le = icmp sle i64 %round, 9
  br i1 %round.le, label %round.loop.body, label %final_round

round.loop.body:                                  ; preds = %round.loop.cond
  call void @_sub_bytes(i8* %st.ptr0)
  call void @shift_rows(i8* %st.ptr0)
  call void @mix_columns(i8* %st.ptr0)
  %off.bytes = shl i64 %round, 4
  %rk.ptr.r = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 %off.bytes
  call void @add_round_key(i8* %st.ptr0, i8* %rk.ptr.r)
  %round.next = add nuw nsw i64 %round, 1
  br label %round.loop.cond

final_round:                                      ; preds = %round.loop.cond
  call void @_sub_bytes(i8* %st.ptr0)
  call void @shift_rows(i8* %st.ptr0)
  %rk.ptr.final = getelementptr inbounds [176 x i8], [176 x i8]* %rk, i64 0, i64 160
  call void @add_round_key(i8* %st.ptr0, i8* %rk.ptr.final)
  br label %copy_out.loop

copy_out.loop:                                    ; preds = %copy_out.body, %final_round
  %j = phi i64 [ 0, %final_round ], [ %j.next, %copy_out.body ]
  %j.le = icmp sle i64 %j, 15
  br i1 %j.le, label %copy_out.body, label %canary.check

copy_out.body:                                    ; preds = %copy_out.loop
  %state.ptr.j = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j
  %v = load i8, i8* %state.ptr.j, align 1
  %out.ptr.j = getelementptr inbounds i8, i8* %out, i64 %j
  store i8 %v, i8* %out.ptr.j, align 1
  %j.next = add nuw nsw i64 %j, 1
  br label %copy_out.loop

canary.check:                                     ; preds = %copy_out.loop
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %saved, %guard2
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %canary.check
  call void @___stack_chk_fail()
  br label %ret

ret:                                              ; preds = %fail, %canary.check
  ret void
}