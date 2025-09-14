; ModuleID = 'rcon.ll'
target triple = "x86_64-unknown-linux-gnu"

@RCON_0 = external constant [10 x i8], align 1

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr {
entry:
  %tr = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %tr, 9
  br i1 %cmp, label %ret0, label %inrange

inrange:                                          ; preds = %entry
  %idx.ext = zext i8 %tr to i64
  %ptr = getelementptr inbounds [10 x i8], [10 x i8]* @RCON_0, i64 0, i64 %idx.ext
  %val = load i8, i8* %ptr, align 1
  %valz = zext i8 %val to i32
  ret i32 %valz

ret0:                                             ; preds = %entry
  ret i32 0
}