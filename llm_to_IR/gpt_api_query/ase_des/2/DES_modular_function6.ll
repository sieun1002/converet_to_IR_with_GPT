; ModuleID = 'des.ll'

@unk_2020 = external constant [64 x i8], align 1
@FP = external constant [64 x i8], align 1
@__stack_chk_guard = external thread_local(initialexec) global i64

declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail() noreturn

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  %guardslot = alloca i64, align 8
  %subkeys = alloca [16 x i64], align 16
  %l = alloca i32, align 4
  %r = alloca i32, align 4
  %i = alloca i32, align 4

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %guardslot, align 8

  %subkeys_ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys_ptr)

  %ip_table_ptr = getelementptr inbounds [64 x i8], [64 x i8]* @unk_2020, i64 0, i64 0
  %ip = call i64 @permute(i64 %block, i8* %ip_table_ptr, i32 64, i32 64)

  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32
  store i32 %L0, i32* %l, align 4
  store i32 %R0, i32* %r, align 4

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sgt i32 %iv, 15
  br i1 %cmp, label %after, label %body

body:
  %idx = sext i32 %iv to i64
  %keyptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idx
  %subk = load i64, i64* %keyptr, align 8
  %rval = load i32, i32* %r, align 4
  %f = call i32 @feistel(i32 %rval, i64 %subk)
  %lval = load i32, i32* %l, align 4
  %t = xor i32 %lval, %f
  store i32 %rval, i32* %l, align 4
  store i32 %t, i32* %r, align 4
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  %rfin = load i32, i32* %r, align 4
  %lfin = load i32, i32* %l, align 4
  %r64 = zext i32 %rfin to i64
  %l64 = zext i32 %lfin to i64
  %sh = shl i64 %r64, 32
  %pre = or i64 %sh, %l64

  %fp_table_ptr = getelementptr inbounds [64 x i8], [64 x i8]* @FP, i64 0, i64 0
  %out = call i64 @permute(i64 %pre, i8* %fp_table_ptr, i32 64, i32 64)

  %guard_loaded = load i64, i64* %guardslot, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard_loaded, %guard2
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i64 %out
}