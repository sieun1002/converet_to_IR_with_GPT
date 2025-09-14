; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel F-function: expand (E), XOR with subkey, then S-boxes+P (confidence=0.95). Evidence: constants 32/48 and E table; calls permute and sboxes_p
; Preconditions: Only lower 32 bits of the first argument and lower 48 bits of the second argument are semantically used.
; Postconditions: Returns a 32-bit value (DES F-function output).

@E = external global i8

; Only the needed extern declarations:
declare i64 @permute(i64, i8*, i64, i64)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %R, i64 %subkey) local_unnamed_addr {
entry:
  %0 = zext i32 %R to i64
  %1 = call i64 @permute(i64 %0, i8* @E, i64 48, i64 32)
  %2 = xor i64 %1, %subkey
  %3 = call i32 @sboxes_p(i64 %2)
  ret i32 %3
}