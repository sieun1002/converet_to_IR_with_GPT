; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1935
; Intent: AES-128 test driver: encrypts a known plaintext with a known key and prints the ciphertext (confidence=0.92). Evidence: aes128_encrypt(out,key,in) with FIPS-197 test vectors; hex output and expected comparison string.
; Preconditions: aes128_encrypt(i8* out, i8* key, i8* in) is defined and performs AES-128.
; Postconditions: Writes two lines to stdout, returns 0.

@__stack_chk_guard = external global i64

@.str = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str.1 = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str.2 = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()
declare void @aes128_encrypt(i8*, i8*, i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %out = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %in = alloca [16 x i8], align 16
  %i = alloca i32, align 4
  %sc = alloca i64, align 8

  ; stack canary save
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %sc, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c (little-endian 64-bit chunks)
  %key64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key64, align 16
  %key64_hi_ptr = getelementptr inbounds i64, i64* %key64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key64_hi_ptr, align 8

  ; in = 3243f6a8885a308d313198a2e0370734 (little-endian 64-bit chunks)
  %in64 = bitcast [16 x i8]* %in to i64*
  store i64 0x8D305A88A8F64332, i64* %in64, align 16
  %in64_hi_ptr = getelementptr inbounds i64, i64* %in64, i64 1
  store i64 0x340737E0A2983131, i64* %in64_hi_ptr, align 8

  ; out = aes128_encrypt(in, key)
  %out_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0
  %key_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  %in_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %in, i64 0, i64 0
  call void @aes128_encrypt(i8* %out_i8, i8* %key_i8, i8* %in_i8)

  ; printf("Ciphertext: ")
  %pfx = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %pfx)

  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %loop, %entry
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %idx = sext i32 %iv to i64
  %byteptr = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 %idx
  %b = load i8, i8* %byteptr, align 1
  %bz = zext i8 %b to i32
  %fmt = getelementptr inbounds [5 x i8], [5 x i8]* @.str.1, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt, i32 %bz)
  %inc = add nsw i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:                                            ; preds = %loop
  call i32 @putchar(i32 10)
  %s = getelementptr inbounds [45 x i8], [45 x i8]* @.str.2, i64 0, i64 0
  call i32 @puts(i8* %s)

  ; stack canary check and return 0
  %guard_end = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %sc, align 8
  %ok = icmp eq i64 %saved, %guard_end
  br i1 %ok, label %ret, label %fail

fail:                                             ; preds = %after
  call void @__stack_chk_fail()
  unreachable

ret:                                              ; preds = %after
  ret i32 0
}