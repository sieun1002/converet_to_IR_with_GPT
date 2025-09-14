; ModuleID = 'main_from_binary'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.hex = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.out = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %ct = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  store [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], [16 x i8]* %key, align 16

  ; pt = 3243f6a8885a308d313198a2e0370734
  store [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], [16 x i8]* %pt, align 16

  %ct_p = getelementptr inbounds [16 x i8], [16 x i8]* %ct, i64 0, i64 0
  %pt_p = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %key_p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0

  call void @aes128_encrypt(i8* %ct_p, i8* %pt_p, i8* %key_p)

  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:
  %idx = sext i32 %iv to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %ct, i64 0, i64 %idx
  %b = load i8, i8* %byteptr, align 1
  %bext = zext i8 %b to i32
  %fmt2 = getelementptr inbounds [4 x i8], [4 x i8]* @.str.hex, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %bext)
  %next = add i32 %iv, 1
  store i32 %next, i32* %i, align 4
  br label %loop

after:
  call i32 @putchar(i32 10)
  %out = getelementptr inbounds [45 x i8], [45 x i8]* @.str.out, i64 0, i64 0
  call i32 @puts(i8* %out)
  ret i32 0
}