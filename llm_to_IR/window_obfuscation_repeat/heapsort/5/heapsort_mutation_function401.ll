; ModuleID = 'fixed_module'
source_filename = "fixed_module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare dso_local i8* @__acrt_iob_func(i32)
declare dso_local i32 @sub_1400029C0(i8*, i8*, i32)
declare dso_local void @_exit(i32) noreturn

define dso_local void @sub_140002A30(i32 %code) {
entry:
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %stream = call i8* @__acrt_iob_func(i32 2)
  %call = call i32 @sub_1400029C0(i8* %stream, i8* %fmt.ptr, i32 %code)
  call void @_exit(i32 255)
  unreachable
}