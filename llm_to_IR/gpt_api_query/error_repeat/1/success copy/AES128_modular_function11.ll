; ModuleID = 'sbox_module'
source_filename = "sbox.ll"
target triple = "x86_64-unknown-linux-gnu"

@SBOX_1 = external dso_local global [256 x i8], align 1

define dso_local i8 @sbox_lookup(i32 %x) local_unnamed_addr nounwind readonly {
entry:
  %t0 = trunc i32 %x to i8
  %idx64 = zext i8 %t0 to i64
  %p = getelementptr inbounds [256 x i8], [256 x i8]* @SBOX_1, i64 0, i64 %idx64
  %val = load i8, i8* %p, align 1
  ret i8 %val
}