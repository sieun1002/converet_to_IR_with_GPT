; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1747
; Intent: Demonstrate DES encryption with known test vectors and print result (confidence=0.97). Evidence: constants 0x0123456789ABCDEF and 0x133457799BBCDFF1; prints expected ciphertext 85E813540F0AB405.
; Preconditions: None
; Postconditions: Prints two lines and returns 0

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00"
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00"

; Only the necessary external declarations:
declare dso_local i64 @des_encrypt(i64, i64)
declare dso_local i32 @_printf(i8*, ...)
declare dso_local i32 @_puts(i8*)

define dso_local i32 @main() local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 0x123456789ABCDEF, i64 0x133457799BBCDFF1)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %1 = call i32 (i8*, ...) @_printf(i8* %0, i64 %cipher)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %3 = call i32 @_puts(i8* %2)
  ret i32 0
}