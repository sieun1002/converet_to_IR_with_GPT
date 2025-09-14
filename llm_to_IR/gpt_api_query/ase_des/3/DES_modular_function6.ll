; ModuleID = 'des_module'
target triple = "x86_64-unknown-linux-gnu"

@unk_2020 = external global [64 x i8]
@FP = external global [64 x i8]

declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  %subkeys = alloca [16 x i64], align 16

  ; key_schedule(key, subkeys)
  %subkeys_ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys_ptr)

  ; Initial permutation
  %iptbl.ptr = getelementptr inbounds [64 x i8], [64 x i8]* @unk_2020, i64 0, i64 0
  %ip = call i64 @permute(i64 %block, i8* %iptbl.ptr, i32 64, i32 64)

  ; Split into left (high 32) and right (low 32)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32

  ; Initialize loop variables
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 %L0, i32* %L, align 4
  store i32 %R0, i32* %R, align 4
  store i32 0, i32* %i, align 4

loop:
  %i.val = load i32, i32* %i, align 4
  %cond = icmp sle i32 %i.val, 15
  br i1 %cond, label %round, label %after

round:
  ; load subkey[i]
  %idx64 = sext i32 %i.val to i64
  %sk.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idx64
  %sk = load i64, i64* %sk.ptr, align 8

  ; F = feistel(R, subkey[i])
  %R.cur = load i32, i32* %R, align 4
  %F = call i32 @feistel(i32 %R.cur, i64 %sk)

  ; newR = L xor F; L = R; R = newR
  %L.cur = load i32, i32* %L, align 4
  %newR = xor i32 %L.cur, %F
  store i32 %R.cur, i32* %L, align 4
  store i32 %newR, i32* %R, align 4

  ; i++
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after:
  ; Preoutput: (R << 32) | L
  %L.fin = load i32, i32* %L, align 4
  %R.fin = load i32, i32* %R, align 4
  %R64 = zext i32 %R.fin to i64
  %L64 = zext i32 %L.fin to i64
  %Rsh = shl i64 %R64, 32
  %preout = or i64 %Rsh, %L64

  ; Final permutation
  %fptbl.ptr = getelementptr inbounds [64 x i8], [64 x i8]* @FP, i64 0, i64 0
  %out = call i64 @permute(i64 %preout, i8* %fptbl.ptr, i32 64, i32 64)
  ret i64 %out
}