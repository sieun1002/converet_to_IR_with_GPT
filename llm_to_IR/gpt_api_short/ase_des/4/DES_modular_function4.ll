; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES Feistel F-function (confidence=0.86). Evidence: uses E expansion table (32->48) and calls sboxes_p after XOR with subkey
; Preconditions: None
; Postconditions: Returns 32-bit F-function output

@E = external constant [48 x i8]

; Only the necessary external declarations:
declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %r, i64 %subkey) local_unnamed_addr {
entry:
  %r.zext = zext i32 %r to i64
  %E.ptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %perm = call i64 @permute(i64 %r.zext, i8* %E.ptr, i32 48, i32 32)
  %x = xor i64 %perm, %subkey
  %out = call i32 @sboxes_p(i64 %x)
  ret i32 %out
}