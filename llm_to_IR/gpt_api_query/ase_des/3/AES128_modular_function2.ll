@RCON_0 = external dso_local global i8, align 1

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %t = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %t, 9
  br i1 %cmp, label %ret0, label %inrange

inrange:
  %idx = zext i8 %t to i64
  %ptr = getelementptr inbounds i8, i8* @RCON_0, i64 %idx
  %val8 = load i8, i8* %ptr, align 1
  %val = zext i8 %val8 to i32
  ret i32 %val

ret0:
  ret i32 0
}