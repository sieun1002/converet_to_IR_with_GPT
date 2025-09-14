; ModuleID = 'des_module'
source_filename = "des_module"

@unk_2020 = external global i8
@FP = external global i8
@__stack_chk_guard = external global i64

declare void @key_schedule(i64 %key, i64* %out_subkeys)
declare i64 @permute(i64 %in, i8* %table, i32 %outbits, i32 %inbits)
declare i32 @feistel(i32 %R, i64 %subkey)
declare void @___stack_chk_fail() noreturn

define i64 @des_encrypt(i64 %block, i64 %key) {
entry:
  %guard.slot = alloca i64, align 8
  %subkeys = alloca [16 x i64], align 16
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %guard.slot, align 8

  %subkeys.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys.ptr)

  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %L64 = lshr i64 %ip, 32
  %L0 = trunc i64 %L64 to i32
  %R0 = trunc i64 %ip to i32

  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %L = phi i32 [ %L0, %entry ], [ %L.next, %loop.body ]
  %R = phi i32 [ %R0, %entry ], [ %R.next, %loop.body ]

  %cont = icmp sle i32 %i, 15
  br i1 %cont, label %loop.body, label %after

loop.body:
  %idx64 = sext i32 %i to i64
  %subkey.ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 %idx64
  %subkey.val = load i64, i64* %subkey.ptr, align 8
  %f = call i32 @feistel(i32 %R, i64 %subkey.val)
  %newR = xor i32 %L, %f
  %L.next = %R
  %R.next = %newR
  %i.next = add i32 %i, 1
  br label %loop

after:
  %Rz = zext i32 %R to i64
  %Lz = zext i32 %L to i64
  %high = shl i64 %Rz, 32
  %pre = or i64 %high, %Lz
  %out = call i64 @permute(i64 %pre, i8* @FP, i32 64, i32 64)

  %guard.final = load i64, i64* @__stack_chk_guard, align 8
  %guard.cur = load i64, i64* %guard.slot, align 8
  %ok = icmp eq i64 %guard.cur, %guard.final
  br i1 %ok, label %ret, label %fail

fail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i64 %out
}