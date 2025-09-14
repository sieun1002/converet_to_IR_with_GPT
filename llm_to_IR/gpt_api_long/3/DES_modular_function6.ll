; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1468
; Intent: DES 64-bit block encryption using 16-round Feistel with key schedule and initial/final permutations (confidence=0.94). Evidence: calls to key_schedule/feistel/permute, 16-round loop with L/R swap and FP/IP tables.
; Preconditions: Second parameter is a 64-bit key; external permutation tables @unk_2020 (IP) and @FP (FP) are valid for 64-bit permutation.
; Postconditions: Returns the 64-bit ciphertext block.

; Only the needed extern declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i64, i64)
declare i32 @feistel(i32, i64)
declare void @___stack_chk_fail()

@__stack_chk_guard = external global i64
@FP = external global i8
@unk_2020 = external global i8

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %canary0 = load i64, i64* @__stack_chk_guard, align 8
  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i64 64, i64 64)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32
  br label %loop

loop:                                             ; while (i <= 15)
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop.body ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop.body ]
  %exit.cond = icmp sgt i32 %i, 15
  br i1 %exit.cond, label %after, label %loop.body

loop.body:
  %idx = zext i32 %i to i64
  %kptr = getelementptr inbounds i64, i64* %subkeys.ptr, i64 %idx
  %Ki = load i64, i64* %kptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %Ki)
  %tmp = xor i32 %L, %f
  %L.next = %R
  %R.next = %tmp
  %i.next = add i32 %i, 1
  br label %loop

after:
  %R64 = zext i32 %R to i64
  %L64 = zext i32 %L to i64
  %Rsh = shl i64 %R64, 32
  %preout = or i64 %Rsh, %L64
  %out = call i64 @permute(i64 %preout, i8* @FP, i64 64, i64 64)
  %canary1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %canary0, %canary1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i64 %out
}