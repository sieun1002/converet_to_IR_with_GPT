; ModuleID = 'binary_to_ir'
source_filename = "binary_to_ir"
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64

@.str_ciphertext = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str_hex        = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str_full       = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8* noundef, i8* noundef, i8* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)
declare i32 @puts(i8* noundef)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %canary = alloca i64, align 8
  %out    = alloca [16 x i8], align 16
  %in     = alloca [16 x i8], align 16
  %key    = alloca [16 x i8], align 16
  %i      = alloca i32, align 4

  ; stack protector prologue
  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %canary, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.vec.ptr = bitcast [16 x i8]* %key to <16 x i8>*
  store <16 x i8> <i8 43, i8 126, i8 21, i8 22, i8 40, i8 174, i8 210, i8 166, i8 171, i8 247, i8 21, i8 136, i8 9, i8 207, i8 79, i8 60>, <16 x i8>* %key.vec.ptr, align 16

  ; in = 3243f6a8885a308d313198a2e0370734
  %in.vec.ptr = bitcast [16 x i8]* %in to <16 x i8>*
  store <16 x i8> <i8 50, i8 67, i8 246, i8 168, i8 136, i8 90, i8 48, i8 141, i8 49, i8 49, i8 152, i8 162, i8 224, i8 55, i8 7, i8 52>, <16 x i8>* %in.vec.ptr, align 16

  ; aes128_encrypt(out, in, key)
  %out.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %in.p  = getelementptr inbounds [16 x i8], [16 x i8]* %in,  i64 0, i64 0
  %key.p = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %out.p, i8* %in.p, i8* %key.p)

  ; printf("Ciphertext: ")
  %msg = getelementptr inbounds [13 x i8], [13 x i8]* @.str_ciphertext, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %msg)

  ; for (i = 0; i <= 0xF; ++i) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cond = icmp sle i32 %iv, 15
  br i1 %cond, label %loop.body, label %loop.end

loop.body:
  %idx = sext i32 %iv to i64
  %bptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %b = load i8, i8* %bptr, align 1
  %bz = zext i8 %b to i32
  %hex = getelementptr inbounds [4 x i8], [4 x i8]* @.str_hex, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %hex, i32 %bz)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

loop.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %full = getelementptr inbounds [45 x i8], [45 x i8]* @.str_full, i64 0, i64 0
  call i32 @puts(i8* %full)

  ; stack protector epilogue
  %g.cur = load i64, i64* @__stack_chk_guard, align 8
  %g.saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %g.saved, %g.cur
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}