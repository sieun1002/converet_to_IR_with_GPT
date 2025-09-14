; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x15CB
; Intent: DES encrypt a known test vector and print the ciphertext (confidence=0.95). Evidence: Known DES key/plaintext constants; matching expected ciphertext string.
; Preconditions:
; Postconditions:

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 0x0123456789ABCDEF, i64 0x133457799BBCDFF1)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0, i64 %cipher)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @puts(i8* %2)
  ret i32 0
}