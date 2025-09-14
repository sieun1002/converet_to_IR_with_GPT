; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1AA9
; Intent: AES-128 ECB encrypt known test vector and print ciphertext (confidence=0.90). Evidence: call aes128_encrypt; prints "Ciphertext:" + hex and known expected string.
; Preconditions: aes128_encrypt implements AES-128 ECB with args (out, in, key), 16-byte each.
; Postconditions: Returns 0 after printing ciphertext twice (byte-wise and as a full string).

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @aes128_encrypt(i8*, i8*, i8*)

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.base = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  %key.p0 = bitcast i8* %key.base to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key.p0, align 16
  %key.base8 = getelementptr inbounds i8, i8* %key.base, i64 8
  %key.p1 = bitcast i8* %key.base8 to i64*
  store i64 0x3C4FCF098815F7AB, i64* %key.p1, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in.base = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %in.p0 = bitcast i8* %in.base to i64*
  store i64 0x8D305A88A8F64332, i64* %in.p0, align 16
  %in.base8 = getelementptr inbounds i8, i8* %in.base, i64 8
  %in.p1 = bitcast i8* %in.base8 to i64*
  store i64 0x340737E0A2983131, i64* %in.p1, align 8

  ; out buffer
  %out.base = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0

  ; aes128_encrypt(out, in, key)
  call void @aes128_encrypt(i8* %out.base, i8* %in.base, i8* %key.base)

  ; printf("Ciphertext: ")
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
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %byte = load i8, i8* %byte.ptr, align 1
  %z = zext i8 %byte to i32
  %fmt2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2, i32 %z)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %s)
  ret i32 0
}