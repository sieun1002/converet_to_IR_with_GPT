; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel  ; Address: 0x1316
; Intent: DES Feistel round: expand 32-bit R with E to 48 bits, XOR with subkey, then apply S-boxes and P permutation (confidence=0.95). Evidence: constants 0x20/0x30 and symbols E, sboxes_p
; Preconditions: %r is a 32-bit right half; %subkey lower 48 bits are significant; @E points to the DES E-expansion table
; Postconditions: Returns 32-bit Feistel output in low bits of i64

@E = external global i8

; Only the needed extern declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i64 @sboxes_p(i64)

define dso_local i64 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r_zext = zext i32 %r to i64
  %exp = call i64 @permute(i64 %r_zext, i8* @E, i32 48, i32 32)
  %x = xor i64 %exp, %subkey
  %res = call i64 @sboxes_p(i64 %x)
  ret i64 %res
}