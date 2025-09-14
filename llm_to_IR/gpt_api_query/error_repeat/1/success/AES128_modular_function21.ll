; ModuleID = 'rcon'
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@RCON_0 = external constant i8, align 1

define dso_local i32 @rcon(i32 %arg) local_unnamed_addr #0 {
entry:
  %trunc = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %trunc, 9
  br i1 %cmp, label %ret0, label %inrange

inrange:
  %idx.ext = zext i8 %trunc to i64
  %elem.ptr = getelementptr inbounds i8, i8* @RCON_0, i64 %idx.ext
  %val = load i8, i8* %elem.ptr, align 1
  %res = zext i8 %val to i32
  ret i32 %res

ret0:
  ret i32 0
}

attributes #0 = { nounwind readonly }