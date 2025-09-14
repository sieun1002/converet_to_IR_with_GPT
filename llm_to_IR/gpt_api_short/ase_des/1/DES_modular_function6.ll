; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES single-block encryption (confidence=0.92). Evidence: 16 Feistel rounds with key_schedule/feistel, initial/final permutations via tables.
; Preconditions: None
; Postconditions: Returns 64-bit ciphertext block

; Only the necessary external declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail() noreturn
@__stack_chk_guard = external global i64
@unk_2020 = external global i8
@FP = external global i8

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %canary = alloca i64, align 8
  %guard.ld = load i64, i64* @__stack_chk_guard
  store i64 %guard.ld, i64* %canary, align 8

  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)

  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %ip_shr = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_shr to i32
  %R0 = trunc i64 %ip to i32

  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.latch ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop.latch ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop.latch ]
  %cond = icmp sle i32 %i, 15
  br i1 %cond, label %loop.body, label %after.loop

loop.body:
  %idxext = zext i32 %i to i64
  %kptr = getelementptr inbounds i64, i64* %subkeys.ptr, i64 %idxext
  %sk = load i64, i64* %kptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %sk)
  %xor = xor i32 %L, %f
  %L.next = %R
  %R.next = %xor
  %i.next = add nsw i32 %i, 1
  br label %loop.latch

loop.latch:
  br label %loop

after.loop:
  %R64 = zext i32 %R to i64
  %Rsh = shl i64 %R64, 32
  %L64 = zext i32 %L to i64
  %preout = or i64 %Rsh, %L64
  %out = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)

  %guard.ld2 = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary, align 8
  %chk = icmp eq i64 %guard.ld2, %guard.saved
  br i1 %chk, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %out
}