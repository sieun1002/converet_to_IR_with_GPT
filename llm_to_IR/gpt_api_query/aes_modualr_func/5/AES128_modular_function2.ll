; ModuleID = 'rcon.ll'
source_filename = "rcon"
target triple = "x86_64-pc-linux-gnu"

@RCON_0 = external global i8, align 1

define i32 @rcon(i32 %arg) {
entry:
  %trunc = trunc i32 %arg to i8
  %cmp = icmp ugt i8 %trunc, 9
  br i1 %cmp, label %retzero, label %inrange

inrange:
  %idxz = zext i8 %trunc to i64
  %ptr = getelementptr inbounds i8, i8* @RCON_0, i64 %idxz
  %val = load i8, i8* %ptr, align 1
  %zext = zext i8 %val to i32
  ret i32 %zext

retzero:
  ret i32 0
}