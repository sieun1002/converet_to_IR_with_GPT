; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64
@unk_2020 = external global i8
@FP = external global i8

declare void @key_schedule(i8* nocapture, i64* nocapture)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail()

define dso_local i64 @des_encrypt(i64 %block, i8* %key) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %subkeys = alloca [16 x i64], align 16
  %subkeys.decay = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i8* %key, i64* %subkeys.decay)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32
  br label %loop.check

loop.check:                                        ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %L = phi i32 [ %L0, %entry ], [ %R, %loop.body ]
  %R = phi i32 [ %R0, %entry ], [ %newR, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                         ; preds = %loop.check
  %idx = zext i32 %i to i64
  %sk.ptr = getelementptr inbounds i64, i64* %subkeys.decay, i64 %idx
  %sk = load i64, i64* %sk.ptr, align 8
  %F = call i32 @feistel(i32 %R, i64 %sk)
  %newR = xor i32 %L, %F
  %inc = add i32 %i, 1
  br label %loop.check

after.loop:                                        ; preds = %loop.check
  %Rz = zext i32 %R to i64
  %Lz = zext i32 %L to i64
  %Rsh = shl i64 %Rz, 32
  %pre_fp = or i64 %Rsh, %Lz
  %fp = call i64 @permute(i64 %pre_fp, i8* @FP, i32 64, i32 64)
  %guard.end = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard.end
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %after.loop
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %after.loop
  ret i64 %fp
}