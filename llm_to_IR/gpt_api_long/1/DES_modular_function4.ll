; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel F-function (expand with E, XOR with subkey, apply S-boxes+P) (confidence=0.92). Evidence: use of E table with 0x20->0x30 expansion, call to sboxes_p
; Preconditions: subkey significant in low 48 bits; higher bits ignored
; Postconditions: returns 32-bit S-boxes+P result

@E = external global i8

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %R, i64 %subkey) local_unnamed_addr {
entry:
  %R64 = zext i32 %R to i64
  %expanded = call i64 @permute(i64 %R64, i8* @E, i32 48, i32 32)
  %x = xor i64 %expanded, %subkey
  %r = call i32 @sboxes_p(i64 %x)
  ret i32 %r
}