; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1935
; Intent: AES-128 test vector encryption and print result (confidence=0.97). Evidence: constants match NIST AES-128 key/plaintext; prints expected ciphertext.
; Preconditions: none
; Postconditions: returns 0 after printing ciphertext bytes and expected reference line

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @aes128_encrypt(i8*, i8*, i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key_i64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key_i64, align 16
  %key_i64_hi = getelementptr inbounds i64, i64* %key_i64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key_i64_hi, align 8

  ; pt = 3243f6a8885a308d313198a2e0370734
  %pt_i64 = bitcast [16 x i8]* %pt to i64*
  store i64 0x8D305A88A8F64332, i64* %pt_i64, align 16
  %pt_i64_hi = getelementptr inbounds i64, i64* %pt_i64, i64 1
  store i64 0x340737E0A2983131, i64* %pt_i64_hi, align 8

  ; aes128_encrypt(out, pt, key)
  %out_i8 = bitcast [16 x i8]* %out to i8*
  %pt_i8 = bitcast [16 x i8]* %pt to i8*
  %key_i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out_i8, i8* %pt_i8, i8* %key_i8)

  ; printf("Ciphertext: ")
  %0 = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %0)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %body, %entry
  %1 = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %1, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx.ext = zext i32 %1 to i64
  %eltptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %b = load i8, i8* %eltptr, align 1
  %b32 = zext i8 %b to i32
  %2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %2, i32 %b32)
  %inc = add nsw i32 %1, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  call i32 @putchar(i32 10)
  %3 = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %3)
  ret i32 0
}