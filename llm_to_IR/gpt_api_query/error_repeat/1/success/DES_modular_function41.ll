; ModuleID = 'feistel'
source_filename = "feistel.ll"
target triple = "x86_64-unknown-linux-gnu"

@E = external constant [48 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)
declare i64 @sboxes_p(i64)

define i64 @feistel(i32 %R, i64 %K) {
entry:
  %R_zext = zext i32 %R to i64
  %E_ptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %perm = call i64 @permute(i64 %R_zext, i8* %E_ptr, i32 48, i32 32)
  %x = xor i64 %perm, %K
  %res = call i64 @sboxes_p(i64 %x)
  ret i64 %res
}