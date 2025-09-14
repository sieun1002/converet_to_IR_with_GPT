; ModuleID = 'recovered_main.ll'
source_filename = "recovered_main"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.hex = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.expected = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*) local_unnamed_addr
declare i32 @printf(i8*, ...) local_unnamed_addr
declare i32 @putchar(i32) local_unnamed_addr
declare i32 @puts(i8*) local_unnamed_addr

define i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.i64ptr = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key.i64ptr, align 16
  %key.i64ptr.hi = getelementptr inbounds i64, i64* %key.i64ptr, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key.i64ptr.hi, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in.i64ptr = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in.i64ptr, align 16
  %in.i64ptr.hi = getelementptr inbounds i64, i64* %in.i64ptr, i64 1
  store i64 0x340737E0A2983131, i64* %in.i64ptr.hi, align 8

  ; aes128_encrypt(out, in, key)
  %out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %key.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* nonnull %out.ptr, i8* nonnull %in.ptr, i8* nonnull %key.ptr)

  ; printf("Ciphertext: ")
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt)

  ; for (i = 0; i <= 15; ++i) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop.body, %entry
  %idx = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %idx, 15
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop
  %idx64 = sext i32 %idx to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx64
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %hexfmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.hex, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %hexfmt, i32 %byte.z)
  %inc = add nsw i32 %idx, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after.loop:                                       ; preds = %loop
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.expected, i64 0, i64 0
  call i32 @puts(i8* nonnull %s)

  ret i32 0
}