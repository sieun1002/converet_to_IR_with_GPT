; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1468
; Intent: DES encrypt one 64-bit block using 16-round Feistel with generated subkeys (confidence=0.92). Evidence: key_schedule/feistel calls, 16-round loop with IP/FP tables
; Preconditions: permute tables @unk_2020 (IP) and @FP must be provided; key_schedule writes 16 i64 subkeys to provided buffer
; Postconditions: returns 64-bit ciphertext

@unk_2020 = external global i8
@FP = external global i8

declare void @key_schedule(i64, i64*) local_unnamed_addr
declare i32 @feistel(i32, i64) local_unnamed_addr
declare i64 @permute(i64, i8*, i32, i32) local_unnamed_addr

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 16
  %subkeys_base = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys_base)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %L0.wide = lshr i64 %ip, 32
  %L0 = trunc i64 %L0.wide to i32
  %R0 = trunc i64 %ip to i32
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, entry ], [ %i.next, %loop.body ]
  %L = phi i32 [ %L0, entry ], [ %L.next, %loop.body ]
  %R = phi i32 [ %R0, entry ], [ %R.next, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx64 = zext i32 %i to i64
  %subptr = getelementptr inbounds i64, i64* %subkeys_base, i64 %idx64
  %subkey = load i64, i64* %subptr, align 8
  %F = call i32 @feistel(i32 %R, i64 %subkey)
  %newR = xor i32 %L, %F
  %L.next = %R
  %R.next = %newR
  %i.next = add i32 %i, 1
  br label %loop.cond

loop.end:
  %R64 = zext i32 %R to i64
  %Rsh = shl i64 %R64, 32
  %L64 = zext i32 %L to i64
  %preout = or i64 %Rsh, %L64
  %out = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)
  ret i64 %out
}