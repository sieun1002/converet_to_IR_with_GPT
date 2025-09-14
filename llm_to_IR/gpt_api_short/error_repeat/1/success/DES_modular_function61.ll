; ModuleID = 'des_encrypt'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: des_encrypt ; Address: 0x1468
; Intent: DES 64-bit block encryption (16-round Feistel, IP/FP permutations) (confidence=0.95). Evidence: calls to key_schedule, permute(64,64) with tables unk_2020/FP, 16-round feistel loop.
; Preconditions: External permutation tables @unk_2020 (IP) and @FP (FP) and helpers must be defined.
; Postconditions: Returns the 64-bit ciphertext of the input block under the given key.

; Only the necessary external declarations:
declare void @key_schedule(i64, i64*)
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @feistel(i32, i64)
declare void @__stack_chk_fail()

@unk_2020 = external global i8, align 1
@FP = external global i8, align 1
@__stack_chk_guard = external global i64, align 8

define dso_local i64 @des_encrypt(i64 %input, i64 %key) local_unnamed_addr {
entry:
  %sched = alloca [16 x i64], align 16
  %canary = alloca i64, align 8
  %L = alloca i32, align 4
  %R = alloca i32, align 4
  %i = alloca i32, align 4

  ; stack canary prologue
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; key schedule
  %sched0 = getelementptr inbounds [16 x i64], [16 x i64]* %sched, i64 0, i64 0
  call void @key_schedule(i64 %key, i64* %sched0)

  ; initial permutation
  %ip = call i64 @permute(i64 %input, i8* @unk_2020, i32 64, i32 64)

  ; split into halves
  %Lshift = lshr i64 %ip, 32
  %Lmask = and i64 %Lshift, 4294967295
  %L0 = trunc i64 %Lmask to i32
  %R0 = trunc i64 %ip to i32
  store i32 %L0, i32* %L, align 4
  store i32 %R0, i32* %R, align 4

  ; rounds
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx64 = sext i32 %iv to i64
  %kptr = getelementptr inbounds [16 x i64], [16 x i64]* %sched, i64 0, i64 %idx64
  %subk = load i64, i64* %kptr, align 8
  %Rcur = load i32, i32* %R, align 4
  %f = call i32 @feistel(i32 %Rcur, i64 %subk)
  %Lcur = load i32, i32* %L, align 4
  %newR = xor i32 %Lcur, %f
  store i32 %Rcur, i32* %L, align 4
  store i32 %newR, i32* %R, align 4
  %inc = add i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  ; preoutput swap (R||L)
  %Rfin = load i32, i32* %R, align 4
  %Lfin = load i32, i32* %L, align 4
  %R64 = zext i32 %Rfin to i64
  %L64 = zext i32 %Lfin to i64
  %Rsh = shl i64 %R64, 32
  %preout = or i64 %Rsh, %L64

  ; final permutation
  %out = call i64 @permute(i64 %preout, i8* @FP, i32 64, i32 64)

  ; stack canary epilogue
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %guard2, %saved
  br i1 %ok, label %ret, label %stackfail

stackfail:                                        ; preds = %after
  call void @__stack_chk_fail()
  br label %ret

ret:                                              ; preds = %after, %stackfail
  ret i64 %out
}