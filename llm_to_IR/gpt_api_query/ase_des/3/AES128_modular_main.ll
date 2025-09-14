; ModuleID = 'aes_main'
target triple = "x86_64-unknown-linux-gnu"

@.str_ciphertext_label = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str_fmt = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str_expected = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  ; buffers
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; initialize key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.i128 = bitcast [16 x i8]* %key to i128*
  store i128 0x3C4FCF098815F7ABA6D2AE2816157E2B, i128* %key.i128, align 16

  ; initialize plaintext = 3243f6a8885a308d313198a2e0370734
  %in.i128 = bitcast [16 x i8]* %in to i128*
  store i128 0x340737E0A29831318D305A88A8F64332, i128* %in.i128, align 16

  ; call aes128_encrypt(out, in, key)
  %out.i8 = bitcast [16 x i8]* %out to i8*
  %in.i8 = bitcast [16 x i8]* %in to i8*
  %key.i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out.i8, i8* %in.i8, i8* %key.i8)

  ; printf("Ciphertext: ")
  %fmt_ct = getelementptr inbounds [13 x i8], [13 x i8]* @.str_ciphertext_label, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_ct)

  ; for (i = 0; i < 16; ++i) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp slt i32 %i.val, 16
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx64 = sext i32 %i.val to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt_hex = getelementptr inbounds [5 x i8], [5 x i8]* @.str_fmt, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt_hex, i32 %byte.z)
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  ; newline
  call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %exp.ptr = getelementptr inbounds [45 x i8], [45 x i8]* @.str_expected, i64 0, i64 0
  call i32 @puts(i8* %exp.ptr)

  ret i32 0
}