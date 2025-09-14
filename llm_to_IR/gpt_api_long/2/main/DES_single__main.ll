; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x1747
; Intent: Run DES test vector and print ciphertext (confidence=0.95). Evidence: DES key/plaintext constants; reference string with expected ciphertext.
; Preconditions: None
; Postconditions: Prints ciphertext in hex and the known-answer string.

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

; Only the needed extern declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %key_hi = shl i64 322197369, 32
  %key = or i64 %key_hi, 2612846577
  %pt_hi = shl i64 19088743, 32
  %pt = or i64 %pt_hi, 2309737967
  %ct = call i64 @des_encrypt(i64 %pt, i64 %key)
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %ct)
  %sptr = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %sptr)
  ret i32 0
}