; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"Ciphertext: %016llX\0A\00", align 1
@.str.1 = private unnamed_addr constant [29 x i8] c"Ciphertext: 85E813540F0AB405\00", align 1

declare i64 @des_encrypt(i64, i64)
declare i32 @printf(i8*, ...)
declare i32 @puts(i8*)

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %cipher = call i64 @des_encrypt(i64 81985529216486895, i64 1383827165325090801)
  %fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %_ = call i32 (i8*, ...) @printf(i8* %fmt, i64 %cipher)
  %s = getelementptr inbounds [29 x i8], [29 x i8]* @.str.1, i64 0, i64 0
  %_2 = call i32 @puts(i8* %s)
  ret i32 0
}