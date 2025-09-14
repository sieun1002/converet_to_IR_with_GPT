; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64 noundef, i64 noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @puts(i8* noundef)

define i32 @main(i32 noundef %argc, i8** noundef %argv) {
entry:
  %var_18 = alloca i64, align 8
  %var_10 = alloca i64, align 8
  %var_8  = alloca i64, align 8

  ; var_18 = 0x133457799BBCDFF1
  store i64 1383827165325090801, i64* %var_18, align 8
  ; var_10 = 0x0123456789ABCDEF
  store i64 81985529216486895, i64* %var_10, align 8

  %rdx = load i64, i64* %var_18, align 8
  %rax = load i64, i64* %var_10, align 8
  %call = call i64 @des_encrypt(i64 noundef %rax, i64 noundef %rdx)
  store i64 %call, i64* %var_8, align 8

  %res = load i64, i64* %var_8, align 8
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i64 %res)

  %cstr = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  call i32 @puts(i8* noundef %cstr)

  ret i32 0
}