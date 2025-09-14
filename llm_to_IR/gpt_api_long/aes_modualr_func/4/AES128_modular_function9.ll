; ModuleID = 'aes128_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: aes128_encrypt  ; Address: 0x178A
; Intent: AES-128 encrypt one 16-byte block with 128-bit key (confidence=0.99). Evidence: 16-byte state, 11*16 key schedule, 9 middle rounds with MixColumns and final round without.
; Preconditions: %out, %in, %key point to at least 16 bytes; %key is 16 bytes (AES-128). Helpers follow standard AES semantics.

@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare void @key_expansion(i8*, i8*)
declare void @add_round_key(i8*, i8*)
declare void @_sub_bytes(i8*)
declare void @shift_rows(i8*)
declare void @mix_columns(i8*)
declare void @__stack_chk_fail()

define dso_local void @aes128_encrypt(i8* %out, i8* %in, i8* %key) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %state = alloca [16 x i8], align 16
  %expkey = alloca [176 x i8], align 16
  br label %copy_in.cond

copy_in.cond:                                        ; i in [0,16)
  %i = phi i64 [ 0, %entry ], [ %i.next, %copy_in.body ]
  %cmp.in = icmp ult i64 %i, 16
  br i1 %cmp.in, label %copy_in.body, label %copy_in.done

copy_in.body:
  %in.ptr = getelementptr inbounds i8, i8* %in, i64 %i
  %b = load i8, i8* %in.ptr, align 1
  %st.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %i
  store i8 %b, i8* %st.ptr, align 1
  %i.next = add i64 %i, 1
  br label %copy_in.cond

copy_in.done:
  %expkey.base = getelementptr inbounds [176 x i8], [176 x i8]* %expkey, i64 0, i64 0
  call void @key_expansion(i8* %key, i8* %expkey.base)
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  call void @add_round_key(i8* %state.base, i8* %expkey.base)
  br label %round.cond

round.cond:                                          ; round in [1,9]
  %round = phi i64 [ 1, %copy_in.done ], [ %round.next, %round.body.end ]
  %round.cmp = icmp ule i64 %round, 9
  br i1 %round.cmp, label %round.body, label %round.done

round.body:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  call void @mix_columns(i8* %state.base)
  %round.mul16 = shl i64 %round, 4
  %rk.ptr = getelementptr inbounds i8, i8* %expkey.base, i64 %round.mul16
  call void @add_round_key(i8* %state.base, i8* %rk.ptr)
  br label %round.body.end

round.body.end:
  %round.next = add i64 %round, 1
  br label %round.cond

round.done:
  call void @_sub_bytes(i8* %state.base)
  call void @shift_rows(i8* %state.base)
  %rk.final = getelementptr inbounds i8, i8* %expkey.base, i64 160
  call void @add_round_key(i8* %state.base, i8* %rk.final)
  br label %copy_out.cond

copy_out.cond:                                       ; j in [0,16)
  %j = phi i64 [ 0, %round.done ], [ %j.next, %copy_out.body ]
  %cmp.out = icmp ult i64 %j, 16
  br i1 %cmp.out, label %copy_out.body, label %epilogue

copy_out.body:
  %st.b.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 %j
  %b2 = load i8, i8* %st.b.ptr, align 1
  %out.ptr = getelementptr inbounds i8, i8* %out, i64 %j
  store i8 %b2, i8* %out.ptr, align 1
  %j.next = add i64 %j, 1
  br label %copy_out.cond

epilogue:
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret void
}