; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [14 x i8] c"Hello, world!\00", align 1

declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main() {
entry:
  %ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %ptr)
  ret i32 0
}