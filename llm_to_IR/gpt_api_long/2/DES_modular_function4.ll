; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel round function F (confidence=0.95). Evidence: E expansion 32->48, XOR with subkey, S-boxes+P call
; Preconditions: subkey uses the low 48 bits; half is a 32-bit right half-block
; Postconditions: returns 32-bit output after S-boxes and P permutation

@E = external global i8

declare dso_local i64 @permute(i64, i8*, i32, i32)
declare dso_local i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %half, i64 %subkey) local_unnamed_addr {
entry:
  %0 = zext i32 %half to i64
  %1 = call i64 @permute(i64 %0, i8* @E, i32 48, i32 32)
  %2 = xor i64 %1, %subkey
  %3 = call i32 @sboxes_p(i64 %2)
  ret i32 %3
}