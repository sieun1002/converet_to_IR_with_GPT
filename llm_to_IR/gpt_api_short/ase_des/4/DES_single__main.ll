; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x1747
; Intent: DES test: encrypt a fixed plaintext with a fixed key, print result and known expected ciphertext (confidence=0.96). Evidence: constants 0x0123456789ABCDEF and 0x133457799BBCDFF1; strings "Ciphertext: %016llX\n" and "Ciphertext: 85E813540F0AB405"
; Preconditions: none
; Postconditions: returns 0

; Only the necessary external declarations:
declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

@format = private unnamed_addr constant [22 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %ct = call i64 @des_encrypt(i64 81985529216486895, i64 1383827165325090801)
  %fmtptr = getelementptr inbounds [22 x i8], [22 x i8]* @format, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %ct)
  %sptr = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %sptr)
  ret i32 0
}