; ModuleID = 'feistel.ll'
target triple = "x86_64-pc-linux-gnu"

@E = external global [48 x i8], align 1

declare i64 @permute(i64, i8*, i32, i32)
declare i32 @sboxes_p(i64)

define i32 @feistel(i32 %r, i64 %subkey) {
entry:
  %r64 = zext i32 %r to i64
  %Eptr = bitcast [48 x i8]* @E to i8*
  %perm = call i64 @permute(i64 %r64, i8* %Eptr, i32 48, i32 32)
  %x = xor i64 %perm, %subkey
  %out = call i32 @sboxes_p(i64 %x)
  ret i32 %out
}