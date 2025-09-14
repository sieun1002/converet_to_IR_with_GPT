; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

@__stack_chk_guard = external global i64

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
entry:
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %canary = alloca i64, align 8

  ; stack canary setup
  %guard.load = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.load, i64* %canary, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key.q = bitcast [16 x i8]* %key to i64*
  store i64 0xa6d2ae2816157e2b, i64* %key.q, align 16
  %key.q.hi.p = getelementptr inbounds i64, i64* %key.q, i64 1
  store i64 0x3c4fcf098815f7ab, i64* %key.q.hi.p, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in.q = bitcast [16 x i8]* %in to i64*
  store i64 0x8d305a88a8f64332, i64* %in.q, align 16
  %in.q.hi.p = getelementptr inbounds i64, i64* %in.q, i64 1
  store i64 0x340737e0a2983131, i64* %in.q.hi.p, align 8

  ; aes128_encrypt(out, key, in)
  %out.i8 = bitcast [16 x i8]* %out to i8*
  %key.i8 = bitcast [16 x i8]* %key to i8*
  %in.i8 = bitcast [16 x i8]* %in to i8*
  call void @aes128_encrypt(i8* %out.i8, i8* %key.i8, i8* %in.i8)

  ; printf("Ciphertext: ")
  %fmt.p = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.p)

  ; for (i = 0; i <= 15; i++) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx = sext i32 %i.val to i64
  %byte.p = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %byte = load i8, i8* %byte.p, align 1
  %byte.z = zext i8 %byte to i32
  %fmt2.p = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt2.p, i32 %byte.z)
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:
  ; putchar('\n')
  call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %str2.p = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %str2.p)

  ; epilogue with stack canary check
  %guard.now = load i64, i64* @__stack_chk_guard, align 8
  %guard.saved = load i64, i64* %canary, align 8
  %canary.bad = icmp ne i64 %guard.now, %guard.saved
  br i1 %canary.bad, label %stackfail, label %ret

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}