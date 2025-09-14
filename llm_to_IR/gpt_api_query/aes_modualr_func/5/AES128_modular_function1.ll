; ModuleID = 'sbox_module'
source_filename = "sbox_module"
target triple = "x86_64-pc-linux-gnu"

@SBOX_1 = external global [256 x i8], align 1

define dso_local i32 @sbox_lookup(i32 %x) {
entry:
  %x_trunc = trunc i32 %x to i8
  %idx = zext i8 %x_trunc to i64
  %eltptr = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx
  %val = load i8, i8* %eltptr, align 1
  %val_ext = zext i8 %val to i32
  ret i32 %val_ext
}