; ModuleID = 'xtime_lifted'
source_filename = "xtime_lifted"
target triple = "x86_64-pc-linux-gnu"

define dso_local i32 @xtime(i32 %arg) local_unnamed_addr {
entry:
  %var_4 = alloca i8, align 1
  %al = trunc i32 %arg to i8
  store i8 %al, i8* %var_4, align 1
  %0 = load i8, i8* %var_4, align 1
  %x32 = zext i8 %0 to i32
  %twice = shl i32 %x32, 1
  %1 = load i8, i8* %var_4, align 1
  %shr7i8 = lshr i8 %1, 7
  %b32 = zext i8 %shr7i8 to i32
  %t1 = add i32 %b32, %b32
  %t2 = add i32 %t1, %b32
  %t3 = shl i32 %t2, 3
  %mul27 = add i32 %t3, %t2
  %res = xor i32 %twice, %mul27
  ret i32 %res
}