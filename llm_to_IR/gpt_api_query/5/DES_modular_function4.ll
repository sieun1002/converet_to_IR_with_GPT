; ModuleID = 'feistel'
source_filename = "feistel"
target triple = "x86_64-unknown-linux-gnu"

@E = external constant [48 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define i32 @feistel(i32 %R, i64 %subkey) local_unnamed_addr {
entry:
  %R64 = zext i32 %R to i64
  %E_ptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %exp = call i64 @permute(i64 %R64, i8* %E_ptr, i32 48, i32 32)
  %mix = xor i64 %exp, %subkey
  %out = call i32 @sboxes_p(i64 %mix)
  ret i32 %out
}