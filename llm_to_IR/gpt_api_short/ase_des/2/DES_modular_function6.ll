; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES 64-bit block encryption with 16-round Feistel and IP/FP permutations (confidence=0.86). Evidence: 16-round Feistel loop with subkey array; two permute calls using IP/FP tables.

; Preconditions: @unk_2020 (IP table) and @FP (final permutation table) must be valid; key_schedule/feistel/permute must conform to declared signatures.
; Postconditions: Returns 64-bit ciphertext.

@unk_2020 = external global [0 x i8]
@FP = external global [0 x i8]
@__stack_chk_guard = external thread_local global i64

; Only the necessary external declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail()

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %guard.save = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %guard.save, align 8
  %subkeys.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.base)
  %ip.tbl.base = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2020, i64 0, i64 0
  %ip = call i64 @permute(i64 %block, i8* %ip.tbl.base, i32 64, i32 64)
  %ip_shr = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_shr to i32
  %R0 = trunc i64 %ip to i32
  br label %loop

loop:                                             ; preds = %entry, %loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop ]
  %L = phi i32 [ %L0, %entry ], [ %R, %loop ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop ]
  %idx.ext = sext i32 %i to i64
  %subkey.ptr = getelementptr inbounds i64, i64* %subkeys.base, i64 %idx.ext
  %subkey.val = load i64, i64* %subkey.ptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %subkey.val)
  %tmp = xor i32 %L, %f
  %R.next = %tmp
  %i.next = add nsw i32 %i, 1
  %cond = icmp sle i32 %i.next, 15
  br i1 %cond, label %loop, label %post

post:                                             ; preds = %loop
  %Rfinal.z = zext i32 %R.next to i64
  %Rshift = shl i64 %Rfinal.z, 32
  %Lfinal.z = zext i32 %R to i64
  %preout = or i64 %Rshift, %Lfinal.z
  %fp.tbl.base = getelementptr inbounds [0 x i8], [0 x i8]* @FP, i64 0, i64 0
  %out = call i64 @permute(i64 %preout, i8* %fp.tbl.base, i32 64, i32 64)
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.was = load i64, i64* %guard.save, align 8
  %ok = icmp eq i64 %guard.was, %guard.now
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %post
  call void @__stack_chk_fail()
  br label %ret

ret:                                              ; preds = %fail, %post
  ret i64 %out
}