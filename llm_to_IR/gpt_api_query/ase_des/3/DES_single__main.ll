; ModuleID = 'recovered.ll'
source_filename = "recovered"

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8 = alloca i64, align 8
  store i64 1383827165325090801, i64* %var_18, align 8
  store i64 81985529216486895, i64* %var_10, align 8
  %0 = load i64, i64* %var_18, align 8
  %1 = load i64, i64* %var_10, align 8
  %2 = call i64 @des_encrypt(i64 %1, i64 %0)
  store i64 %2, i64* %var_8, align 8
  %3 = load i64, i64* %var_8, align 8
  %4 = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %5 = call i32 (i8*, ...) @printf(i8* nonnull %4, i64 %3)
  %6 = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %7 = call i32 @puts(i8* nonnull %6)
  ret i32 0
}