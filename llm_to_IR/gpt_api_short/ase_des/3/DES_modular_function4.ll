; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES Feistel f-function (confidence=0.88). Evidence: uses E expansion (32->48) via permute; calls sboxes_p.
; Preconditions: right (i32) is 32-bit half-block; subkey (i64) holds 48-bit round key in low bits.
; Postconditions: returns 32-bit F-function output.

; Only the necessary external declarations:
@E = external global [48 x i8]
declare i64 @permute(i64, i8*, i64, i64) local_unnamed_addr
declare i32 @sboxes_p(i64) local_unnamed_addr

define dso_local i32 @feistel(i32 %right, i64 %subkey) local_unnamed_addr {
entry:
  %E_ptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %right_z = zext i32 %right to i64
  %expanded = call i64 @permute(i64 %right_z, i8* %E_ptr, i64 48, i64 32)
  %x = xor i64 %expanded, %subkey
  %f = call i32 @sboxes_p(i64 %x)
  ret i32 %f
}