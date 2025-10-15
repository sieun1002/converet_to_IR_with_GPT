; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i32)
declare void @_exit(i32)

define void @sub_140002A30(i32 %0) {
entry:
  %1 = call i8* @__acrt_iob_func(i32 2)
  %2 = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %3 = call i32 @sub_1400029C0(i8* %1, i8* %2, i32 %0)
  call void @_exit(i32 255)
  unreachable
}