; ModuleID = 'sub_140002A30.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._iobuf = type opaque

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare %struct._iobuf* @__acrt_iob_func(i32 noundef)
declare i32 @sub_1400029C0(%struct._iobuf* noundef, i8* noundef, ...)
declare void @_exit(i32 noundef) noreturn

define void @sub_140002A30(i32 noundef %code) noreturn {
entry:
  %stderr.ptr = call %struct._iobuf* @__acrt_iob_func(i32 noundef 2)
  %fmt.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call.fprintf = call i32 (%struct._iobuf*, i8*, ...) @sub_1400029C0(%struct._iobuf* noundef %stderr.ptr, i8* noundef %fmt.ptr, i32 noundef %code)
  call void @_exit(i32 noundef 255)
  unreachable
}