; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

declare i64 @des_encrypt(i64, i64)
declare i32 @_printf(i8*, ...)
declare i32 @_puts(i8*)

@format = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@s = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

define dso_local i32 @main() local_unnamed_addr {
entry:
  %pt = add i64 0, 81985529216486895
  %key = add i64 0, 1383827165325090801
  %ct = call i64 @des_encrypt(i64 %pt, i64 %key)
  %fmtptr = getelementptr inbounds [21 x i8], [21 x i8]* @format, i64 0, i64 0
  %_ = call i32 (i8*, ...) @_printf(i8* %fmtptr, i64 %ct)
  %sptr = getelementptr inbounds [29 x i8], [29 x i8]* @s, i64 0, i64 0
  %__ = call i32 @_puts(i8* %sptr)
  ret i32 0
}