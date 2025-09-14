; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1AA9
; Intent: AES-128 encrypt a fixed test vector and print the ciphertext (confidence=0.98). Evidence: Key/plaintext match FIPS-197 example; expected ciphertext literal matches.
; Preconditions: aes128_encrypt(out, key, in) implements AES-128 ECB for 16-byte block.
; Postconditions: Returns 0; prints ciphertext twice (once computed, once hardcoded).

; Only the necessary external declarations:
declare void @aes128_encrypt(i8*, i8*, i8*)
declare i32 @_printf(i8*, ...)
declare i32 @_putchar(i32)
declare i32 @_puts(i8*)
declare void @___stack_chk_fail()
declare i64 @__stack_chk_guard

@.str_ct = private unnamed_addr constant [13 x i8] c"Ciphertext: \00", align 1
@.str_hex = private unnamed_addr constant [5 x i8] c"%02x\00", align 1
@.str_full = private unnamed_addr constant [45 x i8] c"Ciphertext: 3925841d02dc09fbdc118597196a0b32\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %canary = alloca i64, align 8
  %out = alloca [16 x i8], align 16
  %key = alloca [16 x i8], align 16
  %plain = alloca [16 x i8], align 16
  %i = alloca i32, align 4

  ; stack protector prologue
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8

  ; key = 32 43 F6 A8 88 5A 30 8D 31 31 98 A2 E0 37 07 34
  %key_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %key, i64 0, i64 0
  %key_i64 = bitcast i8* %key_i8 to i64*
  store i64 0x8D305A88A8F64332, i64* %key_i64, align 8
  %key_hi_ptr_i8 = getelementptr inbounds i8, i8* %key_i8, i64 8
  %key_hi_ptr = bitcast i8* %key_hi_ptr_i8 to i64*
  store i64 0x340737E0A2983131, i64* %key_hi_ptr, align 8

  ; plaintext = 2b 7e 15 16 28 ae d2 a6 ab f7 15 88 09 cf 4f 3c
  %plain_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %plain, i64 0, i64 0
  %plain_i64 = bitcast i8* %plain_i8 to i64*
  store i64 0xA6D2AE2816157E2B, i64* %plain_i64, align 8
  %plain_hi_ptr_i8 = getelementptr inbounds i8, i8* %plain_i8, i64 8
  %plain_hi_ptr = bitcast i8* %plain_hi_ptr_i8 to i64*
  store i64 0x3C4FCF098815F7AB, i64* %plain_hi_ptr, align 8

  ; out buffer pointer
  %out_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %out, i64 0, i64 0

  ; aes128_encrypt(out, key, in)
  call void @aes128_encrypt(i8* %out_i8, i8* %key_i8, i8* %plain_i8)

  ; printf("Ciphertext: ")
  %ct_ptr = getelementptr inbounds [13 x i8], [13 x i8]* @.str_ct, i64 0, i64 0
  %call_printf_hdr = call i32 (i8*, ...) @_printf(i8* %ct_ptr)

  ; for (i = 0; i <= 15; i++) printf("%02x", out[i]);
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %iv = load i32, i32* %i, align 4
  %cmp = icmp sle i32 %iv, 15
  br i1 %cmp, label %body, label %after

body:
  %idxext = zext i32 %iv to i64
  %byte_ptr = getelementptr inbounds i8, i8* %out_i8, i64 %idxext
  %byte = load i8, i8* %byte_ptr, align 1
  %byte_zext = zext i8 %byte to i32
  %hex_ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.str_hex, i64 0, i64 0
  %call_printf_hex = call i32 (i8*, ...) @_printf(i8* %hex_ptr, i32 %byte_zext)
  %inc = add i32 %iv, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after:
  ; putchar('\n')
  %call_putchar = call i32 @_putchar(i32 10)
  ; puts("Ciphertext: 3925841d02dc09fbdc118597196a0b32")
  %full_ptr = getelementptr inbounds [45 x i8], [45 x i8]* @.str_full, i64 0, i64 0
  %call_puts = call i32 @_puts(i8* %full_ptr)

  ; epilogue / stack protector check
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok = icmp eq i64 %saved, %guard1
  br i1 %ok, label %ret, label %stackfail

stackfail:
  call void @___stack_chk_fail()
  unreachable

ret:
  ret i32 0
}