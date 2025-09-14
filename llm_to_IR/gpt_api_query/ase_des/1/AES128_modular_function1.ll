; ModuleID = 'sbox_module'
target triple = "x86_64-pc-linux-gnu"

@SBOX_1 = external global [256 x i8], align 1

define i32 @sbox_lookup(i32 %x) local_unnamed_addr {
entry:
  %trunc = trunc i32 %x to i8
  %idx.ext = zext i8 %trunc to i64
  %ptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx.ext
  %val = load i8, i8* %ptr, align 1
  %res = zext i8 %val to i32
  ret i32 %res
}