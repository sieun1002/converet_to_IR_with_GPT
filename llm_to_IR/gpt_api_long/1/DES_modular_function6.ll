; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1468
; Intent: DES single-block encryption (confidence=0.98). Evidence: 16-round Feistel loop with subkeys; initial/final permutation tables (IP/FP).
; Preconditions: key_schedule writes 16 64-bit subkeys into the provided buffer.
; Postconditions: returns the 64-bit encrypted block.

@unk_2020 = external dso_local global i8
@FP = external dso_local global i8
@__stack_chk_guard = external thread_local global i64

declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail() noreturn

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %canary.slot = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8
  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %L0.sh = lshr i64 %ip, 32
  %L0 = trunc i64 %L0.sh to i32
  %R0 = trunc i64 %ip to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop.latch ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop.latch ]
  %cmp.i = icmp sle i32 %i, 15
  br i1 %cmp.i, label %loop.body, label %after.loop

loop.body:
  %idx.ext = sext i32 %i to i64
  %sk.ptr = getelementptr inbounds i64, i64* %subkeys.ptr, i64 %idx.ext
  %sk = load i64, i64* %sk.ptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %sk)
  %tmp = xor i32 %L, %f
  %L.next = %R
  %R.next = %tmp
  br label %loop.latch

loop.latch:
  %i.next = add i32 %i, 1
  br label %loop

after.loop:
  %R.z = zext i32 %R to i64
  %R.shl = shl i64 %R.z, 32
  %L.z = zext i32 %L to i64
  %preout = or i64 %R.shl, %L.z
  %fp = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)
  %canary.load = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard
  %check = icmp eq i64 %guard.now, %canary.load
  br i1 %check, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %fp
}