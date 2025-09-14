; ModuleID = 'recovered'
source_filename = "recovered.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8

  store i64 0x133457799BBCDFF1, i64* %var_18, align 8
  store i64 0x123456789ABCDEF, i64* %var_10, align 8

  %0 = load i64, i64* %var_18, align 8
  %1 = load i64, i64* %var_10, align 8
  %2 = call i64 @des_encrypt(i64 %1, i64 %0)
  store i64 %2, i64* %var_8, align 8

  %3 = load i64, i64* %var_8, align 8
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call_printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %3)

  %sptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %call_puts = call i32 @puts(i8* %sptr)

  ret i32 0
}