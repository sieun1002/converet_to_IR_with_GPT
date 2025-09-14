; ModuleID = 'main.ll'
source_filename = "main"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main() {
entry:
  %key = alloca i64, align 8
  %pt = alloca i64, align 8
  %ct = alloca i64, align 8
  store i64 0x133457799BBCDFF1, i64* %key, align 8
  store i64 0x0123456789ABCDEF, i64* %pt, align 8
  %pt.val = load i64, i64* %pt, align 8
  %key.val = load i64, i64* %key, align 8
  %enc = call i64 @des_encrypt(i64 %pt.val, i64 %key.val)
  store i64 %enc, i64* %ct, align 8
  %enc.loaded = load i64, i64* %ct, align 8
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmtptr, i64 %enc.loaded)
  %s = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %call.puts = call i32 @puts(i8* %s)
  ret i32 0
}