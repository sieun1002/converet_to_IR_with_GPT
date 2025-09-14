; ModuleID = 'feistel'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: feistel ; Address: 0x1316
; Intent: DES-style Feistel F-function (confidence=0.86). Evidence: use of E expansion table via permute; call to sboxes_p
; Preconditions: None
; Postconditions: Returns 32-bit Feistel output from S-boxes and P permutation

@E = external dso_local global i8

; Only the necessary external declarations:
declare dso_local i64 @permute(i32, i8*, i32, i32)
declare dso_local i32 @sboxes_p(i64)

define dso_local i32 @feistel(i32 %block, i64 %subkey) local_unnamed_addr {
entry:
  %perm = call i64 @permute(i32 %block, i8* @E, i32 48, i32 32)
  %x = xor i64 %perm, %subkey
  %r = call i32 @sboxes_p(i64 %x)
  ret i32 %r
}