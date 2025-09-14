; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1935
; Intent: AES-128 test vector encrypt and print ciphertext (confidence=0.89). Evidence: calls aes128_encrypt; prints hex and known FIPS-197 result string.
; Preconditions: aes128_encrypt(out,in,key) performs AES-128 on 16-byte buffers.
; Postconditions: prints ciphertext twice (hex-bytes then expected string) and returns 0.

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

@__stack_chk_guard = external global i64

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)
declare void @aes128_encrypt(i8*, i8*, i8*) local_unnamed_addr
declare i32 @_printf(i8*, ...) local_unnamed_addr
declare i32 @_putchar(i32) local_unnamed_addr
declare i32 @_puts(i8*) local_unnamed_addr
declare void @___stack_chk_fail() local_unnamed_addr

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %canary = alloca i64, align 8
  %0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %0, i64* %canary, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 11951704006405434219, i64* %key64, align 16           ; 0xA6D2AE2816157E2B
  %key64hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 4342562893059147435, i64* %key64hi, align 8           ; 0x3C4FCF098815F7AB

  ; in = 3243f6a8885a308d313198a2e0370734
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 -8529302243068689486, i64* %in64, align 16            ; 0x8D305A88A8F64332
  %in64hi = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 3766627727951012529, i64* %in64hi, align 8            ; 0x340737E0A2983131

  ; aes128_encrypt(out, in, key)
  %outp = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %inp = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %keyp = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %outp, i8* %inp, i8* %keyp)

  ; printf("Ciphertext: ")
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i8*, ...) @_printf(i8* %fmt)

  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %1 = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %1, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                         ; preds = %loop.cond
  %idx.ext = zext i32 %1 to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %val = zext i8 %byte to i32
  %fmt2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  %callp2 = call i32 (i8*, ...) @_printf(i8* %fmt2, i32 %val)
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                          ; preds = %loop.cond
  %callputc = call i32 @_putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  %callputs = call i32 @_puts(i8* %s)

  %g1 = load i64, i64* %canary, align 8
  %g2 = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %g1, %g2
  br i1 %ok, label %ret, label %stackfail

stackfail:                                         ; preds = %loop.end
  call void @___stack_chk_fail()
  unreachable

ret:                                               ; preds = %loop.end
  ret i32 0
}