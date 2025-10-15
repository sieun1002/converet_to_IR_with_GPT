; ModuleID = 'sub_1400029D0_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002960(i8*, i8*, i32)
declare void @_exit(i32) noreturn

define dso_local void @sub_1400029D0(i32 %arg) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call = call i32 @sub_140002960(i8* %stream, i8* %fmt, i32 %arg)
  call void @_exit(i32 255)
  unreachable
}