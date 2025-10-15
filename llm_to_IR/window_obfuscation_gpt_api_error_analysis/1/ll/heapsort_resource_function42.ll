; ModuleID = 'sub_140002A30.ll'
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(i8*, i8*, i32)
declare void @_exit(i32) noreturn nounwind

define void @sub_140002A30(i32 %err) nounwind {
entry:
  %stream = call i8* @__acrt_iob_func(i32 2)
  %fmt = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  %callprint = call i32 @sub_1400029C0(i8* %stream, i8* %fmt, i32 %err)
  call void @_exit(i32 255)
  unreachable
}