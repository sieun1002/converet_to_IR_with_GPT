; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel round (E expansion, XOR with subkey, S-boxes+P) (confidence=0.95). Evidence: permute with 32→48 using E; call to sboxes_p
; Preconditions: Lower 32 bits of %r are used; lower 48 bits of %subkey are meaningful.
; Postconditions: Returns 32-bit F-function output.

@E = external global i8

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r_zext = zext i32 %r to i64
  %exp = call i64 @permute(i64 %r_zext, i8* @E, i32 48, i32 32)
  %x = xor i64 %exp, %subkey
  %res = call i32 @sboxes_p(i64 %x)
  ret i32 %res
}