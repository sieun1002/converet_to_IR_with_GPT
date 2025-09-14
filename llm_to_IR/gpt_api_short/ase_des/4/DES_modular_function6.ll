; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES 16-round block encryption with IP/FP permutations (confidence=0.94). Evidence: 16-round Feistel loop using key_schedule and feistel; IP/FP table pointers.
; Preconditions: unk_2020 (IP table) and FP (final permutation table) are 64-byte tables; key_schedule fills 16 64-bit subkeys.
; Postconditions: Returns 64-bit ciphertext.

@unk_2020 = external global [64 x i8]
@FP = external global [64 x i8]

; Only the necessary external declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  ; subkeys[16]
  %subkeys = alloca [16 x i64], align 16
  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)

  ; Initial Permutation (IP)
  %ip.tab = getelementptr inbounds [64 x i8], [64 x i8]* @unk_2020, i64 0, i64 0
  %ip = call i64 @permute(i64 %block, i8* %ip.tab, i32 64, i32 64)

  ; Split into L (high 32) and R (low 32)
  %L64 = lshr i64 %ip, 32
  %L0 = trunc i64 %L64 to i32
  %R0 = trunc i64 %ip to i32

  br label %loop

loop:
  ; i = 0..15 inclusive
  %i = phi i32 [ 0, %entry ], [ %i.next, %body ]
  %Lcur = phi i32 [ %L0, %entry ], [ %Lnext, %body ]
  %Rcur = phi i32 [ %R0, %entry ], [ %Rnext, %body ]
  %cont = icmp sle i32 %i, 15
  br i1 %cont, label %body, label %after

body:
  ; subkey = subkeys[i]
  %i.zext = zext i32 %i to i64
  %subkey.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %i.zext
  %subkey = load i64, i64* %subkey.ptr, align 8

  ; f = feistel(Rcur, subkey)
  %f = call i32 @feistel(i32 %Rcur, i64 %subkey)

  ; DES round: (L, R) = (R, L xor f(R, K[i]))
  %Rnext = xor i32 %Lcur, %f
  %Lnext = %Rcur
  %i.next = add i32 %i, 1
  br label %loop

after:
  ; Combine R||L (post-swap) and apply Final Permutation (FP)
  %Rz = zext i32 %Rcur to i64
  %Lz = zext i32 %Lcur to i64
  %Rsh = shl i64 %Rz, 32
  %preout = or i64 %Rsh, %Lz

  %fp.tab = getelementptr inbounds [64 x i8], [64 x i8]* @FP, i64 0, i64 0
  %out = call i64 @permute(i64 %preout, i8* %fp.tab, i32 64, i32 64)
  ret i64 %out
}