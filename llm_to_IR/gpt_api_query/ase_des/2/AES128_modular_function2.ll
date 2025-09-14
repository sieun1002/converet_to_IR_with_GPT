; ModuleID = 'rcon.ll'
target triple = "x86_64-pc-linux-gnu"

@RCON_0 = external constant [10 x i8], align 1

define dso_local zeroext i8 @rcon(i32 %arg) {
entry:
  %b = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %b, 9
  br i1 %cmp, label %ret_zero, label %lookup

lookup:
  %idx = zext i8 %b to i64
  %ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx
  %val = load i8, i8* %ptr, align 1
  ret i8 %val

ret_zero:
  ret i8 0
}