; llvm 14 IR for aes128_encrypt
; System V AMD64 calling convention inferred from disassembly
; Prototype: void aes128_encrypt(uint8_t* out, const uint8_t* in, const uint8_t* key)

target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64

declare void @__stack_chk_fail() noreturn nounwind
declare void @key_expansion(i8* noundef, i8* noundef)
declare void @add_round_key(i8* noundef, i8* noundef)
declare void @_sub_bytes(i8* noundef)
declare void @shift_rows(i8* noundef)
declare void @mix_columns(i8* noundef)

define dso_local void @aes128_encrypt(i8* nocapture writeonly %out, i8* nocapture readonly %in, i8* nocapture readonly %key) {
entry:
  ; allocas
  %canary = alloca i64, align 8
  %state = alloca [16 x i8], align 16
  %round_keys = alloca [176 x i8], align 16

  ; stack protector prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; compute base pointers
  %state.base = getelementptr inbounds [16 x i8], [16 x i8]* %state, i64 0, i64 0
  %rk.base = getelementptr inbounds [176 x i8], [176 x i8]* %round_keys, i64 0, i64 0

  ; copy 16 bytes from input to local state
  br label %copy_in.loop

copy_in.loop:
  %i.in = phi i32 [ 0, %entry ], [ %i.in.next, %copy_in.body ]
  %i.in.cmp = icmp slt i32 %i.in, 16
  br i1 %i.in.cmp, label %copy_in.body, label %after_copy_in

copy_in.body:
  %i.in.z = zext i32 %i.in to i64
  %in.ptr.i = getelementptr inbounds i8, i8* %in, i64 %i.in.z
  %val.i = load i8, i8* %in.ptr.i, align 1
  %state.ptr.i = getelementptr inbounds i8, i8* %state.base, i64 %i.in.z
  store i8 %val.i, i8* %state.ptr.i, align 1
  %i.in.next = add nsw i32 %i.in, 1
  br label %copy_in.loop

after_copy_in:
  ; key expansion: key -> round_keys
  call void @key_expansion(i8* noundef %key, i8* noundef %rk.base)

  ; initial add_round_key with round key 0
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.base)

  ; rounds 1..9
  br label %round.loop

round.loop:
  %r = phi i32 [ 1, %after_copy_in ], [ %r.next, %round.body ]
  %cmp.r = icmp sle i32 %r, 9
  br i1 %cmp.r, label %round.body, label %final_round

round.body:
  call void @_sub_bytes(i8* noundef %state.base)
  call void @shift_rows(i8* noundef %state.base)
  call void @mix_columns(i8* noundef %state.base)
  %off.r = mul nsw i32 %r, 16
  %off.r.z = zext i32 %off.r to i64
  %rk.r.ptr = getelementptr inbounds i8, i8* %rk.base, i64 %off.r.z
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.r.ptr)
  %r.next = add nsw i32 %r, 1
  br label %round.loop

final_round:
  call void @_sub_bytes(i8* noundef %state.base)
  call void @shift_rows(i8* noundef %state.base)
  ; round 10 key at offset 0xA0 (160)
  %rk.r10.ptr = getelementptr inbounds i8, i8* %rk.base, i64 160
  call void @add_round_key(i8* noundef %state.base, i8* noundef %rk.r10.ptr)

  ; copy 16 bytes from state to output
  br label %copy_out.loop

copy_out.loop:
  %i.out = phi i32 [ 0, %final_round ], [ %i.out.next, %copy_out.body ]
  %i.out.cmp = icmp slt i32 %i.out, 16
  br i1 %i.out.cmp, label %copy_out.body, label %epilogue

copy_out.body:
  %i.out.z = zext i32 %i.out to i64
  %state.ptr.o = getelementptr inbounds i8, i8* %state.base, i64 %i.out.z
  %val.o = load i8, i8* %state.ptr.o, align 1
  %out.ptr.o = getelementptr inbounds i8, i8* %out, i64 %i.out.z
  store i8 %val.o, i8* %out.ptr.o, align 1
  %i.out.next = add nsw i32 %i.out, 1
  br label %copy_out.loop

epilogue:
  ; stack protector epilogue
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.end
  br i1 %guard.ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail() noreturn nounwind
  unreachable

ret:
  ret void
}