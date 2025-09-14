; ModuleID = 'aes_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare extern_weak i64 @__stack_chk_guard
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; stack protector prologue
  %guard.ptr = bitcast i64* @__stack_chk_guard to i64*
  %guard = load i64, i64* %guard.ptr, align 8
  store i64 %guard, i64* %canary, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (stored as two i64 little-endian words)
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64.hi = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64.hi, align 8

  ; in = 3243f6a8885a308d313198a2e0370734 (stored as two i64 little-endian words)
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64.hi = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64.hi, align 8

  ; aes128_encrypt(out, in, key)
  %out.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  %key.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* nonnull %out.ptr, i8* nonnull %in.ptr, i8* nonnull %key.ptr)

  ; printf("Ciphertext: ")
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt)

  ; i = 0
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:
  %idx.ext = sext i32 %iv to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %val = zext i8 %byte to i32
  %fmt.hex = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* nonnull %fmt.hex, i32 %val)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* nonnull %s)

  ; stack protector epilogue
  %guard.cur = load i64, i64* %guard.ptr, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard.cur
  br i1 %ok, label %ret, label %fail

fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}