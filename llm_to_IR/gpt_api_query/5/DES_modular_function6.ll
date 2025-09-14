; LLVM IR (LLVM 14) for function des_encrypt translated from the provided disassembly

; External data tables (addresses taken directly)
@unk_2020 = external global i8
@FP       = external global i8

; External functions
declare void @key_schedule(i64 %key, i64* %subkeys_out)
declare i64 @permute(i64 %val, i8* %table, i64 %to_bits, i64 %from_bits)
declare i32 @feistel(i32 %r, i64 %subkey)

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  ; subkeys[16]
  %subkeys = alloca [16 x i64], align 16
  %subkeys_ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0

  ; Generate round keys
  call void @key_schedule(i64 %key, i64* %subkeys_ptr)

  ; Initial permutation
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i64 64, i64 64)

  ; Split into L (upper 32) and R (lower 32)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32

  ; Initialize loop variables
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  store i32 %L0, i32* %L, align 4
  store i32 %R0, i32* %R, align 4
  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  ; Load subkey[i]
  %idxz = sext i32 %iv to i64
  %kptr = getelementptr inbounds i64, i64* %subkeys_ptr, i64 %idxz
  %k = load i64, i64* %kptr, align 8

  ; f = feistel(R, k)
  %Rval = load i32, i32* %R, align 4
  %f = call i32 @feistel(i32 %Rval, i64 %k)

  ; new values
  %Lval = load i32, i32* %L, align 4
  %newR = xor i32 %Lval, %f

  ; L = R; R = L xor f
  store i32 %Rval, i32* %L, align 4
  store i32 %newR, i32* %R, align 4

  ; i++
  %inc = add i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  ; Combine as (R << 32) | L
  %Lf = load i32, i32* %L, align 4
  %Rf = load i32, i32* %R, align 4
  %L64 = zext i32 %Lf to i64
  %R64 = zext i32 %Rf to i64
  %Rshift = shl i64 %R64, 32
  %preout = or i64 %Rshift, %L64

  ; Final permutation
  %out = call i64 @permute(i64 %preout, i8* @FP, i64 64, i64 64)
  ret i64 %out
}