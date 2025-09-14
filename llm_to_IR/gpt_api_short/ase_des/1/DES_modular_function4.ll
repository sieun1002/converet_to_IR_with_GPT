; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES Feistel round function (confidence=0.85). Evidence: uses E expansion table (32->48) then calls sboxes_p
; Preconditions: None
; Postconditions: Returns 32-bit F-function result

; Only the necessary external declarations:
; declare i64 @permute(i64, i8*, i32, i32)
; declare i32 @sboxes_p(i64)

@E = external dso_local global i8

declare dso_local i64 @permute(i64, i8*, i32, i32)
declare dso_local i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %arg0, i64 %arg1) local_unnamed_addr {
entry:
  %0 = zext i32 %arg0 to i64
  %1 = call i64 @permute(i64 %0, i8* @E, i32 48, i32 32)
  %2 = xor i64 %1, %arg1
  %3 = call i32 @sboxes_p(i64 %2)
  ret i32 %3
}