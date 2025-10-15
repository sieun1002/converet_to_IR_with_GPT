; ModuleID = 'sub_140002A30_module'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.str.runtime_error = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32)
declare i32 @sub_1400029C0(%struct._iobuf*, i8*, i32)
declare void @_exit(i32) noreturn

define dso_local void @sub_140002A30(i32 %err) noreturn {
entry:
  %stream = call %struct._iobuf* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.runtime_error, i64 0, i64 0
  %printed = call i32 @sub_1400029C0(%struct._iobuf* %stream, i8* %fmtptr, i32 %err)
  call void @_exit(i32 255)
  unreachable
}