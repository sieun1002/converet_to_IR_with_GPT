; ModuleID = 'sbox_module'
target triple = "x86_64-unknown-linux-gnu"

@SBOX_1 = external global [256 x i8]

define dso_local i32 @sbox_lookup(i32 %x) {
entry:
  %trunc = trunc i32 %x to i8
  %idx.ext = zext i8 %trunc to i64
  %elem.ptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx.ext
  %val8 = load i8, i8* %elem.ptr, align 1
  %val32 = zext i8 %val8 to i32
  ret i32 %val32
}