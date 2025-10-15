; ModuleID = 'hello.ll'
source_filename = "hello.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [15 x i8] c"Hello, world!\0A\00", align 1

declare dllimport i32 @printf(i8*, ...)

define dso_local i32 @main() {
entry:
  %fmtptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr)
  ret i32 0
}