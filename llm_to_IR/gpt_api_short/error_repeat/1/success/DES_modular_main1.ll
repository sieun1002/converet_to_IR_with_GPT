; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: compute and print DES ciphertext for a known test vector (confidence=0.90). Evidence: call to des_encrypt with 64-bit constants; prints "Ciphertext: %016llX" and known expected ciphertext string.
; Preconditions: external des_encrypt(i64,i64) must be provided; printf/puts available.
; Postconditions: prints two lines with computed and expected ciphertext; returns 0.

; Only the necessary external declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00"
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %hi_p = shl i64 19088743, 32
  %pl = or i64 %hi_p, 2309737967
  %hi_k = shl i64 322197369, 32
  %key = or i64 %hi_k, 2612846577
  %ct = call i64 @des_encrypt(i64 %pl, i64 %key)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %1 = call i32 (i8*, ...) @printf(i8* %0, i64 %ct)
  %2 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %3 = call i32 @puts(i8* %2)
  ret i32 0
}