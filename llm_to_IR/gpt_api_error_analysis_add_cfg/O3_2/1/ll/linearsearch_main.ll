; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@aElementFoundAt = constant [27 x i8] c"Element found at index %d\0A\00"

declare i32 @___printf_chk(i32, i8*, ...)

define i32 @main() {
_1060:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @aElementFoundAt, i64 0, i64 0
  call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 3)
  ret i32 0
}