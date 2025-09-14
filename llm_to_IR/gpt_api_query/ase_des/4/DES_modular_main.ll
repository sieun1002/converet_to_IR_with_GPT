; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8  = alloca i64, align 8

  store i64 0x133457799BBCDFF1, i64* %var_18, align 8
  store i64 0x123456789ABCDEF,  i64* %var_10, align 8

  %plain = load i64, i64* %var_10, align 8
  %key   = load i64, i64* %var_18, align 8
  %ct    = call i64 @des_encrypt(i64 %plain, i64 %key)
  store i64 %ct, i64* %var_8, align 8

  %ct_loaded = load i64, i64* %var_8, align 8
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %ct_loaded)

  %strptr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  call i32 @puts(i8* %strptr)

  ret i32 0
}