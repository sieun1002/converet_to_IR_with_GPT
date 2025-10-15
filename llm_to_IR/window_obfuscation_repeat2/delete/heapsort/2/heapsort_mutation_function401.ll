; ModuleID: 'module'
source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = internal constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i32)
declare void @_exit(i32) noreturn

define void @sub_140002A30(i32 %arg) {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %call = call i32 @sub_1400029C0(i8* %stream, i8* %fmtptr, i32 %arg)
  call void @_exit(i32 255)
  unreachable
}