; ModuleID = 'xtime.ll'
source_filename = "xtime"
target triple = "x86_64-unknown-linux-gnu"

define i32 @xtime(i32 %arg) {
entry:
  %b = trunc i32 %arg to i8
  %zx = zext i8 %b to i32
  %twice = shl i32 %zx, 1
  %msb = lshr i8 %b, 7
  %msb32 = zext i8 %msb to i32
  %mul27 = mul i32 %msb32, 27
  %res = xor i32 %twice, %mul27
  ret i32 %res
}