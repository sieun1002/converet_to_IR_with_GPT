; ModuleID = 'des_module'
source_filename = "des_module"

@__stack_chk_guard = external thread_local global i64
@unk_2020 = external global i8
@FP = external global i8

declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail() noreturn

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  %subkeys = alloca [16 x i64], align 16
  %canary = alloca i64, align 8
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  %i = alloca i32, align 4

  %g0 = load i64, i64* @__stack_chk_guard
  store i64 %g0, i64* %canary

  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)

  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %ip.hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip.hi to i32
  %R0 = trunc i64 %ip to i32
  store i32 %L0, i32* %L
  store i32 %R0, i32* %R

  store i32 0, i32* %i
  br label %loop

loop:
  %i.val = load i32, i32* %i
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %body, label %after

body:
  %idx = sext i32 %i.val to i64
  %kptr = getelementptr inbounds i64, i64* %subkeys.ptr, i64 %idx
  %k = load i64, i64* %kptr, align 8

  %Rcur = load i32, i32* %R
  %f = call i32 @feistel(i32 %Rcur, i64 %k)

  %Lcur = load i32, i32* %L
  %newR = xor i32 %Lcur, %f

  store i32 %Rcur, i32* %L
  store i32 %newR, i32* %R

  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i
  br label %loop

after:
  %Lfin = load i32, i32* %L
  %Rfin = load i32, i32* %R
  %Rz = zext i32 %Rfin to i64
  %Lz = zext i32 %Lfin to i64
  %Rsh = shl i64 %Rz, 32
  %preout = or i64 %Rsh, %Lz

  %fp = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)

  %g1 = load i64, i64* @__stack_chk_guard
  %gsaved = load i64, i64* %canary
  %ok = icmp eq i64 %g1, %gsaved
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %fp
}