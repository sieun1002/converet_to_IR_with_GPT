; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1AA9
; Intent: Compute AES-128 encryption of a known test vector and print ciphertext (confidence=0.95). Evidence: aes128_encrypt call with 16-byte key/plaintext constants; hex byte printing loop.
; Preconditions:
; Postconditions:

@__stack_chk_guard = external global i64

@.str_prefix = private unnamed_addr constant [13 x i8] c"Ciphertext: \00"
@.str_fmt = private unnamed_addr constant [5 x i8] c"%02x\00"
@.str_expected = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00"
@.key = private unnamed_addr constant [16 x i8] c"\2B\7E\15\16\28\AE\D2\A6\AB\F7\15\88\09\CF\4F\3C"
@.pt = private unnamed_addr constant [16 x i8] c"\32\43\F6\A8\88\5A\30\8D\31\31\98\A2\E0\37\07\34"

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard, align 8
  %out = alloca [16 x i8], align 16
  %out_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %key_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.key, i64 0, i64 0
  %pt_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.pt, i64 0, i64 0
  call void @aes128_encrypt(i8* %out_i8, i8* %key_ptr, i8* %pt_ptr)
  %prefix_ptr = getelementptr inbounds [13 x i8], [13 x i8]* @.str_prefix, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %prefix_ptr)
  br label %loop

loop:
  %i = phi i32 [ 0, %entry ], [ %inc, %loop_end ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %body, label %after_loop

body:
  %idx = zext i32 %i to i64
  %p = getelementptr inbounds i8, i8* %out_i8, i64 %idx
  %b = load i8, i8* %p, align 1
  %bext = zext i8 %b to i32
  %fmt_ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.str_fmt, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i32 %bext)
  br label %loop_end

loop_end:
  %inc = add nuw nsw i32 %i, 1
  br label %loop

after_loop:
  %nl = call i32 @putchar(i32 10)
  %expected_ptr = getelementptr inbounds [45 x i8], [45 x i8]* @.str_expected, i64 0, i64 0
  %p2 = call i32 @puts(i8* %expected_ptr)
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %guard_ok = icmp eq i64 %guard, %guard2
  br i1 %guard_ok, label %ret, label %stackfail

stackfail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}