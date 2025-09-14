; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1747
; Intent: Run DES test vector: encrypt a block and print result and reference (confidence=0.95). Evidence: Known DES key 0x133457799BBCDFF1 and plaintext 0x0123456789ABCDEF
; Preconditions: None
; Postconditions: Prints two lines to stdout

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; plaintext = 0x0123456789ABCDEF = (0x01234567 << 32) | 0x89ABCDEF
  %pt_hi = shl i64 19088743, 32
  %pt = or i64 %pt_hi, 2309737967

  ; key = 0x133457799BBCDFF1 = (0x13345779 << 32) | 0x9BBCDFF1
  %key_hi = shl i64 322197369, 32
  %key = or i64 %key_hi, 2612846577

  %ct = call i64 @des_encrypt(i64 %pt, i64 %key)

  %fmt_ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt_ptr, i64 %ct)

  %ref_ptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %__ = call i32 @puts(i8* %ref_ptr)

  ret i32 0
}