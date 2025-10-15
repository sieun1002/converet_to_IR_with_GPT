; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str = internal constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, ...)
declare dso_local void @_exit(i32)

define dso_local void @sub_140002A30(i32 %0) {
entry:
  %call.iob = call i8* @__acrt_iob_func(i32 2)
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call.print = call i32 (i8*, i8*, ...) @sub_1400029C0(i8* %call.iob, i8* %fmt.ptr, i32 %0)
  call void @_exit(i32 255)
  unreachable
}