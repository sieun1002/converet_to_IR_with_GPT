; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1468
; Intent: DES 64-bit block encryption (Feistel-16 with IP/FP and subkeys) (confidence=0.95). Evidence: 16-round Feistel loop invoking feistel with subkeys; two 64-bit permute calls using IP/FP tables.
; Preconditions: %key points to a valid key; external tables @unk_2020 (IP) and @FP (FP) exist and match permute's expectations.
; Postconditions: Returns 64-bit ciphertext.

@unk_2020 = external global i8
@FP = external global i8

declare void @key_schedule(i8*, i64*)
declare i64 @permute(i64, i8*, i64, i64)
declare i32 @feistel(i32, i64)

define dso_local i64 @des_encrypt(i64 %block, i8* %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8
  %subkeys.base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i8* %key, i64* %subkeys.base)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i64 64, i64 64)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %round ]
  %L.cur = phi i32 [ %L0, %entry ], [ %L.next, %round ]
  %R.cur = phi i32 [ %R0, %entry ], [ %R.next, %round ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %round, label %after

round:
  %idx64 = zext i32 %i to i64
  %sk.ptr = getelementptr inbounds i64, i64* %subkeys.base, i64 %idx64
  %sk = load i64, i64* %sk.ptr, align 8
  %f = call i32 @feistel(i32 %R.cur, i64 %sk)
  %newR = xor i32 %L.cur, %f
  %L.next = %R.cur
  %R.next = %newR
  %i.next = add i32 %i, 1
  br label %loop

after:
  %Rz = zext i32 %R.cur to i64
  %Lz = zext i32 %L.cur to i64
  %Rsh = shl i64 %Rz, 32
  %preout = or i64 %Rsh, %Lz
  %out = call i64 @permute(i64 %preout, i8* @FP, i64 64, i64 64)
  ret i64 %out
}