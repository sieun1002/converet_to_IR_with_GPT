; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x15CB
; Intent: DES demo: encrypt fixed plaintext with fixed key and print result (confidence=0.86). Evidence: call to des_encrypt with two 64-bit immediates; printf with "%016llX" and expected ciphertext string
; Preconditions: none
; Postconditions: returns 0

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

; Only the necessary external declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local i32 @main() local_unnamed_addr {
entry:
  ; key = 0x133457799BBCDFF1 = (0x13345779 << 32) | 0x9BBCDFF1
  %key_hi = shl i64 322197369, 32
  %key = add i64 %key_hi, 2612846577
  ; plaintext = 0x0123456789ABCDEF
  %cipher = call i64 @des_encrypt(i64 81985529216486895, i64 %key)
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %callprintf = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %cipher)
  %s2 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %callputs = call i32 @puts(i8* %s2)
  ret i32 0
}