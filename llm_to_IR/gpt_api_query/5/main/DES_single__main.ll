; ModuleID = 'binary'
source_filename = "binary"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_puts(i8*)

define dso_local i32 @main() {
entry:
  %var18 = alloca i64, align 8
  %var10 = alloca i64, align 8
  %var8 = alloca i64, align 8
  store i64 0x133457799BBCDFF1, i64* %var18, align 8
  store i64 0x0123456789ABCDEF, i64* %var10, align 8
  %0 = load i64, i64* %var18, align 8
  %1 = load i64, i64* %var10, align 8
  %2 = call i64 @des_encrypt(i64 %1, i64 %0)
  store i64 %2, i64* %var8, align 8
  %3 = load i64, i64* %var8, align 8
  %4 = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %5 = call i32 (i8*, ...) @_printf(i8* %4, i64 %3)
  %6 = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %7 = call i32 @_puts(i8* %6)
  ret i32 0
}