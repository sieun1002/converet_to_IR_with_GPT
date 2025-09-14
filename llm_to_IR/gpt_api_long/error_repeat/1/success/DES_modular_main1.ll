; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x15CB
; Intent: DES encrypt a fixed plaintext with a fixed key, print the ciphertext and a known reference string (confidence=0.95). Evidence: classic DES test vectors; printf format "%016llX".
; Preconditions: none
; Postconditions: returns 0

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

; Only the needed extern declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %call = call i64 @des_encrypt(i64 81985529216486895, i64 1383827165325090801)
  %0 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %0, i64 %call)
  %1 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %call2 = call i32 @puts(i8* %1)
  ret i32 0
}