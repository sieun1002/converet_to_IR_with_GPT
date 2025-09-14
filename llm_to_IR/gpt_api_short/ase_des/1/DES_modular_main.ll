; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: encrypts a fixed 64-bit block with DES and prints the ciphertext (confidence=0.90). Evidence: call to des_encrypt with two 64-bit immediates; printf/puts with "Ciphertext" messages.
; Preconditions: des_encrypt must be provided at link time.
; Postconditions: prints formatted ciphertext and a reference string.

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

; Only the necessary external declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 81985529216486895, i64 1377975164398079953)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0, i64 %cipher)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @puts(i8* %2)
  ret i32 0
}