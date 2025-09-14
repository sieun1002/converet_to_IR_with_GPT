; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: Encrypt a fixed 64-bit plaintext with a fixed 64-bit DES key, print ciphertext and a reference string (confidence=0.98). Evidence: call to des_encrypt, format "Ciphertext: %016llX\n"
; Preconditions: none
; Postconditions: prints two lines and returns 0

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

; Only the necessary external declarations:
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)
declare i64 @des_encrypt(i64, i64)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 0x123456789ABCDEF, i64 0x133457799BBCDFF1)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0, i64 %cipher)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @puts(i8* %2)
  ret i32 0
}