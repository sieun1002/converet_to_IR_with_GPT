; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

@.str.ciph = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.hex = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.ref = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local i32 @puts(i8*)
declare dso_local void @aes128_encrypt(i8*, i8*, i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %pt = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  store [16 x i8] [i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60], [16 x i8]* %key, align 16
  store [16 x i8] [i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52], [16 x i8]* %pt, align 16

  %out.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %pt.p = getelementptr inbounds [16 x i8], [16 x i8]* %pt, i64 0, i64 0
  %key.p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.p, i8* %pt.p, i8* %key.p)

  %ciph.msg = getelementptr inbounds [13 x i8], [13 x i8]* @.str.ciph, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %ciph.msg)

  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:
  %idx = sext i32 %iv to i64
  %b.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %b = load i8, i8* %b.ptr, align 1
  %b32 = zext i8 %b to i32
  %hex.fmt = getelementptr inbounds [5 x i8], [5 x i8]* @.str.hex, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %hex.fmt, i32 %b32)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  call i32 @putchar(i32 10)
  %ref.msg = getelementptr inbounds [45 x i8], [45 x i8]* @.str.ref, i64 0, i64 0
  call i32 @puts(i8* %ref.msg)
  ret i32 0
}