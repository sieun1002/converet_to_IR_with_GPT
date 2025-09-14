; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: DES demo: encrypt a known plaintext with a known key and print the ciphertext (confidence=0.98). Evidence: constants match standard DES test vector; prints both computed and expected ciphertext.
; Preconditions: external des_encrypt(i64 plaintext, i64 key) is available.
; Postconditions: prints ciphertext via printf and puts; returns 0.

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00"
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00"

declare i64 @des_encrypt(i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_puts(i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %res = call i64 @des_encrypt(i64 81985529216486895, i64 1383827165325090801)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @_printf(i8* %0, i64 %res)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @_puts(i8* %2)
  ret i32 0
}