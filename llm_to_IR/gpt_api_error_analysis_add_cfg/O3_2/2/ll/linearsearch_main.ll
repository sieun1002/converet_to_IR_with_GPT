; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare dso_local i32 @___printf_chk(i32, i8*, ...)

define dso_local i32 @main() {
entry:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmtptr, i32 3)
  ret i32 0
}