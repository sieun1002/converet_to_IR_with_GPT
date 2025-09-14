; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1747
; Intent: perform DES encryption on a known test vector and print the result (confidence=0.92). Evidence: constants 0x133457799BBCDFF1/0x0123456789ABCDEF; format string "Ciphertext: %016llX\n"
; Preconditions: des_encrypt implements DES and accepts (plaintext, key) as (i64, i64)
; Postconditions: prints the computed ciphertext and a reference string

; Only the necessary external declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %ct = call i64 @des_encrypt(i64 0x0123456789ABCDEF, i64 0x133457799BBCDFF1)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0, i64 %ct)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @puts(i8* %2)
  ret i32 0
}