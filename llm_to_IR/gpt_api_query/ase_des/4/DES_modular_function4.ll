; ModuleID = 'feistel.ll'
source_filename = "feistel.ll"

@E = external constant [48 x i8], align 1

declare i64 @permute(i64, i8*, i64, i64)
declare i32 @sboxes_p(i64)

define i32 @feistel(i32 %R, i64 %subkey) {
entry:
  %R_zext = zext i32 %R to i64
  %E_ptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %perm = call i64 @permute(i64 %R_zext, i8* %E_ptr, i64 48, i64 32)
  %x = xor i64 %perm, %subkey
  %res = call i32 @sboxes_p(i64 %x)
  ret i32 %res
}