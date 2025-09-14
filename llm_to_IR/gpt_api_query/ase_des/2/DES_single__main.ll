; ModuleID = 'des_main.ll'
source_filename = "des_main.c"
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [22 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %cipher = call i64 @des_encrypt(i64 0x0123456789ABCDEF, i64 0x133457799BBCDFF1)
  %fmtptr = getelementptr inbounds [22 x i8], [22 x i8]* @format, i64 0, i64 0
  %0 = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %cipher)
  %sptr = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %1 = call i32 @puts(i8* %sptr)
  ret i32 0
}