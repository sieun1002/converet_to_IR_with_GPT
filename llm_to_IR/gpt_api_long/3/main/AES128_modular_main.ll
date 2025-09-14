; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1935
; Intent: Demonstrate AES-128 encryption of a single 16-byte block and print ciphertext (confidence=0.95). Evidence: calls aes128_encrypt; prints 16 bytes as hex with known AES test vector
; Preconditions: aes128_encrypt(dst, src, key) expects 16-byte buffers.
; Postconditions: Writes 16-byte ciphertext to stdout as hex and prints an expected reference line.

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str2 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str3 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %ct = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (little-endian per qword stores)
  %key_i64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key_i64, align 8
  %key_i64_hi = getelementptr inbounds i64, i64* %key_i64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key_i64_hi, align 8

  ; pt = 3243f6a8885a308d313198a2e0370734 (little-endian per qword stores)
  %pt_i64 = bitcast [16 x i8]* %pt to i64*
  store i64 0x8D305A88A8F64332, i64* %pt_i64, align 8
  %pt_i64_hi = getelementptr inbounds i64, i64* %pt_i64, i64 1
  store i64 0x340737E0A2983131, i64* %pt_i64_hi, align 8

  ; aes128_encrypt(ct, pt, key)
  %ct_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %ct, i64 0, i64 0
  %pt_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %key_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %ct_ptr, i8* %pt_ptr, i8* %key_ptr)

  ; printf("Ciphertext: ")
  %fmt_prefix = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %call_printf_prefix = call i32 (i8*, ...) @printf(i8* %fmt_prefix)

  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i = phi i32 [ 0, %entry ], [ %inc, %loop.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %idx.ext = zext i32 %i to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %ct, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %val = zext i8 %byte to i32
  %fmt_hex = getelementptr inbounds [5 x i8], [5 x i8]* @.str2, i64 0, i64 0
  %call_printf_hex = call i32 (i8*, ...) @printf(i8* %fmt_hex, i32 %val)
  %inc = add nsw i32 %i, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call_putchar = call i32 @putchar(i32 10)
  %str_expected = getelementptr inbounds [45 x i8], [45 x i8]* @.str3, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %str_expected)
  ret i32 0
}