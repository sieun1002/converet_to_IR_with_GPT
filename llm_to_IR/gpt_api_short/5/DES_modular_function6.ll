; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES block encryption (confidence=0.92). Evidence: 16-round Feistel with subkey schedule; initial/final permutations via tables.
; Preconditions: unk_2020 and FP point to valid 64->64 permutation tables; key_schedule fills 16x64-bit subkeys.
; Postconditions: Returns 64-bit ciphertext.

; Only the necessary external declarations:
@unk_2020 = external dso_local global i8
@FP = external dso_local global i8
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %subkeys.decay = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0

  call void @key_schedule(i64 %key, i64* %subkeys.decay)

  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)

  %ip_shr32 = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_shr32 to i32
  %R0 = trunc i64 %ip to i32

  br label %cond

cond:                                             ; preds = %entry, %loop_end
  %i = phi i32 [ 0, %entry ], [ %inc, %loop_end ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop_end ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop_end ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop_body, label %after

loop_body:                                        ; preds = %cond
  %i.zext = zext i32 %i to i64
  %sk.ptr = getelementptr inbounds i64, i64* %subkeys.decay, i64 %i.zext
  %sk = load i64, i64* %sk.ptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %sk)
  %tmp = xor i32 %L, %f
  %L.next = %R
  %R.next = %tmp
  %inc = add i32 %i, 1
  br label %loop_end

loop_end:                                         ; preds = %loop_body
  br label %cond

after:                                            ; preds = %cond
  %R64 = zext i32 %R to i64
  %Rsh = shl i64 %R64, 32
  %L64 = zext i32 %L to i64
  %preout = or i64 %Rsh, %L64

  %out = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)
  ret i64 %out
}