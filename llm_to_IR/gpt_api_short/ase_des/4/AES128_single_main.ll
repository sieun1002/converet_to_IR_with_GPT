; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1AA9
; Intent: AES-128 encrypt a single 16-byte block and print the ciphertext in hex plus an expected string (confidence=0.93). Evidence: aes128_encrypt call with 16-byte key/plaintext constants; hex-print loop over 16 bytes and prints "Ciphertext: ".
; Preconditions: aes128_encrypt implements: void aes128_encrypt(uint8_t* out, const uint8_t* in, const uint8_t* key)
; Postconditions: Returns 0; calls __stack_chk_fail on canary mismatch

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare i32 @puts(i8*)
declare void @__stack_chk_fail()
declare void @aes128_encrypt(i8*, i8*, i8*)
@__stack_chk_guard = external global i64

@format = private unnamed_addr constant [13 x i8] c"Ciphertext: \00"
@a02x = private unnamed_addr constant [4 x i8] c"%02x\00"
@s = private unnamed_addr constant [46 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00"

define dso_local i32 @main() local_unnamed_addr {
entry:
  %canary.save = alloca i64, align 8
  %cipher = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %plain = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; stack canary setup
  %guard.init = load i64, i64* @__stack_chk_guard
  store i64 %guard.init, i64* %canary.save, align 8

  ; key = 2b7e151628aed2a6abf7158809cf4f3c
  %key_i64 = bitcast [16 x i8]* %key to i64*
  store i64 0xA6D2AE2816157E2B, i64* %key_i64, align 16
  %key_i64_hi = getelementptr inbounds i64, i64* %key_i64, i64 1
  store i64 0x3C4FCF098815F7AB, i64* %key_i64_hi, align 8

  ; plaintext = 3243f6a8885a308d313198a2e0370734
  %plain_i64 = bitcast [16 x i8]* %plain to i64*
  store i64 0x8D305A88A8F64332, i64* %plain_i64, align 16
  %plain_i64_hi = getelementptr inbounds i64, i64* %plain_i64, i64 1
  store i64 0x340737E0A2983131, i64* %plain_i64_hi, align 8

  ; aes128_encrypt(&cipher, &plain, &key)
  %cipher_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %cipher, i64 0, i64 0
  %plain_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %plain, i64 0, i64 0
  %key_ptr = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  call void @aes128_encrypt(i8* %cipher_ptr, i8* %plain_ptr, i8* %key_ptr)

  ; printf("Ciphertext: ");
  %fmt0 = getelementptr inbounds [13 x i8], [13 x i8]* @format, i64 0, i64 0
  %call_printf0 = call i32 (i8*, ...) @printf(i8* %fmt0)

  ; for (i = 0; i <= 15; ++i) printf("%02x", cipher[i]);
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                         ; preds = %loop.body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %i.val, 15
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                         ; preds = %loop.cond
  %idx.ext = sext i32 %i.val to i64
  %byte.ptr = getelementptr inbounds [16 x i8], [16 x i8]* %cipher, i64 0, i64 %idx.ext
  %byte = load i8, i8* %byte.ptr, align 1
  %byte.z = zext i8 %byte to i32
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @a02x, i64 0, i64 0
  %call_printf1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %byte.z)
  %inc = add nsw i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

loop.end:                                          ; preds = %loop.cond
  ; putchar('\n');
  %call_putchar = call i32 @putchar(i32 10)

  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32");
  %s.ptr = getelementptr inbounds [46 x i8], [46 x i8]* @s, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %s.ptr)

  ; stack canary check and return 0
  %guard.fini = load i64, i64* @__stack_chk_guard
  %guard.saved = load i64, i64* %canary.save, align 8
  %guard.ok = icmp eq i64 %guard.saved, %guard.fini
  br i1 %guard.ok, label %ret, label %stackfail

stackfail:                                         ; preds = %loop.end
  call void @__stack_chk_fail()
  unreachable

ret:                                               ; preds = %loop.end
  ret i32 0
}