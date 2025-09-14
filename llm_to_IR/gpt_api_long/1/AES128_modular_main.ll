; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1935
; Intent: AES-128 test: encrypt NIST vector and print ciphertext (confidence=0.95). Evidence: AES key/plaintext constants; prints expected hex string
; Preconditions: aes128_encrypt(out, in, key) operates on 16-byte buffers
; Postconditions: Prints ciphertext in hex and the known expected string

@__stack_chk_guard = external global i64
@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [4 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %guard = load i64, i64* @__stack_chk_guard
  %out = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64_1 = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64_1, align 8

  ; in = 3243f6a8885a308d313198a2e0370734
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64_1 = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64_1, align 8

  ; aes128_encrypt(out, in, key)
  %out_i8 = bitcast [16 x i8]* %out to i8*
  %in_i8 = bitcast [16 x i8]* %in to i8*
  %key_i8 = bitcast [16 x i8]* %key to i8*
  call void @aes128_encrypt(i8* %out_i8, i8* %in_i8, i8* %key_i8)

  ; print header
  %hdrptr = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %hdrptr)
  br label %for.cond

for.cond:
  %i = phi i32 [ 0, %entry ], [ %inc, %for.body ]
  %cmp = icmp sle i32 %i, 15
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %idx.ext = zext i32 %i to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx.ext
  %b = load i8, i8* %byteptr, align 1
  %bext = zext i8 %b to i32
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %bext)
  %inc = add nsw i32 %i, 1
  br label %for.cond

for.end:
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %s)
  %guard2 = load i64, i64* @__stack_chk_guard
  %ok = icmp eq i64 %guard, %guard2
  br i1 %ok, label %ret, label %stack_fail

stack_fail:
  call void @__stack_chk_fail()
  unreachable

ret:
  ret i32 0
}