; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, ...)

define i32 @main() {
bb_1060:
  %0 = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %0, i32 3)
  br label %bb_1080

bb_1080:
  ret i32 0
}