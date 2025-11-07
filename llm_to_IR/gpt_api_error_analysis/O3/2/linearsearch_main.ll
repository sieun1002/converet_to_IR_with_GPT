; ModuleID = 'main_module'
source_filename = "main.c"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %call = tail call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* getelementptr inbounds ([27 x i8], [27 x i8]* @.str, i64 0, i64 0), i32 3)
  ret i32 0
}