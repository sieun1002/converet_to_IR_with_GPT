; ModuleID = 'des.ll'
source_filename = "des"

@unk_2020 = external global i8
@FP       = external global i8

declare void @key_schedule(i8* %key, i64* %out_subkeys)
declare i64 @permute(i64 %in, i8* %table, i32 %outbits, i32 %inbits)
declare i32 @feistel(i32 %r, i64 %subkey)

define i64 @des_encrypt(i64 %block, i8* %key) {
entry:
  %subkeys = alloca [16 x i64], align 16
  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0

  call void @key_schedule(i8* %key, i64* %subkeys.ptr)

  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)

  %ip_hi = lshr i64 %ip, 32
  %L.init = trunc i64 %ip_hi to i32
  %R.init = trunc i64 %ip to i32

  br label %loop

loop:
  %L = phi i32 [ %L.init, %entry ], [ %R, %body ]
  %R = phi i32 [ %R.init, %entry ], [ %newR, %body ]
  %i = phi i32 [ 0, %entry ], [ %inc, %body ]

  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %after

body:
  %i64 = sext i32 %i to i64
  %kptr = getelementptr inbounds i64, i64* %subkeys.ptr, i64 %i64
  %k = load i64, i64* %kptr, align 8

  %f = call i32 @feistel(i32 %R, i64 %k)
  %newR = xor i32 %L, %f
  %inc = add nsw i32 %i, 1
  br label %loop

after:
  %R64 = zext i32 %R to i64
  %L64 = zext i32 %L to i64
  %Rsh = shl i64 %R64, 32
  %combined = or i64 %Rsh, %L64

  %fp = call i64 @permute(i64 %combined, i8* @FP, i32 64, i32 64)
  ret i64 %fp
}