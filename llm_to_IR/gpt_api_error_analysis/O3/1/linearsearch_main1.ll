; ModuleID = 'main.ll'
source_filename = "main.ll"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @__printf_chk(i32 noundef, i8* noundef, ...)

define i32 @main() {
entry:
  %0 = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %1 = call i32 (i32, i8*, ...) @__printf_chk(i32 noundef 2, i8* noundef %0, i32 noundef 3)
  ret i32 0
}