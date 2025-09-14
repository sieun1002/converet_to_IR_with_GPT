; ModuleID = 'recovered'
source_filename = "recovered"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (little-endian stores)
  %key_i64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key_i64, align 8
  %key_i64_1 = getelementptr inbounds i64, i64* %key_i64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key_i64_1, align 8

  ; in = 3243f6a8885a308d313198a2e0370734 (little-endian stores)
  %in_i64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in_i64, align 8
  %in_i64_1 = getelementptr inbounds i64, i64* %in_i64, i64 1
  store i64 0x340737E0A2983131, i64* %in_i64_1, align 8

  ; aes128_encrypt(out, in, key)
  %out_i8 = bitcast [16 x i8]* %out to i8*
  %in_i8 = bitcast [16 x i8]* %in to i8*
  %key_i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out_i8, i8* %in_i8, i8* %key_i8)

  ; printf("Ciphertext: ")
  %pfx = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %pfx)

  ; for (i = 0; i <= 15; ++i) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx64 = sext i32 %iv to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %byte = load i8, i8* %byteptr, align 1
  %byte32 = zext i8 %byte to i32
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %byte32)
  %next = add i32 %iv, 1
  store i32 %next, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str2, i64 0, i64 0
  call i32 @puts(i8* %s)
  ret i32 0
}