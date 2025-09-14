; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x15CB
; Intent: Run DES test vector: encrypt plaintext with key, then print result and expected value (confidence=0.95). Evidence: known DES constants; matching ciphertext string
; Preconditions: des_encrypt takes (plaintext, key) as 64-bit values and returns 64-bit ciphertext
; Postconditions: prints two lines

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 0x0123456789ABCDEF, i64 0x133457799BBCDFF1)
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %cipher)
  %exp.ptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %exp.ptr)
  ret i32 0
}