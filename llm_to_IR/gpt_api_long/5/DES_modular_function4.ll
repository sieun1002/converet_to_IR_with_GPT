; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel round: expand 32→48 (E), XOR with subkey, S-boxes then P (confidence=0.92). Evidence: permute with E and sizes 32/48; call to sboxes_p.
; Preconditions: Subkey is expected in low 48 bits.
; Postconditions: Returns 32-bit round function output.

; Only the needed extern declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)
@E = external global i8

define dso_local i32 @feistel(i32 %x, i64 %k) local_unnamed_addr {
entry:
  %0 = zext i32 %x to i64
  %1 = call i64 @permute(i64 %0, i8* @E, i32 48, i32 32)
  %2 = xor i64 %1, %k
  %3 = call i32 @sboxes_p(i64 %2)
  ret i32 %3
}