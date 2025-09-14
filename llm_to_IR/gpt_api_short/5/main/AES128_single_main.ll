; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1AA9
; Intent: AES-128 example; encrypt and print ciphertext (confidence=0.96). Evidence: aes128_encrypt call with 128-bit key/plaintext test vector; prints expected hex string.
; Preconditions: None
; Postconditions: Returns 0; prints ciphertext twice (computed, then reference).

@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@a02x = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@s = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare i32 @_puts(i8*)
declare void @___stack_chk_fail()

define dso_local i32 @main() local_unnamed_addr {
entry:
  %saved_canary = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %saved_canary, align 8
  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64.hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64.hi, align 8
  ; in = 3243f6a8885a308d313198a2e0370734
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64.hi = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64.hi, align 8
  ; aes128_encrypt(out, in, key)
  %out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %key.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.ptr, i8* %in.ptr, i8* %key.ptr)
  ; printf("Ciphertext: ")
  %fmt0 = getelementptr inbounds [13 x i8], [13 x i8]* @format, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @_printf(i8* %fmt0)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %1 = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %1, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %idx.ext = sext i32 %1 to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @a02x, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @_printf(i8* %fmt1, i32 %byte.z)
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call_putchar = call i32 @_putchar(i32 10)
  %s.ptr = getelementptr inbounds [45 x i8], [45 x i8]* @s, i64 0, i64 0
  %call_puts = call i32 @_puts(i8* %s.ptr)
  %guard.reload = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %saved_canary, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.reload
  br i1 %guard.ok, label %ret, label %stackfail

stackfail:                                        ; preds = %loop.end
  call void @___stack_chk_fail()
  unreachable

ret:                                              ; preds = %loop.end
  ret i32 0
}