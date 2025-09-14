; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x15CB
; Intent: Run DES on a known test vector and print the ciphertext (confidence=0.95). Evidence: Known DES test vectors (0x0123456789ABCDEF, 0x133457799BBCDFF1) and "%016llX" formatting.

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; plaintext = 0x0123456789ABCDEF
  %block_hi32 = zext i32 19088743 to i64
  %block_hi = shl i64 %block_hi32, 32
  %block = or i64 %block_hi, 2309737967
  ; key = 0x133457799BBCDFF1
  %key_hi32 = zext i32 322197369 to i64
  %key_hi = shl i64 %key_hi32, 32
  %key = or i64 %key_hi, 2612846577
  %cipher = call i64 @des_encrypt(i64 %block, i64 %key)
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt, i64 %cipher)
  %s = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 @puts(i8* %s)
  ret i32 0
}