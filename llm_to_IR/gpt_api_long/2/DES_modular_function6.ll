; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt  ; Address: 0x1468
; Intent: DES block encryption of a 64-bit block using 16-round Feistel with key schedule, initial and final permutations (confidence=0.95). Evidence: calls to key_schedule/feistel, 16-round loop, permute with IP/FP tables.

@unk_2020 = external global i8
@FP = external global i8
@__stack_chk_guard = external global i64

declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail()

define dso_local i64 @des_encrypt(i64 %block, i64 %key) local_unnamed_addr {
entry:
  %subkeys = alloca [16 x i64], align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  %subkeys_ptr = getelementptr inbounds [16 x i64], [16 x i64]* %subkeys, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %subkeys_ptr)
  %ip = call i64 @permute(i64 %block, i8* @unk_2020, i32 64, i32 64)
  %ip_hi = lshr i64 %ip, 32
  %L0 = trunc i64 %ip_hi to i32
  %R0 = trunc i64 %ip to i32
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %loop.body ]
  %Lcur = phi i32 [ %L0, %entry ], [ %Lnext, %loop.body ]
  %Rcur = phi i32 [ %R0, %entry ], [ %Rnext, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %after

loop.body:                                        ; preds = %loop.cond
  %idx64 = zext i32 %i to i64
  %skptr = getelementptr inbounds i64, i64* %subkeys_ptr, i64 %idx64
  %subk = load i64, i64* %skptr, align 8
  %f = call i32 @feistel(i32 %Rcur, i64 %subk)
  %Lnext = %Rcur
  %Rnext = xor i32 %Lcur, %f
  %i.next = add i32 %i, 1
  br label %loop.cond

after:                                            ; preds = %loop.cond
  %R64 = zext i32 %Rcur to i64
  %L64 = zext i32 %Lcur to i64
  %Rshift = shl i64 %R64, 32
  %combined = or i64 %Rshift, %L64
  %fp = call i64 @permute(i64 %combined, i8* @FP, i32 64, i32 64)
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %guard0, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i64 %fp
}