; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES 64-bit block encryption (confidence=0.87). Evidence: calls key_schedule/feistel; uses IP/FP permutation tables.
; Preconditions: key_schedule fills 16 64-bit round subkeys into the provided buffer.
; Postconditions: returns the 64-bit ciphertext after 16 Feistel rounds with IP/FP permutations.

; Only the necessary external declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)

@unk_2020 = external global i8
@FP = external global i8

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %subkeys.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0

  ; generate round keys
  call void @key_schedule(i64 %key, i64* %subkeys.base)

  ; initial permutation (IP)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)

  ; split into L0 (high 32) and R0 (low 32)
  %L0.w64 = lshr i64 %ip, 32
  %L0 = trunc i64 %L0.w64 to i32
  %R0 = trunc i64 %ip to i32

  br label %loop.check

loop.check:                                           ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop.body ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                            ; preds = %loop.check
  ; load Ki
  %i.ext = sext i32 %i to i64
  %ki.ptr = getelementptr inbounds i64, i64* %subkeys.base, i64 %i.ext
  %ki = load i64, i64* %ki.ptr, align 8

  ; F-function and Feistel update
  %f = call i32 @feistel(i32 %R, i64 %ki)
  %R.xor = xor i32 %L, %f
  %L.next = %R
  %R.next = %R.xor

  ; next round
  %i.next = add i32 %i, 1
  br label %loop.check

loop.end:                                             ; preds = %loop.check
  ; combine R16||L16
  %R.final.z = zext i32 %R to i64
  %R.final.shl = shl i64 %R.final.z, 32
  %L.final.z = zext i32 %L to i64
  %preout = or i64 %R.final.shl, %L.final.z

  ; final permutation (FP)
  %out = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)
  ret i64 %out
}