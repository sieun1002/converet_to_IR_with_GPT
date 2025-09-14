; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES Feistel round (expand R with E, XOR with subkey, S-box + P) (confidence=0.88). Evidence: permute(E, 48,32) then sboxes_p call.
; Preconditions: None
; Postconditions: Returns 32-bit round function output.

; Only the necessary external declarations:
@E = external global i8
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r_zext = zext i32 %r to i64
  %exp = call i64 @permute(i64 %r_zext, i8* @E, i32 48, i32 32)
  %mix = xor i64 %exp, %subkey
  %out = call i32 @sboxes_p(i64 %mix)
  ret i32 %out
}