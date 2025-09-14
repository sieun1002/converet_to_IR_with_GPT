; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES Feistel round (E-expansion, XOR subkey, S-boxes+P) (confidence=0.93). Evidence: loads E table with 0x20/0x30 sizes; XOR with 64-bit subkey; calls sboxes_p
; Preconditions: None
; Postconditions: Returns 32-bit round output

@E = external global i8

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r_zext = zext i32 %r to i64
  %perm = call i64 @permute(i64 %r_zext, i8* @E, i32 48, i32 32)
  %x = xor i64 %perm, %subkey
  %res = call i32 @sboxes_p(i64 %x)
  ret i32 %res
}