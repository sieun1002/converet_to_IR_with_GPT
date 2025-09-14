; ModuleID = 'feistel'
source_filename = "feistel.ll"

@E = external dso_local constant [48 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)
declare i64 @sboxes_p(i64)

define dso_local i64 @feistel(i32 %x, i64 %subkey) local_unnamed_addr {
entry:
  %x_zext = zext i32 %x to i64
  %Eptr = getelementptr inbounds [48 x i8], [48 x i8]* @E, i64 0, i64 0
  %perm = call i64 @permute(i64 %x_zext, i8* %Eptr, i32 48, i32 32)
  %xored = xor i64 %perm, %subkey
  %res = call i64 @sboxes_p(i64 %xored)
  ret i64 %res
}