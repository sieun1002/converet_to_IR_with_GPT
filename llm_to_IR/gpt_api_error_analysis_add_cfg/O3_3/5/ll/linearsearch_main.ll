; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@aElementFoundAt = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)

define dso_local i32 @main() {
loc_1060:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 3)
  br label %loc_1080

loc_1080:
  ret i32 0
}