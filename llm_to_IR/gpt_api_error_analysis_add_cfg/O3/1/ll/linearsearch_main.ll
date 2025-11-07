; ModuleID = 'main_from_0x1060_0x1087'
source_filename = "main_from_0x1060_0x1087"

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.element_found = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)

define dso_local i32 @main() {
addr_1060:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str.element_found, i64 0, i64 0
  %call.printf_chk = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 3)
  ret i32 0
}