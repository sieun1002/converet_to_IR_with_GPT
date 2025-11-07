; ModuleID = 'main_module'
source_filename = "main.s"
target triple = "x86_64-pc-linux-gnu"

@aElementFoundAt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, i32)

define i32 @main() {
bb_1060:
  %fmtptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  %call = call i32 @___printf_chk(i32 2, i8* %fmtptr, i32 3)
  ret i32 0
}