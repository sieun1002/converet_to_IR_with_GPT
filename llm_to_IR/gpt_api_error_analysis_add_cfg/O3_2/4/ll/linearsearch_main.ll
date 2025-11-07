; ModuleID = 'recovered'
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [27 x i8] c"Element found at index %d\0A\00", align 1

declare i32 @___printf_chk(i32, i8*, i32)

define i32 @main(i32 %argc, i8** %argv) {
L1060:
  %fmt.ptr = getelementptr inbounds [27 x i8], [27 x i8]* @.str, i64 0, i64 0
  %call = call i32 @___printf_chk(i32 2, i8* %fmt.ptr, i32 3)
  ret i32 0
}